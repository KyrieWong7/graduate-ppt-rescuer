# A Click is All You Need · AI Agent 行为说明
# A Click is All You Need · Cursor AI Behavior Spec

本工作区是一个 **Cursor 工作区模板**，专为从学术文献或课程材料快速生成专业中英双语 Beamer 汇报而设计。

This workspace is a **Cursor workspace template** designed to generate professional bilingual (Chinese + English) Beamer presentations from academic materials in a single AI-driven conversation.

---

## 首次打开时 / On First Open

1. 运行 `setup.sh` 检查环境（XeLaTeX、Kaiti SC 字体、Python 依赖）
2. 阅读 `MEMORY.md` 了解本工作流的关键技术经验
3. 阅读 `WORKFLOW.md` 了解完整的 9 步流程

1. Run `setup.sh` to check environment (XeLaTeX, Kaiti SC font, Python dependencies)
2. Read `MEMORY.md` for key technical lessons learned
3. Read `WORKFLOW.md` for the full 9-step workflow

---

## 遇到 PPT/汇报/slides 相关请求时 / On PPT / Presentation Requests

**必须** 先进入 Plan 模式，执行以下步骤：

**Must** enter Plan Mode first and follow these steps:

1. 读取 `MEMORY.md` 中的关键经验条目 / Read key entries from `MEMORY.md`
2. 使用 `ppt-pipeline` skill 进行主编排 / Use the `ppt-pipeline` skill for orchestration
3. 用 `AskQuestion` 工具收集用户需求（见 `.cursor/rules/ppt-intake.mdc`）/ Collect requirements via `AskQuestion` (see `ppt-intake.mdc`)
4. 收集视觉风格需求（字体/配色），写入 `config.tex` / Collect visual style preferences and write to `config.tex`
5. 生成执行计划，等待用户确认后再执行 / Generate execution plan and wait for user confirmation

---

## 输出规范 / Output Spec

每次汇报生成任务**必须**交付两个文件：
Every presentation task **must** deliver two files:

- `projects/presentations/[项目名]/slides.pdf` — 幻灯片成品 / Presentation slides
- `projects/presentations/[项目名]/script.pdf` — 完整讲稿 / Speaker script

---

## 技术约定 / Technical Conventions

| 约定 Convention | 说明 Description |
|---|---|
| 编译引擎 Engine | **XeLaTeX**（不得使用 pdflatex / do not use pdflatex） |
| 中文字体 CJK | 由 `config.tex` 中 `\cjkfont` 控制 / Controlled by `\cjkfont` in `config.tex` |
| 英文字体 Latin | 由 `config.tex` 中 `\latinfont` 控制 / Controlled by `\latinfont` in `config.tex` |
| 配色 Colors | 由 `config.tex` 中 `\definecolor{deepblue}` 控制 / Controlled in `config.tex` |
| 引号 Quotes | 使用 Unicode 弯引号 `"` `"` (U+201C/U+201D)，不用 ASCII 直引号 |
| 图片 Images | 统一放在 `images/` 子目录，路径通过 `\graphicspath` 设置 |
| 编译次数 Compile | 每次至少编译两遍以确保引用正确 / Compile at least twice for correct references |

---

## 模板使用约定 / Template Usage

- 字体/配色：**只修改 `config.tex`**，不动 `slides-template.tex` 本体
- 图形：TikZ 节点在列内使用 `minimum width=\linewidth`（不是 `\textwidth`）
- 内容溢出：优先减少文字，其次降字号，最后用 `[shrink=8]`
- 引号：所有引号使用 Unicode 弯引号，避免 CJK 字体字距问题

- Fonts/colors: **Edit only `config.tex`** — never modify `slides-template.tex` body
- TikZ: use `minimum width=\linewidth` for column-constrained nodes
- Overflow: reduce text first, then font size, last resort: `[shrink=8]`
- Quotes: always use Unicode curly quotes to avoid CJK spacing issues

---

## 设计灵感 / Design Inspiration

幻灯片风格参考 Pedro H.C. Sant'Anna (Vanderbilt/Microsoft Research) 的 Beamer 排版规范，以及 Isaiah Andrews (Harvard) 的学术汇报节奏约定。

Slide aesthetics are inspired by Pedro H.C. Sant'Anna (Vanderbilt/Microsoft Research) Beamer conventions, and Isaiah Andrews (Harvard) academic presentation pacing guidelines.
