# MEMORY · 研究生PPT汇报解救器

本文件记录实战项目中总结的可复用经验，供 AI Agent 在新任务开始前读取。

---

## 1. LaTeX 排版关键规则

### 引号处理（最高优先级）
- **绝对不要**把开引号 `"` 和闭引号 `"` 放在两个独立的 `\textit{}` 中
- 正确做法：整段引文放在一个 `\textit{}`，`\EN{}` 同理
- 错误示例：`\textit{"First line.}\\ \textit{Second line."}`
- 正确示例：`\textit{"First line. Second line."}`
- 原因：CJK 字体引擎对 U+201C/U+201D 按全角字符处理，分开后会有异常间距

### 强制换行
- `\textit{}` 内**不得**使用 `\\` 强制换行，用空格让 LaTeX 自然折行
- 原因：`\\` 在 `\textit{}` 内会创建视觉上的"两段文字"效果，破坏排版

### Column 内节点宽度
- TikZ 节点在 `\begin{column}` 内必须用 `\linewidth`，不能用 `\textwidth`
- `\textwidth` 在列环境中等于整页宽度，会导致溢出

### 内容过密处理
- 优先减少内容（减文字、合并要点）
- 其次调整字号（`\footnotesize` → `\scriptsize`）
- 最后使用 `\begin{frame}[shrink=N]`（N 不超过 10）

---

## 2. 字体配置

```latex
\setCJKsansfont{Kaiti SC}   % macOS 自带楷体
\setCJKmainfont{Kaiti SC}
\setsansfont{Times New Roman}
\setmainfont{Times New Roman}
```

- macOS：Kaiti SC 系统自带，直接可用
- Windows：字体名通常为 `KaiTi`，需修改配置
- Linux：建议安装 `fonts-arphic-ukai`（文泉驿楷体），字体名为 `AR PL UKai CN`

---

## 3. 图片处理经验

### 全页底图叠加（封面/结尾）
```latex
\begin{tikzpicture}[remember picture,overlay]
  \node[opacity=0.38,anchor=center] at (current page.center){%
    \includegraphics[width=\paperwidth,height=\paperheight,
      keepaspectratio=false]{image.png}};
  \fill[lightbg,opacity=0.28]
    (current page.north west) rectangle (current page.south east);
\end{tikzpicture}
```
- `opacity=0.38`：图片透明度，范围 0.2–0.5 为宜
- `lightbg,opacity=0.28`：背景色遮罩，确保文字可读

### 右侧半页图叠加
```latex
\begin{tikzpicture}[remember picture,overlay]
  \begin{scope}
    \clip (current page.north) rectangle (current page.south east);
    \node[opacity=0.18,anchor=south east] at (current page.south east){%
      \includegraphics[height=\paperheight]{image.png}};
  \end{scope}
\end{tikzpicture}
```

### AI 生成图片建议风格
- 学术内容：写实简洁风，避免卡通过度
- 概念图解：flat design，明确配色
- 封面/结尾：可用戏剧性风格（如侦探、英雄等）

---

## 4. TikZ 图形经验

### 常见坑：节点标签重叠
- 时间轴节点标签：合并为单个 `label` 字符串
  ```latex
  % 错误：
  \node[dot,label={[font=\tiny]above:1795},label={[font=\tiny]left:Kant}]
  % 正确（合并）：
  \node[dot,label={[font=\tiny]left:Kant\\1795}]
  ```

### 图形间距调整
- 三角形布局：水平间距 `±2.8`，垂直高度 `2.2` 到 `4.2`
- scale 参数：0.75–0.85 为多数情况的合适范围

---

## 5. 讲稿生成规范

- 字数配比：1分钟 ≈ 200字（中文口播）
- 每页幻灯片设定 20–50 秒的预算时间
- `\speakbox{}` — 蓝色框，正式口播内容（可直接念）
- `\notebox{}` — 灰色框，舞台提示（[切换]、[PPT 提示]）
- 过渡语建议：
  - 进入下一页："下面我们来看……"
  - 图表解释："图中可以看到……"
  - 总结过渡："综合以上分析……"

---

## 6. 审查流程经验

### 审查顺序
1. `slide-auditor` — 布局溢出、字号、间距
2. `tikz-reviewer` — TikZ 节点碰撞、标签可读性
3. `pedagogy-reviewer` — 叙事弧度、节奏、术语一致性

### 常见 pedagogy 问题
- 两大内容节之间缺少"桥接句"（bridge sentence）
- 技术术语首次出现未给中文解释
- 综合页引入新概念（应只整合已有内容）
- ABM、DID 等缩写在首次使用前未展开

---

## 7. 叙事主线经验

- 叙事主线应**隐性**嵌入，不要在标题或 footer 显式标注
- "反转"效果最佳位置：§9.4 或综合节（压轴）
- 引言（quote）分布建议：
  - 封面：1 句点题
  - 路线图：1 句统领
  - 每个重要节末尾：1 句过渡
  - 结尾：1 句升华
  - 总计不超过 6 句，避免"引言疲劳"
