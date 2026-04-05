# A Click is All You Need · 完整工作流
# A Click is All You Need · Complete Workflow

> 本文档描述在 Cursor 中从零生成专业双语学术汇报的 9 步可复现流程。AI Agent 会自动执行大部分步骤，本文档供人工理解和手动调试参考。
>
> This document describes the 9-step reproducible workflow for generating professional bilingual academic presentations in Cursor. Most steps are automated by AI agents; this document serves as a human-readable reference for understanding and manual debugging.

---

## 为什么选择这套工作流？/ Why This Workflow?

本工作流有 8 大核心优点 / 8 core advantages:

**A. 学术严谨性 Academic Rigor**
XeLaTeX + Beamer 输出 PDF，字号 pt 精确、行距专业，对比 Office 导出质量差一个量级。跨平台 PDF 完全一致，告别"换台电脑就乱版"。
XeLaTeX + Beamer produces pt-precise, professional PDFs — a full quality tier above Office exports. Cross-platform consistency guaranteed.

**B. 汇报自由度 Presentation Freedom**
叙事弧（Hook → Roadmap → Content → Synthesis → Discussion）内置于流程。TikZ 图形代码生成，无需截图拼贴。中英双语 ctex + fontspec 自动处理字距。
Narrative arc built into the pipeline. TikZ graphics generated in code. Bilingual CJK+Latin handled automatically.

**C. 完整流水线 End-to-End Pipeline**
8 阶段从摄入到交付，没有遗漏，输出稳定。所有 `.tex` 源文件可 git 追踪，版本可回滚。
8 stages intake to delivery, nothing falls through the cracks. All `.tex` source files are git-tracked and rollback-ready.

**D. Plan 模式主动问需求 Requirements-First**
AI 不猜需求：先用结构化问卷（5 个维度，含视觉风格）确认内容/格式/风格，防止方向错误后大量返工，节省 50%+ 沟通成本。
AI never guesses: structured questionnaire across 5 dimensions (including visual style) before writing a single line of LaTeX.

**E. AI 三重质量审查 Triple AI Review**
slide-auditor（布局溢出）/ tikz-reviewer（图形碰撞）/ pedagogy-reviewer（叙事节奏），并行审查后串行修复，缺陷率远低于人工单轮检查。
Three specialized agents review in parallel — layout, diagrams, narrative — then fix in series.

**F. 讲稿同步输出 Script Sync**
`slides.pdf` 和 `script.pdf` 同步交付，`\speakbox` / `\notebox` 格式直接可读，无需另开文档写讲稿。
`slides.pdf` and `script.pdf` always delivered together. `\speakbox` format is ready to read aloud.

**G. AI 配图自动化 Automated Illustration**
摄入阶段即规划配图需求，AI 生成后自动嵌入对应幻灯片，不需要用户手动找图/处理分辨率。
Image requirements planned at intake. AI generates and embeds automatically. No manual DPI resizing.

**H. 用户风格可配置 Style Configurable**
通过 ppt-intake 问卷选定主色系/字体，写入 `config.tex` 一处生效全局，更换风格只需修改 4 行，不需要逐帧调整。
Style preferences (font, color) collected via questionnaire, written to `config.tex`, apply globally in one edit.

---

## 设计灵感 / Design Inspiration

本工作流的幻灯片风格与排版规范参考：
The slide aesthetics and typographic conventions of this workflow draw from:

- **Pedro H.C. Sant'Anna** (Vanderbilt University / Microsoft Research) — Beamer 配色体系与幻灯片节奏规范 / Beamer color palette and slide rhythm conventions that balance academic rigor with visual clarity
- **Isaiah Andrews** (Harvard University) — 学术汇报内容密度与信息层级约定 / Content density and information hierarchy conventions for academic seminar presentations
- **Till Tantau, Joseph Wright, Vedran Miletić** — *The Beamer User Guide*, Beamer 框架与宏设计基础 / the foundational framework for this template's structure and macro design

---

## 前置准备 / Prerequisites

运行环境检测 / Run environment check:
```bash
bash setup.sh
```

确认以下条件满足 / Confirm all conditions are met:
- ✅ XeLaTeX 可用 / available (`xelatex --version`)
- ✅ Kaiti SC 字体已安装 / font installed (`fc-list | grep -i kai`)
- ✅ Python 3 + python-docx + PyMuPDF 已安装 / installed (素材提取用 / for material extraction)

---

## Step 0 — 触发工作流 / Trigger the Workflow

在 Cursor 中对 AI 说 / Say to Cursor AI:

> `"帮我做一个汇报"` 或 / or `"Make me a presentation"`

AI 会自动 / AI automatically:
1. 切换到 **Plan 模式** / Switch to **Plan Mode**
2. 用 `AskQuestion` 工具依次询问需求 / Use `AskQuestion` to collect requirements
3. 生成执行计划，等待你确认 / Generate execution plan and wait for your approval

**需要提供的信息（5 个维度）/ Required information (5 dimensions):**

| 维度 / Dimension | 示例 / Example |
|---|---|
| 汇报主题 / Topic | Risjord《社会科学哲学》第9章 |
| 现有素材 / Materials | 章节 PDF + 课程大纲 DOCX |
| 页数 / 时长 / Pages & duration | 16页 / 8分钟 |
| 是否双语 / Bilingual? | 是（中文主体，英文术语）|
| 叙事主线 / Narrative arc | 侦探推理 / 直述 / 案例研究 |
| 是否配图 / Illustrations? | AI生成 / 用户提供 / 不需要 |
| 讲稿 / Script? | 是/否 |
| **视觉风格 / Visual style** | 主色系 + 中文字体 + 英文字体 |

**视觉风格问卷 / Visual Style Questionnaire:**
- 主色系 / Primary color: 深蓝 Deep Blue (academic) / 深绿 Forest Green (fresh) / 深紫 Purple (modern) / 自定义 Custom
- 中文字体 / CJK font: 楷体 Kaiti SC (formal) / 黑体 PingFang (clean) / 宋体 Songti (classical)
- 英文字体 / Latin font: Times New Roman (academic) / Helvetica (modern) / Palatino (elegant)

---

## Step 1 — 素材摄入 / Material Intake

**AI 执行 / AI executes:** 读取所有提供的文件，提取可用内容 / Read all provided files and extract usable content.

```python
# PDF extraction (PyMuPDF)
import fitz
doc = fitz.open("source.pdf")
text = "\n".join(page.get_text() for page in doc)

# DOCX extraction (python-docx)
from docx import Document
doc = Document("outline.docx")
for para in doc.paragraphs:
    print(para.text)
```

**输出 / Output:** 章节大纲 + 核心概念列表 + 叙事主线建议 / Chapter outline + key concepts + narrative arc options

---

## Step 2 — 脚手架搭建 / Scaffold

**AI 执行 / AI executes:**

```bash
# 创建项目目录 / Create project directory
mkdir -p projects/presentations/[slug]/images

# 复制模板 / Copy templates
cp templates/slides-template.tex projects/presentations/[slug]/slides.tex
cp templates/script-template.tex projects/presentations/[slug]/script.tex

# 写入用户风格配置 / Write user style config
cp templates/config.tex projects/presentations/[slug]/config.tex
# Then edit config.tex with user's font/color choices
```

根据视觉风格问卷回答填写 `config.tex` / Fill `config.tex` based on visual style questionnaire answers:

```latex
\newcommand{\cjkfont}{Kaiti SC}        % User's chosen CJK font
\newcommand{\latinfont}{Times New Roman} % User's chosen Latin font
\definecolor{deepblue}{RGB}{0,52,102}   % User's chosen primary color
\newcommand{\footleft}{Course · Topic}   % User's course/topic
```

**命名规范 / Naming convention:** `[slug]` 使用小写字母+连字符 / use lowercase + hyphens, e.g. `risjord-ch9`

---

## Step 3 — 内容生成 / Content Generation

**AI 执行：** 按需求逐页填充幻灯片内容 / AI fills slides page by page.

**标准页面结构 / Standard page structure (16-page example):**

```
Page 1   Cover (封面)
Page 2   Hook (钩子) — spark curiosity
Page 3   Roadmap (路线图) — global overview
Pages 4-5  Section 1 content
Pages 6-7  Section 2 content
Pages 8-11 Section 3 content — core theory, most pages
Pages 12-14 Section 4 content
Page 15  Synthesis (综合)
Page 16  Discussion (讨论)
```

**双语排版约定 / Bilingual typesetting conventions:**

```latex
% 英文术语斜体 / English terms in italics
\EN{Causal Inference}

% 节标签（浅色）/ Section tag (light color)
\begin{frame}{第一节标题 \sectag{Section Tag}}

% 关键引言（金色）/ Key quote (gold)
\textcolor{gold}{\textbf{\textit{"One sentence. Two PDFs."}}}

% 引号：使用 Unicode 弯引号 / Quotes: use Unicode curly quotes
" " → U+201C / U+201D  (correct 正确)
" " → U+0022           (wrong 错误 — CJK spacing issues)
```

---

## Step 4 — 图片处理 / Illustration

### AI 生成图片 / AI-generated images

```
GenerateImage tool parameters / 参数建议:
- State image purpose clearly (cover / concept / ending)
- Specify style (Chiikawa kawaii / flat design / academic)
- Match the config.tex color palette
```

所有图片保存到 `images/` 目录 / Save all images to `images/` subdirectory.

### 全页底图叠加 / Full-page background overlay (cover/ending):

```latex
\begin{tikzpicture}[remember picture,overlay]
  \node[opacity=0.38,anchor=center] at (current page.center){%
    \includegraphics[width=\paperwidth,height=\paperheight,
      keepaspectratio=false]{images/cover-bg.png}};
  \fill[lightbg,opacity=0.28]
    (current page.north west) rectangle (current page.south east);
\end{tikzpicture}
```

---

## Step 5 — 首次编译 / First Compile

```bash
cd projects/presentations/[slug]
xelatex -interaction=nonstopmode slides.tex
xelatex -interaction=nonstopmode slides.tex  # 必须两遍 / must run twice
```

**检查指标 / Check:**
- `slides.pdf` 存在 / exists
- 页数正确 / correct page count
- 日志无 `! Error`（`Overfull \hbox` 是警告，可接受 / is a warning, acceptable）

---

## Step 6 — 质量审查循环 / Triple AI Review Loop

### 并行审查 / Parallel review

| 审查员 / Agent | 关注点 / Focus |
|---|---|
| `slide-auditor` | 布局溢出、字号过小、图片引用断裂 / Layout overflow, font size, broken image refs |
| `tikz-reviewer` | 节点碰撞、标签被遮挡、箭头对齐 / Node collisions, obscured labels, arrow alignment |

### 串行审查 / Serial review

| 审查员 / Agent | 关注点 / Focus |
|---|---|
| `pedagogy-reviewer` | 叙事弧度、节奏、术语一致性 / Narrative arc, pacing, terminology consistency |

### 修复优先级 / Fix priority

| 级别 / Level | 定义 / Definition | 处理 / Action |
|---|---|---|
| Critical | 编译错误、严重溢出（>20pt）/ Compile error, severe overflow | 立即修复 / Fix immediately |
| Major | 内容遮挡、叙事断层 / Content obscured, narrative gap | 本轮修复 / Fix this round |
| Minor | 轻微间距（<5pt）/ Minor spacing | 可选修复 / Optional |

修复后重新编译验证，**最多 3 轮 / max 3 rounds**.

---

## Step 7 — 讲稿生成 / Script Generation

**字数配比 / Word count:** 1分钟 ≈ 200字（中文口播）/ 1 minute ≈ 200 Chinese characters

每页幻灯片时间预算（8分钟 / 16页）/ Per-slide time budget (8 min / 16 pages):
- 封面 Cover: 20秒
- 钩子 Hook: 40秒
- 路线图 Roadmap: 25秒
- 内容页 Content: 35–45秒/页
- 综合 Synthesis: 35秒
- 讨论 Discussion: 30秒

**讲稿格式 / Script format:**

```latex
\slidesec{2}{钩子：一个思想实验}

\notebox{[PPT 提示] 此页先指向左栏，图在右侧。 / [Stage] Point left, image on right.}

\speakbox{
我们先从一个非常直观的思想实验开始……
[口播内容，约 80 字 / spoken content, ~80 chars]
（稍作停顿）这引出了本次汇报的核心问题——
}

\notebox{[切换] 点击进入第3页 / [Transition] Click to slide 3.}
```

编译讲稿 / Compile script:
```bash
xelatex -interaction=nonstopmode script.tex
xelatex -interaction=nonstopmode script.tex
```

---

## Step 8 — 交付 / Delivery

**验证清单 / Verification checklist:**

```
□ projects/presentations/[slug]/slides.pdf — exists, correct page count
□ projects/presentations/[slug]/script.pdf — exists, one section per slide
□ All Critical/Major issues resolved / 所有 Critical/Major 问题已修复
□ Fonts correctly embedded (XeLaTeX guarantees this) / 字体正确嵌入
```

**交付 / Deliverables:**
```
✅ slides.pdf  → 幻灯片成品，可直接投影 / Ready to present
✅ script.pdf  → 讲稿，可打印持稿 / Ready to print and read
✅ slides.tex  → 源文件，可后续编辑 / Editable source
✅ config.tex  → 本次风格预设，可复用 / Style config for reuse
```

---

## Step 9 — 常见坑点与解决方案 / Common Pitfalls

### 坑 1：引号渲染为两行 / Pitfall 1: Quotes render on two lines

**原因 / Cause:** 开/闭引号在不同 `\textit{}` 中，CJK 字体引擎单独处理间距 / Open/close quotes in separate `\textit{}` blocks; CJK engine applies full-width spacing to each.

```latex
% 错误 Wrong:
\textit{"First part.}\\ \textit{Second part."}
% 正确 Correct:
\textit{"First part. Second part."}
```

---

### 坑 2：TikZ 节点在列内溢出 / Pitfall 2: TikZ nodes overflow column

```latex
% 错误 Wrong:
\node[minimum width=\textwidth] ...
% 正确 Correct:
\node[minimum width=\linewidth] ...
```

---

### 坑 3：内容过密溢出 frame / Pitfall 3: Content overflows frame

解决方案（按优先级）/ Solutions (by priority):
1. 删减文字 / Reduce text
2. 字号降一档 `\small` → `\footnotesize`
3. 减少 `\vspace` 间距
4. 最后手段 / Last resort: `\begin{frame}[shrink=8]{Title}`（不超过 10）

---

### 坑 4：Kaiti SC 字体找不到 / Pitfall 4: Font not found

```bash
# 查看系统实际字体名 / Check actual font name on system
fc-list | grep -i kai

# 修改 config.tex / Edit config.tex
\newcommand{\cjkfont}{实际字体名 / actual font name}
```

---

### 坑 5：TikZ fill + node midway 不能连用 / Pitfall 5: fill + node midway conflict

TikZ 的 `\fill[...] rect node[midway]{text}` 语法无效，需分开写 / The `\fill...rectangle node[midway]{text}` pattern is invalid — write them separately:

```latex
% 错误 Wrong:
\fill[blue] (0,0) rectangle (2,1) node[midway]{text};
% 正确 Correct:
\fill[blue] (0,0) rectangle (2,1);
\node at (1,0.5) {text};
```

---

## 附录：色彩规范 / Appendix: Color Spec

在 `config.tex` 中配置 / Configure in `config.tex`:

| 变量 Variable | RGB | 用途 Usage |
|---|---|---|
| `deepblue` | 0,52,102 | 主色、标题、边框 / Primary, titles, borders |
| `accent` | 196,72,49 | 强调、警告块 / Alerts, highlights |
| `gold` | 180,140,40 | 关键引言 / Key quotes |
| `lightbg` | 240,245,252 | 封面/结尾背景色 / Cover/ending background |

**颜色预设 / Color presets** (uncomment one in `config.tex`):
- Deep Blue `RGB(0,52,102)` — 学术正式 / Academic formal (default)
- Forest Green `RGB(0,80,60)` — 清新简洁 / Fresh and clean
- Academic Purple `RGB(60,20,100)` — 现代典雅 / Modern elegant
