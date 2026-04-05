#!/bin/bash
# ============================================================
#  研究生PPT汇报解救器 · 环境检测脚本
#  运行方式：bash setup.sh
# ============================================================

set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

ok()   { echo -e "${GREEN}✅ $1${RESET}"; }
warn() { echo -e "${YELLOW}⚠️  $1${RESET}"; }
err()  { echo -e "${RED}❌ $1${RESET}"; }
info() { echo -e "   ${BOLD}$1${RESET}"; }

echo ""
echo -e "${BOLD}🐭 研究生PPT汇报解救器 · 环境检测${RESET}"
echo "============================================"
echo ""

ALL_OK=true

# ── 1. 检查操作系统 ──────────────────────────────────────────
OS="$(uname -s)"
case "$OS" in
  Darwin) ok "操作系统：macOS $(sw_vers -productVersion)" ;;
  Linux)  ok "操作系统：Linux" ;;
  *)      warn "操作系统：$OS（未经测试，可能需要手动适配）" ;;
esac

# ── 2. 检查 XeLaTeX ──────────────────────────────────────────
echo ""
if command -v xelatex &>/dev/null; then
  VER=$(xelatex --version 2>&1 | head -1)
  ok "XeLaTeX：$VER"
else
  err "XeLaTeX 未安装"
  ALL_OK=false
  echo ""
  info "安装方法："
  case "$OS" in
    Darwin)
      info "  方法 1（推荐，较小）：brew install --cask mactex-no-gui"
      info "  方法 2（完整版）：https://tug.org/mactex/"
      ;;
    Linux)
      info "  Ubuntu/Debian：sudo apt install texlive-xetex texlive-lang-chinese"
      info "  Arch：sudo pacman -S texlive-xetex texlive-langchinese"
      ;;
  esac
fi

# ── 3. 检查 Kaiti SC 字体 ────────────────────────────────────
echo ""
if command -v fc-list &>/dev/null; then
  if fc-list | grep -qi "kaiti sc"; then
    ok "Kaiti SC 字体：已找到"
  elif fc-list | grep -qi "kaiti"; then
    warn "找到 Kaiti 字体，但不确定是否为 Kaiti SC（macOS 版本）"
    info "如编译报字体错误，请将 slides-template.tex 中的"
    info "'Kaiti SC' 替换为 fc-list 中显示的实际字体名"
  else
    err "Kaiti SC（楷体）字体未找到"
    ALL_OK=false
    echo ""
    info "安装方法："
    case "$OS" in
      Darwin)
        info "  macOS 系统自带，请检查是否完整安装了系统字体"
        info "  系统偏好设置 → 字体册 → 搜索 Kaiti"
        ;;
      Linux)
        info "  下载思源楷体（Adobe Source Han Serif）或文泉驿楷体"
        info "  sudo apt install fonts-arphic-ukai  # 文泉驿楷体（备选）"
        info "  安装后修改 slides-template.tex 中的字体名"
        ;;
      *)
        info "  Windows：系统自带楷体，字体名为 KaiTi，修改模板中的字体配置"
        ;;
    esac
  fi
else
  warn "fc-list 命令不可用，无法检测字体（可能需要安装 fontconfig）"
fi

# ── 4. 检查 Python 3（素材提取用）────────────────────────────
echo ""
if command -v python3 &>/dev/null; then
  PY_VER=$(python3 --version)
  ok "Python 3：$PY_VER"

  # 检查 python-docx
  if python3 -c "import docx" 2>/dev/null; then
    ok "python-docx：已安装（DOCX 素材提取）"
  else
    warn "python-docx 未安装（DOCX 素材提取时需要）"
    info "安装：pip3 install python-docx"
  fi

  # 检查 PyMuPDF
  if python3 -c "import fitz" 2>/dev/null; then
    ok "PyMuPDF：已安装（PDF 素材提取）"
  else
    warn "PyMuPDF 未安装（PDF 素材提取时需要）"
    info "安装：pip3 install pymupdf"
  fi
else
  warn "Python 3 未安装（素材自动提取功能需要）"
  info "安装：https://www.python.org/downloads/"
fi

# ── 5. 检查 gh CLI（上传 GitHub 时用）───────────────────────
echo ""
if command -v gh &>/dev/null; then
  ok "GitHub CLI（gh）：已安装"
  if gh auth status &>/dev/null 2>&1; then
    ok "GitHub 已登录"
  else
    warn "GitHub 未登录，运行 'gh auth login' 完成授权"
  fi
else
  info "GitHub CLI 未安装（仅推送到 GitHub 时需要）"
  info "安装：https://cli.github.com/"
fi

# ── 汇总 ─────────────────────────────────────────────────────
echo ""
echo "============================================"
if $ALL_OK; then
  echo -e "${GREEN}${BOLD}🎉 环境就绪！可以开始在 Cursor 中对 AI 说"帮我做汇报"。${RESET}"
else
  echo -e "${YELLOW}${BOLD}⚠️  有项目需要处理，请按上方提示安装缺失依赖。${RESET}"
fi
echo ""
