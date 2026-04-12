# Gongnangi Chart Skill

**Claude Code** consulting-style visual content generator.

McKinsey / Bain / BCG style charts, Instagram card news, and animated video — all from one skill.

## 3 Output Modes

| Mode | Size | Format | Use Case |
|------|------|--------|----------|
| **Static Chart** | 960x500 | HTML → PNG | Reports, presentations |
| **Card News** | 1080x1350 | HTML → PNG (8-9 slides) | Instagram carousel |
| **Animation** | 960x500 | HTML → GIF / MP4 / APNG | Social media, presentations |

## Design Philosophy

> "Everything loud means nothing stands out. One thing catches the eye."

- Grayscale base (`#d5d5d5`, `#888`, `#555`, `#222`, `#111`)
- Single accent color: **red `#c0392b`** for the one insight that matters
- Zero decoration: no emoji, no gradients, no rounded corners, no shadows
- Action titles only (insight, not description)
- Every pixel carries data

## Installation

```bash
git clone https://github.com/kimsh-1/gongnangi-chart-skill.git ~/.claude/skills/consulting-chart
```

## Usage

```
/consulting-chart 매출 성장률 비교 차트 만들어줘
/consulting-chart 컨텍스트 엔지니어링 카드뉴스 9장 만들어줘
/consulting-chart 바 차트 올라가는 애니메이션 GIF 만들어줘
```

## Chart Types

| Type | Description |
|------|------------|
| Horizontal Bar | Grayscale bars with single red highlight |
| Comparison Table | Clean headers, thin dividers, red accent cells |
| A vs B | Side-by-side flex layout with 1px divider |
| Process Flow | Numbered steps with arrow connectors |
| Timeline | Horizontal axis with alternating labels |
| Level Diagram | Stacked severity/priority bars |

## Card News Structure (SCQA + Pyramid)

| Slide | Role | Pattern |
|-------|------|---------|
| 1 | Hook | Big stat or provocative claim |
| 2 | Situation | Context + quote |
| 3 | Complication | Data bar chart |
| 4 | Tension | A vs B comparison |
| 5 | Pivot | Key turning point quote |
| 6-7 | Evidence | Framework / data cards |
| 8 | Synthesis | "So What" takeaway |
| 9 | CTA | Save / follow |

## Animation Pipeline

```
CSS animation HTML
    → Chrome headless --virtual-time-budget (frame capture)
    → ffmpeg encode
        ├── GIF (palette-optimized)
        ├── MP4 (H.264)
        └── APNG (animated PNG)
```

## Color Palette

```
#111     Title, emphasis text
#222     Body text
#555     Secondary bars
#888     Labels, subtext
#999     Subtitles
#c0392b  THE accent (only color allowed)
#d5d5d5  Default bars, numbers
#eee     Dividers
#f5f5f5  Bar background
```

## Examples

```
examples/
  bar-chart.html              Static bar chart
  comparison-table.html       Static comparison table
  process-flow.html           Static process flow
  animated-barchart.html      CSS animated bar chart
  animated-4axis.html         CSS animated 4-axis framework
  capture-and-encode.ps1      Frame capture + encode script
  cardnews/
    01-hook.html              Card news hook slide
    03-data-bar.html          Card news data slide
    04-compare.html           Card news A vs B slide
    08-synthesis.html         Card news synthesis slide
    09-cta.html               Card news CTA slide
```

## License

MIT
