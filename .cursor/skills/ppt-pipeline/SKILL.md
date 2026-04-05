---
name: ppt-pipeline
description: 研究生PPT汇报主编排 skill。从素材摄入到交付 slides.pdf + script.pdf 的完整 8 阶段流水线。使用前必须已完成需求摄入（ppt-intake 规则）。
argument-hint: "[项目 slug] [slides页数] [时长分钟]"
---

# PPT 汇报生成流水线

## 前置检查

执行前确认：
- 已有需求摘要（`quality_reports/specs/[slug]-spec.md`）
- `setup.sh` 已运行，XeLaTeX 可用
- 用户已确认执行计划

---

## 阶段 1 — 素材摄入

```
目标：理解原始材料，提炼可用内容
```

1. 读取所有提供的 PDF / DOCX 文件
2. 对 PDF 使用 Python `fitz`（PyMuPDF）或直接读取文本层提取内容
3. 对 DOCX 使用 Python `python-docx` 读取结构
4. 输出：章节大纲 + 核心概念列表 + 潜在叙事主线建议

---

## 阶段 2 — 脚手架搭建

```
目标：创建项目目录结构，复制模板文件
```

```bash
mkdir -p projects/presentations/[slug]/images
cp templates/slides-template.tex projects/presentations/[slug]/slides.tex
cp templates/script-template.tex projects/presentations/[slug]/script.tex
```

将幻灯片元信息（标题、作者、课程、日期）填入 `slides.tex` 的 `\title` / `\author` / `\institute` / `\date`。

---

## 阶段 3 — 内容生成

```
目标：按需求填充所有幻灯片内容
```

**标准页面结构**（可根据需求调整）：
- 封面（cover）
- 钩子页（hook）— 可选叙事引入
- 路线图（roadmap）— 4~5 节概览
- 内容节（×3~4）— 每节 2~3 页
- 综合页（synthesis）
- 讨论页（discussion）

**双语排版约定**：
- `\EN{English Term}` — 标注英文专业术语
- `\sectag{Section Tag}` — 节标签（浅色小字）
- 引号：使用 Unicode 弯引号（`"` U+201C / `"` U+201D）
- 不在 `\textit{}` 内使用 `\\` 强制换行，改用空格自然折行
- TikZ 节点宽度在 column 内使用 `\linewidth`，不用 `\textwidth`

---

## 阶段 4 — 图片处理

```
目标：为关键幻灯片配图
```

- AI 生成图片 → 使用 `GenerateImage` 工具，保存到 `images/` 文件夹
- 用户提供图片 → 复制到 `images/` 文件夹
- 封面/结尾底图：使用 TikZ overlay + `opacity` 分层
  ```latex
  \begin{tikzpicture}[remember picture,overlay]
    \node[opacity=0.38,anchor=center] at (current page.center){%
      \includegraphics[width=\paperwidth,height=\paperheight,
        keepaspectratio=false]{image.png}};
    \fill[lightbg,opacity=0.28]
      (current page.north west) rectangle (current page.south east);
  \end{tikzpicture}
  ```

---

## 阶段 5 — 首次编译

```
目标：确认 slides.tex 无编译错误
```

```bash
cd projects/presentations/[slug]
xelatex -interaction=nonstopmode slides.tex
xelatex -interaction=nonstopmode slides.tex  # 第二遍
```

检查：
- `slides.pdf` 存在
- 页数符合需求
- 无 `! Error` 行（`Overfull \hbox` 警告可接受，记录备查）

---

## 阶段 6 — 质量审查循环（最多 3 轮）

```
目标：识别并修复布局、图形、叙事问题
```

**并行启动**：
- `slide-auditor` agent — 检查溢出、字号、间距、图片引用
- `tikz-reviewer` agent — 检查 TikZ 节点碰撞、标签可读性

**串行**：
- `pedagogy-reviewer` agent — 检查叙事弧度、节奏、术语一致性

**修复优先级**：
- Critical（编译错误、严重溢出）→ 立即修复
- Major（关键内容遮挡、叙事断层）→ 本轮修复
- Minor（轻微间距）→ 可选

每轮修复后重新编译，验证问题已解决。

---

## 阶段 7 — 讲稿生成

```
目标：生成可直接朗读的完整讲稿 script.pdf
```

讲稿结构（每页幻灯片对应一节）：

```latex
\slidesec{页码}{幻灯片标题}
\speakbox{
  这里是口播内容，可以直接念。时长约 XX 秒。
  包含过渡语、解释说明、举例。
}
\notebox{
  [舞台提示] 切换到下一张幻灯片。
  [PPT 提示] 此处有动画，先展示左栏。
}
```

约定：
- `\speakbox` — 蓝色边框，直接口播
- `\notebox` — 灰色背景，舞台提示/PPT 操作提示，不念出
- 总字数约 = 汇报时长（分钟）× 200 字/分钟

编译讲稿：
```bash
xelatex -interaction=nonstopmode script.tex
xelatex -interaction=nonstopmode script.tex
```

---

## 阶段 8 — 交付验证

```
目标：确认所有输出文件存在且符合规格
```

交付检查清单：

```
□ slides.pdf 存在，页数正确
□ script.pdf 存在，每页幻灯片均有对应讲稿节
□ 无 critical/major 未解决问题
□ 两个 PDF 的字体均正确嵌入（XeLaTeX 默认保证）
```

输出文件路径汇报：
```
✅ slides.pdf  → projects/presentations/[slug]/slides.pdf
✅ script.pdf  → projects/presentations/[slug]/script.pdf
```
