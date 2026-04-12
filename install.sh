#!/bin/bash
# 공냥이 차트 스킬 자동 설치 스크립트
# 사용법: bash install.sh

set -e

SKILL_DIR="$HOME/.claude/skills/consulting-chart"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== 공냥이 차트 스킬 설치 ==="
echo ""

# 1. 스킬 디렉토리 생성
mkdir -p "$SKILL_DIR/examples/cardnews"
echo "[1/5] 스킬 디렉토리 생성: $SKILL_DIR"

# 2. 파일 복사
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
cp -r "$SCRIPT_DIR/examples/"* "$SKILL_DIR/examples/"
echo "[2/5] 스킬 파일 복사 완료"

# 3. Remotion 의존성 (선택)
if command -v node >/dev/null 2>&1; then
  NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
  if [ "$NODE_VERSION" -ge 18 ]; then
    echo "[3/5] Node.js $NODE_VERSION 확인됨"
  else
    echo "[3/5] WARNING: Node.js 18+ 필요 (현재: $NODE_VERSION)"
  fi
else
  echo "[3/5] WARNING: Node.js 미설치. Remotion 영상 기능 사용 불가."
fi

# 4. Chrome headless 확인
CHROME_WSL="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
CHROME_LINUX=$(which google-chrome 2>/dev/null || which chromium-browser 2>/dev/null || echo "")

if [ -f "$CHROME_WSL" ]; then
  echo "[4/5] Chrome 확인됨 (Windows/WSL)"
elif [ -n "$CHROME_LINUX" ]; then
  echo "[4/5] Chrome 확인됨 (Linux: $CHROME_LINUX)"
else
  echo "[4/5] WARNING: Chrome 미설치. PNG 렌더 기능 사용 불가."
  echo "       WSL: Windows에 Chrome 설치 필요"
  echo "       Linux: sudo apt install chromium-browser"
fi

# 5. ffmpeg 확인 (영상 인코딩용)
if command -v ffmpeg >/dev/null 2>&1; then
  echo "[5/5] ffmpeg 확인됨"
else
  # Windows ffmpeg 확인
  WIN_FFMPEG=$(find /mnt/c -name "ffmpeg.exe" -path "*/bin/*" 2>/dev/null | head -1)
  if [ -n "$WIN_FFMPEG" ]; then
    echo "[5/5] ffmpeg 확인됨 (Windows: $WIN_FFMPEG)"
  else
    echo "[5/5] WARNING: ffmpeg 미설치. GIF/MP4 인코딩 불가."
    echo "       Windows: winget install ffmpeg"
    echo "       Linux: sudo apt install ffmpeg"
  fi
fi

echo ""
echo "=== 설치 완료 ==="
echo ""
echo "사용법:"
echo "  /consulting-chart 매출 차트 만들어줘"
echo "  /consulting-chart impact 스타일로 카드뉴스 만들어줘"
echo "  /consulting-chart 바 차트 올라가는 영상 만들어줘"
echo ""
echo "5가지 카드뉴스 디자인:"
echo "  editorial  — 좌측정렬 매거진 (라이트)"
echo "  impact     — 다크 중앙 임팩트 (기본값)"
echo "  grid       — 좌우 2단 분할"
echo "  dark-slim  — 다크 슬림 차트"
echo "  minimal    — 흑백 미니멀"
