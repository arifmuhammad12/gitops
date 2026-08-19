#!/usr/bin/env bash
# =============================================================================
# install-linux.sh — One-liner Installer untuk Ubuntu/Debian (& WSL2)
# Be A DevOps Employee: Local Machine Track
#
# Usage: curl -fsSL <url> | bash
#        atau: ./scripts/install-linux.sh
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

# ─── Cek OS ──────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" != "linux"* ]]; then
  log_fail "Script ini hanya untuk Linux / WSL2."
fi

if ! command -v apt-get &>/dev/null; then
  log_fail "Script ini hanya untuk distribusi berbasis apt (Ubuntu/Debian)."
fi

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  BINARY_ARCH="amd64" ;;
  aarch64) BINARY_ARCH="arm64" ;;
  *) log_fail "Arsitektur tidak didukung: $ARCH" ;;
esac

# Detect if running in WSL2
IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null; then
  IS_WSL=true
fi

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   Be A DevOps Employee — Linux/WSL2 Installer      ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Target: Linux ${ARCH} $([ "$IS_WSL" = true ] && echo '(WSL2 detected)')"
echo -e "  Tool yang akan diinstall: Docker, KinD, kubectl, Helm, Terraform, Git"
echo ""

if [ "$IS_WSL" = true ]; then
  echo -e "  ${YELLOW}⚠️  WSL2 terdeteksi.${NC}"
  echo -e "  ${YELLOW}  Docker akan diinstall sebagai engine di Linux (bukan Docker Desktop).${NC}"
  echo -e "  ${YELLOW}  Pastikan Docker Desktop di Windows TIDAK digunakan bersamaan jika Anda menginstall ini.${NC}"
  echo ""
fi

read -r -p "  Lanjutkan? (y/N): " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Dibatalkan."; exit 0; }

# ─── System Update ────────────────────────────────────────────────────────────
log_step "0/6 — System update & dependencies"
sudo apt-get update -q
sudo apt-get install -y -q curl wget git apt-transport-https ca-certificates gnupg lsb-release bc python3
log_ok "System packages siap"

# ─── Docker Engine ────────────────────────────────────────────────────────────
log_step "1/6 — Docker Engine"

if command -v docker &>/dev/null && docker info &>/dev/null 2>&1; then
  log_skip "Docker $(docker version --format '{{.Client.Version}}' 2>/dev/null)"
else
  # Remove old versions
  sudo apt-get remove -y -q docker docker-engine docker.io containerd runc 2>/dev/null || true

  # Add Docker GPG key
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # Add Docker repository
  echo \
    "deb [arch=${BINARY_ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -q
  sudo apt-get install -y -q docker-ce docker-ce-cli containerd.io docker-compose-plugin

  # Add user to docker group
  sudo usermod -aG docker "$USER" || true

  # Start Docker service (non-WSL only; WSL2 Docker Desktop handles this)
  if [ "$IS_WSL" = false ]; then
    sudo systemctl enable docker --now
  fi

  log_ok "Docker Engine terinstall"
  echo -e "  ${YELLOW}  → Jika perintah docker masih perlu sudo, logout dan login kembali (atau: newgrp docker)${NC}"
fi

# ─── KinD ────────────────────────────────────────────────────────────────────
log_step "2/6 — KinD (Kubernetes in Docker)"

KIND_VERSION="v0.23.0"

if command -v kind &>/dev/null; then
  log_skip "KinD $(kind version)"
else
  curl -Lo /tmp/kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-${BINARY_ARCH}"
  chmod +x /tmp/kind
  sudo mv /tmp/kind /usr/local/bin/kind
  log_ok "KinD $(kind version)"
fi

# ─── kubectl ─────────────────────────────────────────────────────────────────
log_step "3/6 — kubectl"

if command -v kubectl &>/dev/null; then
  log_skip "kubectl $(kubectl version --client --short 2>/dev/null | head -1)"
else
  KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  curl -Lo /tmp/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${BINARY_ARCH}/kubectl"
  chmod +x /tmp/kubectl
  sudo mv /tmp/kubectl /usr/local/bin/kubectl
  log_ok "kubectl $(kubectl version --client --short 2>/dev/null | head -1)"
fi

# ─── Helm ────────────────────────────────────────────────────────────────────
log_step "4/6 — Helm"

if command -v helm &>/dev/null; then
  log_skip "Helm $(helm version --short)"
else
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  log_ok "Helm $(helm version --short)"
fi

# ─── Terraform ───────────────────────────────────────────────────────────────
log_step "5/6 — Terraform"

if command -v terraform &>/dev/null; then
  log_skip "Terraform $(terraform version | head -1)"
else
  wget -O- https://apt.releases.hashicorp.com/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

  sudo apt-get update -q
  sudo apt-get install -y -q terraform
  log_ok "Terraform $(terraform version | head -1)"
fi

# ─── Git ─────────────────────────────────────────────────────────────────────
log_step "6/6 — Git"

if command -v git &>/dev/null; then
  log_skip "Git $(git --version)"
else
  sudo apt-get install -y -q git
  log_ok "Git $(git --version)"
fi

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║  ✅  Instalasi selesai!                ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Langkah selanjutnya:"
echo -e "  ${BLUE}1.${NC} $([ "$IS_WSL" = true ] && echo 'Pastikan Docker Desktop di Windows sudah running' || echo 'Docker sudah running (systemctl)')"
echo -e "  ${BLUE}2.${NC} Jalankan: ${BOLD}./00-preflight/check-env.sh${NC}"
echo ""

if docker info &>/dev/null 2>&1; then
  echo -e "  ${GREEN}Docker daemon sudah aktif ✅${NC}"
else
  if [ "$IS_WSL" = true ]; then
    echo -e "  ${YELLOW}⚠️  Docker daemon belum aktif. Pastikan Docker Desktop di Windows sudah running.${NC}"
  else
    echo -e "  ${YELLOW}⚠️  Docker daemon belum aktif. Jalankan: sudo systemctl start docker${NC}"
  fi
fi

echo ""
