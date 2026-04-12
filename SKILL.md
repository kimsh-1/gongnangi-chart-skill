---
name: consulting-chart
description: "공냥이 시각 콘텐츠 스킬 — 컨설팅 차트, 인스타 카드뉴스, 애니메이션 영상을 HTML/CSS 코드로 생성. 5가지 카드뉴스 디자인 테마 선택 가능."
allowed-tools: [Bash, Write, Read, Edit]
---

# 공냥이 시각 콘텐츠 스킬

3가지 기능을 선택해서 사용:

| 기능 | 설명 | 사용법 |
|------|------|--------|
| **공냥이 차트** | 컨설팅 스타일 데이터 차트 (960x500 PNG) | `/consulting-chart 차트 만들어줘` |
| **공냥이 카드뉴스** | 인스타 카드뉴스 5가지 디자인 (1080x1350 PNG) | `/consulting-chart 카드뉴스 만들어줘` |
| **공냥이 영상** | Remotion 애니메이션 차트 (MP4/GIF) | `/consulting-chart 영상 만들어줘` |

---

## Design Principles

McKinsey/Bain/BCG consulting report standard:

1. **Color**: Default everything grayscale. Accent is **red (#c0392b) only**.
2. **Zero decoration**: No emoji. No icons. No gradients. No rounded corners. No shadows.
3. **Typography**: Title = insight (not description). Numbers large, labels small. Noto Sans KR.
4. **Structure**: Lines thin and precise. Whitespace intentional. Every pixel carries data.
5. **Source**: Always include `Source:` line at the bottom.
6. **Action Title**: Title must pass "So What?" test. Quantify where possible.
7. **Philosophy**: "Everything loud means nothing stands out. One thing catches the eye."

---

## Design Tokens

```json
{
  "color": {
    "title": "#111", "body": "#222", "cell": "#333",
    "secondary": "#555", "label": "#888", "subtitle": "#999",
    "source": "#bbb", "connector": "#ccc", "bar-default": "#d5d5d5",
    "divider": "#eee", "bar-bg": "#f5f5f5", "cell-bg": "#fafafa",
    "warning-bg": "#fdf5f5", "accent": "#c0392b"
  },
  "typography": {
    "chart": { "title": "22px/700", "sub": "11px/400", "source": "9px/300" },
    "cardnews": {
      "hero": "72px/700", "title": "48px/700", "heading": "36px/700",
      "subhead": "28px/400", "body": "24px/400", "label": "18px/400",
      "caption": "14px/300", "source": "12px/300"
    }
  },
  "layout": {
    "chart": "960x500",
    "cardnews": "1080x1350"
  }
}
```

---

## Base CSS (Chart Mode — 960px)

```css
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&display=swap');
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Noto Sans KR',sans-serif;background:#fff;padding:28px 36px 20px;width:960px;color:#222}
.title{font-size:22px;font-weight:700;color:#111;margin-bottom:2px}
.sub{font-size:11px;color:#999;margin-bottom:24px}
.source{font-size:9px;color:#bbb;margin-top:18px}
```

## Base CSS (Card News Mode — 1080x1350)

```css
body{width:1080px;height:1350px;padding:80px 72px 60px;display:flex;flex-direction:column}
.slide-num{font-size:14px;color:#ccc;margin-bottom:40px}
.title{font-size:40px;font-weight:700;color:#111;line-height:1.3;margin-bottom:40px}
.body{font-size:24px;color:#555;line-height:1.7}
.highlight{color:#c0392b;font-weight:700}
.bottom{font-size:12px;color:#ccc;margin-top:auto}
```

---

## Chart Types

### 1. Horizontal Bar Chart
- Default bar: `background:#d5d5d5`, Highlight: `background:#c0392b`
- Labels left-aligned, values right. Bar height 18-22px, background #f5f5f5

### 2. Comparison Table
- Header: 10px, #999, bottom 2px solid #111
- Cell: 11px, #333, bottom 1px solid #eee. Highlight: color:#c0392b

### 3. Side-by-Side (A vs B)
- `display:flex;gap:1px;background:#eee` — 1px divider
- Highlight side title in #c0392b

### 4. Process / Flow
- Numbers: 28-32px, bold, #d5d5d5 (highlight: #c0392b). Arrows: `→`, color:#ccc

### 5. Timeline
- Horizontal axis: height:2px, background:#222. Nodes: 14px circles. Current: #c0392b

### 6. Level / Severity
- Color bar tags + description. Scale: #c0392b → #e67e22 → #555 → #999

---

## Card News — 5 Design Themes

Instagram 4:5 portrait (1080x1350). 사용자가 디자인을 선택하면 해당 스타일로 전체 세트 생성.

### 디자인 선택

| # | Theme | Background | Accent | Layout | Feel |
|---|-------|-----------|--------|--------|------|
| 1 | **editorial** | #FAFAFA 라이트 | #FF4444 | 좌측정렬 비대칭 | 매거진 |
| 2 | **impact** | #0A0A0A 다크 | #c0392b | 중앙정렬 | 극적 임팩트 |
| 3 | **grid** | #F0EBE3 + #2C2C2C | #8B6F4E | 좌우 2단 분할 | 구조적 |
| 4 | **dark-slim** | #0A0A0A 다크 | #c0392b | 좌측정렬 | 슬림 차트 |
| 5 | **minimal** | #F5F5F5 라이트 | #c0392b | 중앙정렬 | 흑백 미니멀 |

기본값: `impact` (디자인 미지정 시)

### 공통 타이포그래피 규칙

```
핵심 숫자: 160-200px, weight 900, letter-spacing -6px
제목 핵심: 48-56px, weight 900
제목 연결어: 같은 크기, weight 100-300 (대비)
본문: 22-28px, weight 300-500, line-height * 1.618
라벨: 11-13px, letter-spacing 3-5px, uppercase
```

- 한 줄마다 다른 크기/굵기/색상 (같은 스타일 3줄 연속 금지)
- 콘텐츠가 캔버스의 70%+ 차지
- padding: 상단 100px, 좌우 72px, 하단 72px
- safe zone: 상하 135px (인스타 그리드 잘림 방지)
- 하단: 좌측 시리즈명 + 우측 @핸들

### 공통 바 차트 규칙 (슬림 스타일)

```css
.bar-track{height:6px;background:#f5f5f5}  /* 라이트 */
.bar-track{height:6px;background:#1A1A1A}  /* 다크 */
.bar-accent{background:#c0392b}
.bar-mid{background:#888}
.bar-light{background:#CCC}
```

### 슬라이드 구조 (SCQA + Pyramid)

| Slide | Role | Content |
|-------|------|---------|
| cover | Hook | 핵심 숫자 + 제목 + 설명 |
| data | Complication | 슬림 바 차트 + "왜 한계인가" 설명 |
| quote | Pivot | 핵심 인용구, 줄마다 굵기/색상 대비 |
| framework | Evidence | 프레임워크/축, 번호+이름+설명 계층 |

### 금지사항

- border-radius, box-shadow 금지
- border로 박스 만들기 금지 (구분선 border-top/bottom만 허용)
- margin:auto로 빈 공간 분배 금지
- 같은 스타일 텍스트 3줄 연속 금지

### 렌더 후 피드백 루프 (필수)

카드뉴스 HTML을 PNG로 렌더한 후 반드시 다음 검증을 수행:

**1. 잘림 체크**
```bash
# 2배 높이로 렌더하여 하단 잘림 확인
CHROME --screenshot=check.png --window-size=1080,2700 file.html
# check.png 파일 크기가 정상 렌더의 1.5배 이상이면 OVERFLOW
```

**2. 시각 확인**
렌더된 PNG를 Read로 열어서 다음 확인:
- 텍스트가 잘 보이는가 (다크 배경에서 #555 이하 색상은 안 보임 → #999+ 사용)
- 하단 빈 공간이 30%+ 이면 폰트를 키우거나 내용 추가
- 바 차트가 기존 슬림 스타일(6px)과 일치하는가
- border로 만든 박스가 없는가

**3. 실패 시 자동 수정**
- OVERFLOW → padding 줄이거나 font-size 줄이기
- 텍스트 안 보임 → 색상 올리기 (#555 → #999)
- 빈 공간 과다 → font-size 키우기 또는 설명 추가
- 수정 후 재렌더 → 재검증 (최대 3회 반복)

---

## Animation System

CSS animation HTML → Chrome headless frame capture → ffmpeg encode.

### Animation Patterns

```css
/* Bar grow */
@keyframes barGrow{from{width:0}to{width:var(--target)}}
.bar{animation:barGrow 0.8s cubic-bezier(0.25,0.46,0.45,0.94) forwards}

/* Fade in with slide up */
@keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}

/* Scale in (for numbers) */
@keyframes scaleIn{from{transform:scale(0.5)}to{transform:scale(1)}}
```

### Stagger Timing
- Title: 0s
- Subtitle: 0.2s
- Data rows: 0.4s + (index * 0.2s)
- Source line: last animation + 0.5s
- Hold final frame: +1 second

### Capture Pipeline (PowerShell + Windows Chrome)

```powershell
# Frame capture with virtual time
& $chrome --headless=new --disable-gpu --hide-scrollbars `
    --screenshot="$outFile" `
    --window-size=960,500 `
    --virtual-time-budget=$timeMs `
    "file:///$htmlPath"
```

### Encode Pipeline (ffmpeg)

```bash
FFMPEG="path/to/ffmpeg.exe"

# GIF (high quality with palette optimization)
"$FFMPEG" -y -r 15 -i "frames/frame-%04d.png" \
  -vf "fps=15,scale=960:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
  output.gif

# MP4 (H.264)
"$FFMPEG" -y -r 15 -i "frames/frame-%04d.png" \
  -c:v libx264 -pix_fmt yuv420p -crf 18 \
  output.mp4

# APNG (animated PNG, infinite loop)
"$FFMPEG" -y -r 15 -i "frames/frame-%04d.png" \
  -plays 0 output.apng
```

---

## PNG Export (Static)

```bash
CHROME="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"

# Chart (960x500)
"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --screenshot="D:\\output\\chart.png" \
    --window-size=960,500 \
    "file:///D:/input/chart.html"

# Card News (1080x1350)
"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --screenshot="D:\\output\\card.png" \
    --window-size=1080,1350 \
    "file:///D:/input/card.html"
```

---

## Prohibited

- Emoji
- Gradients (linear-gradient)
- border-radius (except tables)
- box-shadow
- More than 1 background color on badges/tags
- Any "decorative" element — if it's not data, it doesn't belong
- Description titles ("매출 추이") — always action titles ("Q4 매출 15% 급등")
