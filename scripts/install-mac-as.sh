#!/usr/bin/env bash
# =============================================================================
# install-mac-as.sh — One-liner Installer untuk Mac (Apple Silicon & Intel)
# Be A DevOps Employee: Local Machine Track
#
# Usage: curl -fsSL <url> | bash
#        atau: ./scripts/install-mac-as.sh
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log_step() { echo -e "\n${BLUE}${BOLD}▶ $1${NC}"; }
log_ok()   { echo -e "  ${GREEN}✅ $1${NC}"; }
log_skip() { echo -e "  ${YELLOW}⏭  $1 (sudah ada — skip)${NC}"; }
log_fail() { echo -e "  ${RED}❌ ERROR: $1${NC}"; exit 1; }

# ─── Cek OS & Arsitektur ─────────────────────────────────────────────────────
if [[ "$OSTYPE" != "darwin"* ]]; then
  log_fail "Script ini hanya untuk macOS. Gunakan install-linux.sh untuk Linux."
fi

ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
  ARCH_NAME="Apple Silicon (arm64 - M1/M2/M3/M4)"
  BREW_PREFIX="/opt/homebrew"
elif [ "$ARCH" = "x86_64" ]; then
  ARCH_NAME="Intel (x86_64)"
  BREW_PREFIX="/usr/local"
else
  log_fail "Arsitektur tidak didukung: $ARCH (hanya mendukung arm64 dan x86_64)"
fi

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║       Be A DevOps Employee — macOS Installer       ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Target: Mac $ARCH_NAME"
echo -e "  Tool yang akan diinstall: Homebrew, Docker Desktop, KinD, kubectl, Helm, Terraform"
echo ""
read -r -p "  Lanjutkan? (y/N): " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Dibatalkan."; exit 0; }

# ─── Homebrew ────────────────────────────────────────────────────────────────
log_step "1/6 — Homebrew"

if command -v brew &>/dev/null; then
  log_skip "Homebrew $(brew --version | head -1)"
else
  echo "  Menginstall Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Tambahkan ke PATH shell environment
  if [ -f "$BREW_PREFIX/bin/brew" ]; then
    SHELL_PROFILE="$HOME/.zprofile"
    if [ "${SHELL:-}" = "*/bash" ] || [ -f "$HOME/.bash_profile" ] && [ ! -f "$HOME/.zprofile" ]; then
      SHELL_PROFILE="$HOME/.bash_profile"
    fi
    echo "eval \"\$($BREW_PREFIX/bin/brew shellenv)\"" >> "$SHELL_PROFILE"
    eval "$($BREW_PREFIX/bin/brew shellenv)"
  fi

  log_ok "Homebrew terinstall"
fi

# ─── Docker Desktop ───────────────────────────────────────────────────────────
log_step "2/6 — Docker Desktop"

if command -v docker &>/dev/null && docker info &>/dev/null 2>&1; then
  log_skip "Docker $(docker version --format '{{.Client.Version}}' 2>/dev/null)"
else
  if [ -d "/Applications/Docker.app" ]; then
    log_skip "Docker Desktop sudah ada di Applications (belum running)"
    echo -e "  ${YELLOW}  → Buka Docker Desktop dari Launchpad dan tunggu sampai running${NC}"
  else
    echo "  Menginstall Docker Desktop via Homebrew Cask..."
    brew install --cask docker
    echo ""
    echo -e "  ${YELLOW}  ⚠️  Buka Docker Desktop dari Launchpad, tunggu sampai running, lalu tekan Enter...${NC}"
    read -r -p "  Docker Desktop sudah running? (tekan Enter untuk lanjut)"
  fi
fi

# ─── KinD ────────────────────────────────────────────────────────────────────
log_step "3/6 — KinD (Kubernetes in Docker)"

if command -v kind &>/dev/null; then
  log_skip "KinD $(kind version)"
else
  brew install kind
  log_ok "KinD $(kind version)"
fi

# ─── kubectl ─────────────────────────────────────────────────────────────────
log_step "4/6 — kubectl"

if command -v kubectl &>/dev/null; then
  log_skip "kubectl $(kubectl version --client --short 2>/dev/null | head -1)"
else
  brew install kubectl
  log_ok "kubectl $(kubectl version --client --short 2>/dev/null | head -1)"
fi

# ─── Helm ────────────────────────────────────────────────────────────────────
log_step "5/6 — Helm"

if command -v helm &>/dev/null; then
  log_skip "Helm $(helm version --short)"
else
  brew install helm
  log_ok "Helm $(helm version --short)"
fi

# ─── Terraform ───────────────────────────────────────────────────────────────
log_step "6/6 — Terraform"

if command -v terraform &>/dev/null; then
  log_skip "Terraform $(terraform version | head -1)"
else
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
  log_ok "Terraform $(terraform version | head -1)"
fi

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║  ✅  Instalasi selesai!                ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Langkah selanjutnya:"
echo -e "  ${BLUE}1.${NC} Pastikan Docker Desktop sudah running (ikon di menu bar)"
echo -e "  ${BLUE}2.${NC} Jalankan: ${BOLD}./00-preflight/check-env.sh${NC}"
echo ""
