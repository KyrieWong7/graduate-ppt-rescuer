<div align="center">

<img src="assets/chiikawa-banner.png" alt="研究生PPT汇报解救器" width="100%"/>

# 🐭 研究生PPT汇报解救器

**在 Cursor 里对 AI 说一句话，自动生成专业中英双语学术汇报**

[![XeLaTeX](https://img.shields.io/badge/Engine-XeLaTeX-blue?logo=latex&logoColor=white)](https://www.tug.org/xelatex/)
[![ctex](https://img.shields.io/badge/CJK-ctex-red)](https://ctan.org/pkg/ctex)
[![Beamer](https://img.shields.io/badge/Format-Beamer-orange)](https://ctan.org/pkg/beamer)
[![Cursor](https://img.shields.io/badge/IDE-Cursor-black?logo=cursor)](https://cursor.sh)
[![License: MIT](https://img.shields.io/badge/License-MIT-green)](LICENSE)

> 给每一个在截止日期前被 PPT 折磨过的研究生 🫂

</div>

---

## ✨ 能做什么

| 功能 | 说明 |
|---|---|
| 🎯 **Plan 模式问需求** | 启动时自动进入 Plan 模式，用结构化问卷收集需求，不乱猜 |
| 📄 **双语 Beamer 幻灯片** | 楷体 + Times New Roman，中英文混排，专业学术风格 |
| 🖼️ **AI 配图** | 自动生成或处理你提供的图片，嵌入到对应幻灯片 |
| 🎨 **TikZ 图形** | DAG 因果图、时间轴、三角总览图、流程图，一应俱全 |
| 📝 **完整讲稿** | 同步输出可直接朗读的 `script.pdf`，含舞台提示 |
| 🔍 **AI 质量审查** | slide-auditor + tikz-reviewer + pedagogy-reviewer 三重把关 |
| 🔧 **环境自动检测** | `setup.sh` 一键检测 XeLaTeX、字体、Python 依赖 |

---

## 🚀 快速上手（3 步）

### 第 1 步：克隆并检测环境

```bash
git clone https://github.com/KyrieWong7/graduate-ppt-rescuer.git
cd graduate-ppt-rescuer
bash setup.sh
```

### 第 2 步：在 Cursor 中打开

```bash
cursor .
```

> `.cursor/` 目录中的 skills / agents / rules 会被 Cursor AI **自动加载**，无需手动配置。

### 第 3 步：对 AI 说一句话

```
帮我做一个汇报
```

AI 会自动切换到 **Plan 模式**，逐步询问：

- 汇报主题和素材（PDF / DOCX）
- 目标页数和时长
- 是否中英双语、是否需要叙事主线
- 是否 AI 生成配图、是否需要讲稿

确认计划后，全自动生成 `slides.pdf` + `script.pdf`。

---

## 🗂️ 工作流总览

<div align="center">
<img src="assets/chiikawa-workflow.png" alt="工作流图解" width="85%"/>
</div>

```
📄 素材（PDF/DOCX）
    ↓  Step 1  AI 摄入，提取核心概念
    ↓  Step 2  脚手架搭建，从模板复制
    ↓  Step 3  逐页生成双语内容
    ↓  Step 4  AI 配图处理
    ↓  Step 5  XeLaTeX 首次编译（×2）
    ↓  Step 6  三重质量审查 + 修复
    ↓  Step 7  讲稿生成（script.tex → PDF）
    ↓  Step 8  交付验证
📑 slides.pdf  +  📝 script.pdf
```

→ 详细说明见 [WORKFLOW.md](WORKFLOW.md)

---

## 📁 仓库结构

```
graduate-ppt-rescuer/
├── README.md                        # 本文件
├── AGENTS.md                        # Cursor AI 行为说明（自动读取）
├── WORKFLOW.md                      # 9 步工作流详细文档
├── MEMORY.md                        # 可复用经验摘要（AI agent 读取）
├── setup.sh                         # 环境自动检测脚本
│
├── .cursor/
│   ├── rules/
│   │   ├── ppt-intake.mdc           # ★ 触发 Plan 模式收集需求
│   │   ├── plan-first-workflow.mdc  # 执行前必须有计划
│   │   ├── orchestrator-protocol.mdc
│   │   └── session-logging.mdc
│   ├── skills/
│   │   ├── ppt-pipeline/            # ★ 主编排 skill（8 阶段流水线）
│   │   ├── workflow-intake/         # 需求摄入
│   │   ├── slide-excellence/        # 综合审查
│   │   ├── visual-audit/            # 视觉审查
│   │   ├── pedagogy-review/         # 叙事审查
│   │   └── compile-latex/           # 编译
│   └── agents/
│       ├── slide-auditor.md         # 布局检查员
│       ├── tikz-reviewer.md         # 图形检查员
│       └── pedagogy-reviewer.md     # 教学质量检查员
│
├── templates/
│   ├── slides-template.tex          # 中英双语 Beamer 最小模板
│   └── script-template.tex          # 讲稿模板（\speakbox / \notebox）
│
├── demo/
│   └── README.md                    # 示例效果说明
│
└── assets/
    └── chiikawa-*.png               # Chiikawa 主题配图
```

---

## 🎓 效果示例

<div align="center">
<img src="assets/chiikawa-rescue.png" alt="救援场景" width="75%"/>
</div>

本工作流曾用于生成一份完整的研究生课堂汇报：

- **主题**：社会科学哲学中的因果与规律（学术专著特定章节）
- **规格**：16 页 / 8 分钟 / 中英双语
- **亮点**：8 个 TikZ 图形 + 4 张 AI 配图 + 侦探叙事暗线
- **附件**：完整口播讲稿 PDF

→ 详细说明见 [demo/README.md](demo/README.md)

---

## ⚙️ 环境要求

| 依赖 | 说明 | 安装 |
|---|---|---|
| **Cursor** | 必须，工作流依赖 AI agent | [cursor.sh](https://cursor.sh) |
| **XeLaTeX** | 编译引擎，不支持 pdflatex | macOS: `brew install --cask mactex-no-gui` |
| **Kaiti SC** | 中文楷体字体 | macOS 系统自带 |
| **Python 3** | 素材提取 | `brew install python` |
| **python-docx** | DOCX 读取 | `pip3 install python-docx` |
| **PyMuPDF** | PDF 读取 | `pip3 install pymupdf` |

> 运行 `bash setup.sh` 自动检测所有依赖并给出安装指引。

### Windows / Linux 字体配置

将 `templates/slides-template.tex` 中的字体名替换：

```latex
% Windows（系统自带楷体）
\setCJKsansfont{KaiTi}
\setCJKmainfont{KaiTi}

% Linux（文泉驿楷体）
% sudo apt install fonts-arphic-ukai
\setCJKsansfont{AR PL UKai CN}
\setCJKmainfont{AR PL UKai CN}
```

---

## 🔑 核心技术约定

```latex
% 英文术语斜体标注
\EN{Causal Inference}

% 节标签（浅色小字）
\begin{frame}{节标题 \sectag{Section Tag}}

% 关键引言（金色）
\textcolor{gold}{\textbf{\textit{"One body. Twelve suspects."}}}

% 引号：Unicode 弯引号（不用 ASCII 直引号）
" "   →  U+201C / U+201D  （正确）
" "   →  U+0022           （会有 CJK 字体间距问题）

% TikZ 列内节点宽度：\linewidth 不是 \textwidth
\node[minimum width=\linewidth] ...
```

---

## 🐛 常见问题

**Q：引号显示成两行？**  
A：确保开引号 `"` 和闭引号 `"` 在同一个 `\textit{}` 里，不要跨命令。

**Q：编译报字体错误？**  
A：运行 `fc-list | grep -i kai` 查看系统实际字体名，修改模板中的 `\setCJKsansfont{}`。

**Q：内容溢出（Overfull vbox）？**  
A：优先减少文字，其次降字号，最后用 `\begin{frame}[shrink=8]{}`。

→ 更多坑点见 [WORKFLOW.md#常见坑点](WORKFLOW.md)

---

## 📄 许可证

MIT License — 自由使用、修改、分发，保留署名即可。

---

<div align="center">

<img src="assets/chiikawa-ending.png" alt="庆祝完成" width="70%"/>

**做完了！slides.pdf 和 script.pdf 都在等你 🎉**

*由 [KyrieWong7](https://github.com/KyrieWong7) 在无数次被 PPT 折磨后创作*

</div>
