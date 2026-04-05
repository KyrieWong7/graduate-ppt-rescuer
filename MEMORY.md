# MEMORY · A Click is All You Need
# MEMORY · Graduate Seminar PPT Rescue Kit

本文件记录实战项目中总结的可复用经验，供 AI Agent 在新任务开始前读取。
This file records reusable lessons from production projects, for AI agents to read before starting a new task.

---

## 1. LaTeX 排版关键规则 / LaTeX Typesetting Rules

### 引号处理 / Quote Handling（最高优先级 / Highest priority）
- **绝对不要**把开引号 `"` 和闭引号 `"` 放在两个独立的 `\textit{}` 中
- **Never** split open `"` and close `"` across two separate `\textit{}` blocks
- 正确做法 / Correct: 整段引文放在一个 `\textit{}`，`\EN{}` 同理 / Put entire quote in one `\textit{}`
- 错误示例 / Wrong: `` \textit{"First line.}\\ \textit{Second line."} ``
- 正确示例 / Correct: `` \textit{"First line. Second line."} ``
- 原因 / Reason: CJK 字体引擎对 U+201C/U+201D 按全角字符处理，分开后会有异常间距 / CJK engine applies full-width spacing to each `\textit{}` independently

### 强制换行 / Forced Linebreaks
- `\textit{}` 内**不得**使用 `\\` 强制换行，用空格让 LaTeX 自然折行
- Never use `\\` inside `\textit{}` — use spaces and let LaTeX wrap naturally
- 原因 / Reason: `\\` 在 `\textit{}` 内会创建视觉上的"两段文字"效果 / Creates visual "two separate strings" effect

### Column 内节点宽度 / Node Width in Columns
- TikZ 节点在 `\begin{column}` 内必须用 `\linewidth`，不能用 `\textwidth`
- Inside `\begin{column}`, TikZ nodes must use `\linewidth`, not `\textwidth`
- `\textwidth` 在列环境中等于整页宽度，会导致溢出 / `\textwidth` equals full page width in column context — causes overflow

### 内容过密处理 / Overflow Handling
- 优先减少内容 → 调字号 → 最后 `[shrink=N]` (N ≤ 10)
- Priority: reduce content → reduce font size → last resort `[shrink=N]` (N ≤ 10)

### TikZ fill + node midway 冲突 / TikZ fill + midway conflict
- `\fill[...] (a) rectangle (b) node[midway]{text}` 语法无效 / This pattern is INVALID
- 必须分开写 / Must write separately:
  ```latex
  \fill[blue] (0,0) rectangle (2,1);
  \node at (1,0.5) {text};
  ```

---

## 2. 字体配置 / Font Configuration

**使用 `config.tex` 统一管理，不要在模板中硬编码 / Use `config.tex` — never hardcode in template:**

```latex
%% config.tex — Edit this file only / 只改这个文件
\newcommand{\cjkfont}{Kaiti SC}         % CJK font
\newcommand{\latinfont}{Times New Roman} % Latin font
\definecolor{deepblue}{RGB}{0,52,102}   % Primary color
```

**模板中引用 / In template:**
```latex
\input{config.tex}
\setCJKsansfont{\cjkfont}
\setCJKmainfont{\cjkfont}
\setsansfont{\latinfont}
\setmainfont{\latinfont}
```

**各平台字体名 / Font names by platform:**
- macOS: `Kaiti SC` (system default 系统自带)
- Windows: `KaiTi`
- Linux: `AR PL UKai CN` (install with `sudo apt install fonts-arphic-ukai`)

**缺包问题 / Missing packages in basic TeX Live:**
- `titlesec.sty` 可能不在 basic 发行版中，需安装或移除 / May not be in basic distribution, install or remove
- `fancyhdr.sty` 通常可用 / Usually available
- `hyperref` 在 Beamer 文档类中已内置，article 中单独加载 / In Beamer it is built-in; load separately for article class

---

## 3. 图片处理经验 / Image Handling

### 全页底图叠加 / Full-page background overlay (cover/ending)
```latex
\begin{tikzpicture}[remember picture,overlay]
  \node[opacity=0.38,anchor=center] at (current page.center){%
    \includegraphics[width=\paperwidth,height=\paperheight,
      keepaspectratio=false]{image.png}};
  \fill[lightbg,opacity=0.28]
    (current page.north west) rectangle (current page.south east);
\end{tikzpicture}
```
- `opacity=0.38` — 图片透明度 / image opacity，0.2–0.5 为宜 / range 0.2–0.5
- `lightbg,opacity=0.28` — 遮罩确保文字可读 / overlay ensures text readability

### 右侧半页图叠加 / Right-half page overlay
```latex
\begin{tikzpicture}[remember picture,overlay]
  \begin{scope}
    \clip (current page.north) rectangle (current page.south east);
    \node[opacity=0.18,anchor=south east] at (current page.south east){%
      \includegraphics[height=\paperheight]{image.png}};
  \end{scope}
\end{tikzpicture}
```

### AI 生成图片建议 / AI image generation tips
- Chiikawa 风格 kawaii 插图：使用 GenerateImage 工具，明确指定 "Chiikawa-style kawaii cartoon, clean line art, pastel colors"
- 学术内容：写实简洁风，避免卡通过度
- 概念图解：flat design，明确配色与 config.tex 一致
- Chiikawa kawaii style: specify "Chiikawa-style kawaii cartoon, clean line art, pastel colors"
- Academic content: clean realistic style, avoid excessive cartoon
- Concept diagrams: flat design matching config.tex color palette

---

## 4. TikZ 图形经验 / TikZ Diagram Lessons

### 节点标签重叠 / Node label overlap
时间轴节点标签合并为单个 `label` / Merge timeline node labels into single `label`:
```latex
% 错误 Wrong:
\node[dot,label={above:1795},label={left:Kant}] ...
% 正确 Correct:
\node[dot,label={left:Kant\\1795}] ...
```

### 图形间距 / Diagram spacing
- 三角形布局 / Triangle layout: 水平 ±2.8，垂直 2.2 到 4.2
- scale 参数 / Scale: 0.75–0.85 为多数情况的合适范围 / suitable for most cases
- 竖向流水线 / Vertical pipeline: `node distance=0.28cm` 配合 `minimum height=0.7cm`

### Verbatim 在 Beamer 中 / Verbatim in Beamer
使用 `fancyvrb` 包的 `Verbatim` 环境（大写 V），frame 必须带 `[fragile]` / Use `Verbatim` (capital V) from `fancyvrb`; frame must have `[fragile]`:
```latex
\begin{frame}[fragile]{Title}
  \begin{Verbatim}[fontsize=\tiny,frame=single]
  code here
  \end{Verbatim}
\end{frame}
```

---

## 5. 讲稿生成规范 / Script Generation

- 字数配比 / Word rate: 1分钟 ≈ 200字（中文口播）/ 1 minute ≈ 200 Chinese characters
- 每页幻灯片 20–50 秒预算 / 20–50 seconds per slide budget
- `\speakbox{}` — 蓝色框，正式口播内容（可直接念）/ Blue box, spoken content (ready to read aloud)
- `\notebox{}` — 灰色框，舞台提示 / Gray box, stage directions
- 讲稿 `titlesec` 包在 basic TeX Live 中可能缺失，用 `\vspace` + `\noindent\rule` 替代 / `titlesec` may be missing in basic TeX Live; replace with `\vspace` + `\noindent\rule`
- 过渡语 / Transition phrases:
  - 进入下一页 / Next slide: "下面我们来看……"
  - 图表解释 / Chart explanation: "图中可以看到……"
  - 总结过渡 / Summary: "综合以上分析……"

---

## 6. 审查流程经验 / Review Process

### 审查顺序 / Review order
1. `slide-auditor` — 布局溢出、字号、间距 / Layout overflow, font size, spacing
2. `tikz-reviewer` — TikZ 节点碰撞、标签可读性 / Node collisions, label readability
3. `pedagogy-reviewer` — 叙事弧度、节奏、术语一致性 / Narrative arc, pacing, terminology

### 常见 pedagogy 问题 / Common pedagogy issues
- 两大内容节之间缺少"桥接句" / Missing bridge sentences between sections
- 技术术语首次出现未给中文解释 / Technical terms missing Chinese gloss on first use
- 综合页引入新概念（应只整合已有内容）/ Synthesis slide introduces new concepts (should only integrate existing)
- ABM、DID 等缩写在首次使用前未展开 / Abbreviations not spelled out on first use

---

## 7. 叙事主线经验 / Narrative Arc Lessons

- 叙事主线应**隐性**嵌入，不要在标题或 footer 显式标注 / Narrative should be implicit, not labeled in titles or footers
- "反转"效果最佳位置：§4 或综合节 / Best position for reversal: last content section or synthesis
- 引言（quote）分布 / Quote distribution:
  - 封面 Cover: 1 句点题 / 1 scene-setting quote
  - 路线图 Roadmap: 1 句统领 / 1 overarching quote
  - 每个重要节末尾 / End of major sections: 1 句过渡
  - 结尾 Ending: 1 句升华 / 1 elevating quote
  - 总计不超过 6 句，避免"引言疲劳" / Max 6 total, avoid "quote fatigue"

---

## 8. 项目优点速查 / Project Advantages Quick Reference

在向用户介绍本工作流时，强调以下 8 点 / When introducing this workflow, emphasize these 8 points:

| 标签 / Label | 优点 / Advantage | 对比 / vs. Office |
|---|---|---|
| A Rigor | XeLaTeX pt 精确排版 | 像素级手动调整 |
| B Freedom | TikZ + 叙事弧内置 | 截图拼贴 |
| C Pipeline | 8阶段全流程 | 各步骤独立 |
| D Plan-First | 5维问卷先问再做 | AI 直接猜需求 |
| E Triple Review | 3 agents 并行审查 | 人工单轮检查 |
| F Script Sync | slides+script 同步 | 另写 Word 文档 |
| G Illustration | AI 配图自动嵌入 | 手动找图调DPI |
| H Config | config.tex 1处改 | 逐帧手动调格式 |
