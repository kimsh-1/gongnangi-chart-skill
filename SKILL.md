---
name: consulting-chart
description: "McKinsey/Bain style chart + card news + animated video generator. Static charts (960px), Instagram card news (1080x1350), CSS animation capture to MP4/GIF/APNG."
allowed-tools: [Bash, Write, Read, Edit]
---

# Gongnangi Chart Skill — Consulting Style Visual Content

## Overview

3개 출력 모드:
1. **Static Chart** — 보고서용 960x500 HTML → PNG
2. **Card News** — 인스타용 1080x1350 HTML → PNG (8-9장 세트)
3. **Animation** — CSS 애니메이션 HTML → 프레임 캡처 → MP4/GIF/APNG

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

## Card News Structure (SCQA + Pyramid Hybrid)

Instagram 4:5 portrait (1080x1350), 8-9 slides per set.

| Slide | Role | Template | Pattern |
|-------|------|----------|---------|
| 1 | Hook | hero-number or provocative claim | Big stat + title |
| 2 | Situation | context + quote | Set the scene |
| 3 | Complication | bar chart data | Show the problem |
| 4 | Tension | A vs B comparison | "Not X, but Y" |
| 5 | Pivot | centered quote | Key turning point |
| 6-7 | Evidence | framework/data cards | One insight per slide |
| 8 | Synthesis | layer diagram | "So What" takeaway |
| 9 | CTA | series list + action | Save/follow |

### Card News Rules
- Mobile text: body 24px+, title 40px+, hero 72px+
- Max 20% text per slide
- Golden ratio line height (x1.618) for Korean text
- @handle at bottom of every slide
- Consistent visual system across all slides

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
