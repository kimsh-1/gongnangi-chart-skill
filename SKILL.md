---
name: consulting-chart
description: "McKinsey/Bain style HTML chart generator with Chrome headless PNG export. Bar charts, comparison tables, timelines, process flows — all in grayscale + single red accent."
allowed-tools: [Bash, Write, Read, Edit]
---

# Consulting Chart — Gongnangi Chart Skill

## Design Principles

McKinsey/Bain/BCG consulting report standard:

1. **Color**: Default everything grayscale (#d5d5d5, #888, #555, #222, #111). Accent is **red (#c0392b) only**. Nothing else.
2. **Zero decoration**: No emoji. No icons. No gradients. No rounded corners. No shadows. No badges.
3. **Typography**: Title = insight (not description). Numbers large, labels small. Noto Sans KR.
4. **Structure**: Lines are thin and precise. Whitespace is intentional. Every pixel carries data.
5. **Source**: Always include `Source:` line at the bottom.
6. **Philosophy**: "Everything loud means nothing stands out. One thing catches the eye."

## Base CSS

```css
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&display=swap');
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Noto Sans KR',sans-serif;background:#fff;padding:28px 36px 20px;width:960px;color:#222}
.title{font-size:22px;font-weight:700;color:#111;margin-bottom:2px}
.sub{font-size:11px;color:#999;margin-bottom:24px}
.source{font-size:9px;color:#bbb;margin-top:18px}
```

## Color Palette

```
#111     — Title, emphasis text
#222     — Body text
#333     — Table cells
#555     — Secondary bars, mid-tone
#888     — Labels, subtext
#999     — Subtitles
#bbb     — Source text
#ccc     — Arrows, connectors
#d5d5d5  — Default bars, numbers
#eee     — Dividers, grid background
#f5f5f5  — Bar background
#fafafa  — Table cell background
#fdf5f5  — Warning/danger background
#c0392b  — Accent (the ONLY color). Key data, danger, highlight only.
```

## Chart Type Patterns

### Horizontal Bar Chart
- Default bar: `background:#d5d5d5`
- Highlight bar: `background:#c0392b`
- Labels left-aligned, values right
- Bar height 18-22px, background #f5f5f5

### Comparison Table
- Header: 10px, #999, bottom 2px solid #111
- Cell: 11px, #333, bottom 1px solid #eee
- First column: bold, #111
- Highlight cell: color:#c0392b

### Side-by-Side (A vs B)
- `display:flex;gap:1px;background:#eee` — 1px divider
- Each side: `background:#fff;padding:16px 18px`
- Highlight side title only in #c0392b

### Process / Flow
- Numbers: 28-32px, bold, #d5d5d5 (highlight: #c0392b)
- Arrows: `→`, color:#ccc
- Caveats section: border-top:1px solid #eee separator

### Timeline
- Horizontal axis: position:absolute, height:2px, background:#222
- Nodes: 14px circle, border:2px solid #fff
- Past: #555-#999, current highlight: #c0392b + "NOW" badge
- Labels alternate above/below

### Level / Severity
- Color bar tags (width:100px) + description area
- Severity scale: #c0392b → #e67e22 → #555 → #999

## PNG Export Pipeline

```bash
# Windows Chrome headless (from WSL)
CHROME="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"

"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --screenshot="D:\\output\\chart.png" \
    --window-size=960,500 \
    "file:///D:/input/chart.html"
```

- Width: 960px fixed (matches body CSS)
- Height: 500px default, adjust per content (300-600)
- `--hide-scrollbars` required
- HTML path in Windows format (`file:///D:/...`)
- Output path in Windows format (`D:\\...`)

## Prohibited

- Emoji
- Gradients (linear-gradient)
- border-radius (except tables)
- box-shadow
- More than 1 background color on badges/tags
- Any "decorative" element — if it's not data, it doesn't belong
