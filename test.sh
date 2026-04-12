#!/bin/bash
# 공냥이 차트 스킬 사전 테스트
# 설치 후 실행하여 모든 기능 정상 동작 확인

set -e

PASS=0
FAIL=0
WARN=0

check() {
  local name="$1"
  local cmd="$2"
  if eval "$cmd" >/dev/null 2>&1; then
    echo "  PASS: $name"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $name"
    FAIL=$((FAIL + 1))
  fi
}

warn() {
  local name="$1"
  local cmd="$2"
  if eval "$cmd" >/dev/null 2>&1; then
    echo "  PASS: $name"
    PASS=$((PASS + 1))
  else
    echo "  WARN: $name (선택 기능, 없어도 기본 동작 가능)"
    WARN=$((WARN + 1))
  fi
}

echo "=== 공냥이 차트 스킬 테스트 ==="
echo ""

echo "[스킬 파일]"
check "SKILL.md 존재" "test -f $HOME/.claude/skills/consulting-chart/SKILL.md"
check "예제 파일 존재" "test -d $HOME/.claude/skills/consulting-chart/examples"
check "카드뉴스 예제 존재" "ls $HOME/.claude/skills/consulting-chart/examples/cardnews/*.html 2>/dev/null | head -1"

echo ""
echo "[런타임 의존성]"
check "Node.js 설치" "command -v node"
warn "npm 설치" "command -v npm"

echo ""
echo "[렌더링 도구]"
CHROME_WSL="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
if [ -f "$CHROME_WSL" ]; then
  check "Chrome (WSL)" "test -f '$CHROME_WSL'"
else
  warn "Chrome (Linux)" "command -v google-chrome || command -v chromium-browser"
fi

echo ""
echo "[영상 도구]"
warn "ffmpeg" "command -v ffmpeg || find /mnt/c -name 'ffmpeg.exe' -path '*/bin/*' 2>/dev/null | head -1"

echo ""
echo "[Remotion 렌더링]"
if [ -d "$HOME/.chromium-libs/extracted/usr/lib/x86_64-linux-gnu" ]; then
  check "Chrome 라이브러리 (WSL)" "test -f $HOME/.chromium-libs/extracted/usr/lib/x86_64-linux-gnu/libnspr4.so"
else
  warn "Chrome 라이브러리" "ldd /usr/bin/chromium-browser 2>/dev/null | grep -v 'not found'"
fi

echo ""
echo "[HTML 렌더 테스트]"
SAMPLE="$HOME/.claude/skills/consulting-chart/examples/bar-chart.html"
if [ -f "$SAMPLE" ] && [ -f "$CHROME_WSL" ]; then
  TMPOUT="/tmp/gongnangi-test-render.png"
  "$CHROME_WSL" --headless=new --disable-gpu --hide-scrollbars \
    --screenshot="$(wslpath -w $TMPOUT)" \
    --window-size=960,500 \
    "file:///$(wslpath -w $SAMPLE)" 2>/dev/null
  if [ -f "$TMPOUT" ] && [ "$(stat -c%s $TMPOUT)" -gt 1000 ]; then
    echo "  PASS: HTML → PNG 렌더 정상"
    PASS=$((PASS + 1))
    rm -f "$TMPOUT"
  else
    echo "  FAIL: HTML → PNG 렌더 실패"
    FAIL=$((FAIL + 1))
  fi
else
  echo "  SKIP: 렌더 테스트 (Chrome 또는 샘플 파일 없음)"
fi

echo ""
echo "=== 결과: PASS=$PASS  FAIL=$FAIL  WARN=$WARN ==="
if [ "$FAIL" -eq 0 ]; then
  echo "모든 필수 테스트 통과!"
else
  echo "실패한 테스트가 있습니다. 위 FAIL 항목을 확인하세요."
  exit 1
fi
