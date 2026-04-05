# 研究生PPT汇报解救器 · AI Agent 行为说明

本工作区是一个 **Cursor 工作区模板**，专为从学术文献或课程材料快速生成专业中英双语 Beamer 汇报而设计。

## 首次打开时

1. 运行 `setup.sh` 检查环境（XeLaTeX、Kaiti SC 字体）
2. 阅读 `MEMORY.md` 了解本工作流的关键经验
3. 阅读 `WORKFLOW.md` 了解完整的 9 步流程

## 遇到 PPT/汇报/slides 相关请求时

**必须** 先进入 Plan 模式，执行以下步骤：

1. 读取 `MEMORY.md` 中的关键经验条目
2. 使用 `ppt-pipeline` skill 进行主编排
3. 用 `AskQuestion` 工具收集用户需求（见 `.cursor/rules/ppt-intake.mdc`）
4. 生成执行计划，等待用户确认后再执行

## 输出规范

每次汇报生成任务**必须**交付两个文件：

- `projects/presentations/[项目名]/slides.pdf` — 幻灯片成品
- `projects/presentations/[项目名]/script.pdf` — 完整讲稿

## 技术约定

- 编译引擎：**XeLaTeX**（不得使用 pdflatex）
- 中文字体：**Kaiti SC**（楷体，macOS 系统自带）
- 英文字体：**Times New Roman**
- 主题：**Beamer Boadilla**
- 编译次数：**两遍**（生成正确的目录和交叉引用）
- 引号：使用 Unicode 弯引号（U+201C `"` 和 U+201D `"`），不使用 ASCII 直引号

## 项目目录约定

```
projects/
└── presentations/
    └── [项目 slug]/
        ├── slides.tex
        ├── script.tex
        ├── slides.pdf      ← 必须交付
        ├── script.pdf      ← 必须交付
        └── images/
            └── *.png / *.jpg
```

## 质量门禁

生成完成后，必须依次调用：

1. `slide-auditor` agent — 检查布局溢出和视觉问题
2. `tikz-reviewer` agent — 检查 TikZ 图形
3. `pedagogy-reviewer` agent — 检查叙事结构和教学节奏
4. 修复所有 critical 和 major 问题后重新编译
