# Gongnangi Chart Skill

**Claude Code** consulting-style chart generator skill.

McKinsey / Bain / BCG style HTML charts with one-command PNG export.

## What it does

- Generates publication-grade consulting charts as HTML
- Converts to PNG via Windows Chrome headless (WSL compatible)
- Supports: bar charts, comparison tables, A-vs-B layouts, process flows, timelines, level diagrams

## Design Philosophy

> "Everything loud means nothing stands out. One thing catches the eye."

- Grayscale base (`#d5d5d5`, `#888`, `#555`, `#222`, `#111`)
- Single accent color: **red `#c0392b`** for the one insight that matters
- Zero decoration: no emoji, no gradients, no rounded corners, no shadows
- Every pixel carries data

## Installation

Copy `SKILL.md` into your Claude Code skills directory:

```bash
# From this repo
cp SKILL.md ~/.claude/skills/consulting-chart/SKILL.md
cp -r examples/ ~/.claude/skills/consulting-chart/examples/
```

Or clone directly:

```bash
git clone https://github.com/kimsh-1/gongnangi-chart-skill.git ~/.claude/skills/consulting-chart
```

## Usage

In Claude Code, invoke the skill:

```
/consulting-chart 매출 성장률 비교 차트 만들어줘
```

## PNG Export

Requires Google Chrome installed on Windows (WSL environment):

```bash
CHROME="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --screenshot="D:\\output\\chart.png" \
    --window-size=960,500 \
    "file:///D:/input/chart.html"
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

## Color Palette

```
#111     Title, emphasis text
#222     Body text
#333     Table cells
#555     Secondary bars
#888     Labels, subtext
#999     Subtitles
#bbb     Source text
#ccc     Arrows, connectors
#d5d5d5  Default bars, numbers
#eee     Dividers, grid background
#f5f5f5  Bar background
#fafafa  Table cell background
#fdf5f5  Warning/danger background
#c0392b  THE accent (only color allowed)
```

## License

MIT
