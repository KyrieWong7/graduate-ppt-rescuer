# 研究生PPT汇报解救器 · 完整工作流

> 本文档描述在 Cursor 中从零生成专业双语学术汇报的 9 步可复现流程。
> AI Agent 会自动执行大部分步骤，本文档供人工理解和手动调试参考。

---

## 前置准备

运行环境检测：
```bash
bash setup.sh
```

确认以下条件满足：
- ✅ XeLaTeX 可用（`xelatex --version`）
- ✅ Kaiti SC 字体已安装
- ✅ Python 3 + python-docx + PyMuPDF 已安装（素材提取用）

---

## Step 0 — 触发工作流

在 Cursor 中对 AI 说：

> "帮我做一个汇报" 或 "新建 PPT 项目"

AI 会自动：
1. 切换到 **Plan 模式**
2. 用 `AskQuestion` 工具依次询问需求
3. 生成执行计划，等待你确认

**你需要提供的信息：**

| 项目 | 示例 |
|---|---|
| 汇报主题 | Risjord《社会科学哲学》第9章 |
| 现有素材 | 章节 PDF + 课程大纲 DOCX |
| 页数 / 时长 | 16页 / 8分钟 |
| 是否双语 | 是（中文主体，英文术语） |
| 叙事主线 | 侦探推理（东方快车谋杀案） |
| 是否配图 | AI生成 |
| 是否要讲稿 | 是 |

---

## Step 1 — 素材摄入

**AI 执行：** 读取所有提供的文件，提取可用内容。

```python
# PDF 提取（PyMuPDF）
import fitz
doc = fitz.open("source.pdf")
text = "\n".join(page.get_text() for page in doc)

# DOCX 提取（python-docx）
from docx import Document
doc = Document("outline.docx")
for para in doc.paragraphs:
    print(para.text)
```

**输出：** 章节大纲 + 核心概念列表 + 叙事主线建议（3选项供选择）

---

## Step 2 — 脚手架搭建

**AI 执行：**

```bash
# 创建项目目录
mkdir -p projects/presentations/[slug]/images

# 复制模板
cp templates/slides-template.tex projects/presentations/[slug]/slides.tex
cp templates/script-template.tex projects/presentations/[slug]/script.tex
```

填入封面信息：`\title` / `\author` / `\institute` / `\date`

**命名规范：** `[slug]` 使用小写字母+连字符，如 `risjord-ch9`

---

## Step 3 — 内容生成

**AI 执行：** 按需求逐页填充幻灯片内容。

**标准页面结构（16页示例）：**

```
第1页   封面（cover）
第2页   钩子（hook）— 引发好奇心
第3页   路线图（roadmap）— 全局概览
第4-5页  第一节内容（§9.1）
第6-7页  第二节内容（§9.2）
第8-11页 第三节内容（§9.3）— 核心理论，最多页
第12-14页 第四节内容（§9.4）
第15页  综合（synthesis）
第16页  讨论（discussion）
```

**双语排版约定：**

```latex
% 英文术语斜体
\EN{Causal Inference}

% 节标签（浅色）
\begin{frame}{第一节标题 \sectag{Section Tag}}

% 强调引言（金色）
\textcolor{gold}{\textbf{\textit{"One body. Twelve suspects."}}}

% 引号：使用 Unicode 弯引号，不用 ASCII 直引号
"正确"   → "  " （U+201C 和 U+201D）
"错误"   → " " （ASCII U+0022，会有字符渲染问题）
```

---

## Step 4 — 图片处理

### AI 生成图片

```
GenerateImage 工具参数建议：
- 图片用途明确（封面 / 概念图 / 结尾）
- 指定风格（学术写实 / 卡通 / flat design）
- 指定色调（与 deepblue/accent 配色一致）
```

所有图片保存到 `images/` 目录。

### 全页底图叠加（封面/结尾）

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

## Step 5 — 首次编译

```bash
cd projects/presentations/[slug]
xelatex -interaction=nonstopmode slides.tex
xelatex -interaction=nonstopmode slides.tex  # 必须编译两遍
```

**检查指标：**
- `slides.pdf` 存在
- 页数正确（如期望 16 页）
- 日志中无 `! Error` 行（`Overfull \hbox` 是警告，可接受）

---

## Step 6 — 质量审查循环

### 并行审查

| 审查员 | 关注点 |
|---|---|
| `slide-auditor` | 布局溢出、字号过小、图片引用断裂 |
| `tikz-reviewer` | 节点碰撞、标签被遮挡、箭头对齐 |

### 串行审查

| 审查员 | 关注点 |
|---|---|
| `pedagogy-reviewer` | 叙事弧度、节奏、术语一致性、桥接句 |

### 修复优先级

| 级别 | 定义 | 处理 |
|---|---|---|
| Critical | 编译错误、严重溢出（>20pt） | 立即修复 |
| Major | 内容遮挡、叙事断层、术语缺失中文解释 | 本轮修复 |
| Minor | 轻微间距（<5pt）、小幅对齐 | 可选修复 |

修复后重新编译验证。**最多 3 轮**。

---

## Step 7 — 讲稿生成

**字数配比：** 1分钟 ≈ 200字（中文口播）

每页幻灯片时间预算示例（8分钟 / 16页）：
- 封面：20秒
- 钩子：40秒
- 路线图：25秒
- 内容页：35–45秒/页
- 综合：35秒
- 讨论：30秒

**讲稿格式：**

```latex
\slidesec{2}{钩子：一个思想实验}   \timebox{约 40 秒}

\notebox{[PPT 提示] 此页先指向左栏，图在右侧。}

\speakbox{
我们先从一个非常直观的思想实验开始……

[口播内容，可直接念，约 80 字]

（稍作停顿）
这引出了本次汇报的核心问题——
}

\notebox{[切换] 点击进入第3页（路线图）。}
```

编译讲稿：
```bash
xelatex -interaction=nonstopmode script.tex
xelatex -interaction=nonstopmode script.tex
```

---

## Step 8 — 交付

**验证清单：**

```
□ projects/presentations/[slug]/slides.pdf 存在，页数正确
□ projects/presentations/[slug]/script.pdf 存在，每页均有讲稿节
□ 所有 Critical/Major 问题已修复
□ 字体正确嵌入（XeLaTeX 默认保证）
```

**输出汇报：**

```
✅ slides.pdf  → 幻灯片成品，可直接投影使用
✅ script.pdf  → 讲稿，可打印持稿或参考
```

---

## Step 9 — 常见坑点与解决方案

### 坑 1：引号渲染为两行

**症状：** 引文（quote）莫名其妙分成两行显示。

**原因：** 开引号 `"` 和闭引号 `"` 分别在不同的 `\textit{}` 中，CJK 字体引擎对每个 `\textit{}` 单独处理间距。

**解决：** 把完整引文放在同一个 `\textit{}` 中。
```latex
% 错误：
\textit{"First part.}\\ \textit{Second part."}

% 正确：
\textit{"First part. Second part."}
```

---

### 坑 2：`\\` 在引号内造成分行

**症状：** 引文出现不自然的强制换行。

**解决：** `\textit{}` 内改用空格，让 LaTeX 自然折行。
```latex
% 错误：
\textit{"Long text line one.\\ Line two."}

% 正确：
\textit{"Long text line one. Line two."}
```

---

### 坑 3：TikZ 节点在列内溢出

**症状：** `Overfull \hbox` 警告，节点超出列边界。

**解决：** 列内节点宽度用 `\linewidth`，不用 `\textwidth`。
```latex
% 错误：
\node[minimum width=\textwidth] ...

% 正确：
\node[minimum width=\linewidth] ...
```

---

### 坑 4：内容过密溢出 frame

**症状：** `Overfull \vbox` 警告，内容被截断。

**解决方案（按优先级）：**
1. 删减文字或合并要点
2. 字号降一档（`\small` → `\footnotesize`）
3. 减少 `\vspace` 间距
4. 最后手段：`\begin{frame}[shrink=8]{标题}`（不超过 10）

---

### 坑 5：Kaiti SC 字体找不到

**症状：** 编译报错 `font "Kaiti SC" not found`。

**解决：**
```bash
# 查看系统可用楷体字体
fc-list | grep -i kai

# 修改 slides.tex 中的字体名
\setCJKsansfont{实际字体名}
\setCJKmainfont{实际字体名}
```

---

## 附录：色彩规范

| 变量 | RGB | 用途 |
|---|---|---|
| `deepblue` | 0,52,102 | 主色、标题、边框 |
| `accent` | 196,72,49 | 强调、警告块、重要概念 |
| `gold` | 180,140,40 | 关键引言、装饰线 |
| `lightbg` | 240,245,252 | 封面/结尾背景色 |
