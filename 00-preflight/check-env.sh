#!/usr/bin/env bash
# =============================================================================
# check-env.sh — Pre-flight Environment Checker
# Be A DevOps Employee: Local Machine Track
#
# Usage:
#   ./00-preflight/check-env.sh          # Human-readable output
#   ./00-preflight/check-env.sh --json   # JSON output (untuk web checker)
# =============================================================================

# Use bash explicitly (not sh) — requires bash 3.2+ (macOS default bash is 3.2)
if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Config ──────────────────────────────────────────────────────────────────
MIN_RAM_GB=8
MIN_DISK_GB=20
MIN_DOCKER_MAJOR=24
MIN_KIND_MINOR=20
MIN_KUBECTL_MINOR=28
MIN_HELM_MINOR=14
MIN_TERRAFORM_MINOR=8

# ─── Results storage (flat vars — bash 3.2 compatible) ───────────────────────
JSON_OUTPUT=false
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

# Per-tool results: status, version, message
r_docker_status=""; r_docker_version=""; r_docker_msg=""
r_kind_status=""; r_kind_version=""; r_kind_msg=""
r_kubectl_status=""; r_kubectl_version=""; r_kubectl_msg=""
r_helm_status=""; r_helm_version=""; r_helm_msg=""
r_terraform_status=""; r_terraform_version=""; r_terraform_msg=""
r_git_status=""; r_git_version=""; r_git_msg=""
r_ram_status=""; r_ram_version=""; r_ram_msg=""
r_disk_status=""; r_disk_version=""; r_disk_msg=""

# ─── Helpers ─────────────────────────────────────────────────────────────────
set_pass() {
  local tool="$1" ver="$2"
  eval "r_${tool}_status='pass'"
  eval "r_${tool}_version='${ver}'"
  eval "r_${tool}_msg=''"
  PASS_COUNT=$((PASS_COUNT + 1))
}

set_fail() {
  local tool="$1" msg="$2"
  eval "r_${tool}_status='fail'"
  eval "r_${tool}_version='not found'"
  eval "r_${tool}_msg='${msg}'"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

set_warn() {
  local tool="$1" ver="$2" msg="$3"
  eval "r_${tool}_status='warn'"
  eval "r_${tool}_version='${ver}'"
  eval "r_${tool}_msg='${msg}'"
  WARN_COUNT=$((WARN_COUNT + 1))
}

# ─── Checks ──────────────────────────────────────────────────────────────────

check_docker() {
  if ! command -v docker &>/dev/null; then
    set_fail "docker" "Tidak ditemukan. Install: https://docs.docker.com/get-docker/"
    return
  fi
  if ! docker info &>/dev/null 2>&1; then
    set_fail "docker" "Terinstall tapi daemon tidak berjalan. Buka Docker Desktop atau jalankan: sudo systemctl start docker"
    return
  fi
  local ver
  ver=$(docker version --format '{{.Client.Version}}' 2>/dev/null | head -1)
  local major
  major=$(echo "$ver" | cut -d. -f1)
  if [ "${major:-0}" -ge "$MIN_DOCKER_MAJOR" ]; then
    set_pass "docker" "$ver"
  else
    set_warn "docker" "$ver" "Versi lama (minimum ${MIN_DOCKER_MAJOR}.x). Update Docker."
  fi
}

check_kind() {
  if ! command -v kind &>/dev/null; then
    set_fail "kind" "Tidak ditemukan. Install: https://kind.sigs.k8s.io/docs/user/quick-start/"
    return
  fi
  local ver
  ver=$(kind version 2>/dev/null | awk '{print $2}' | tr -d 'v')
  local minor
  minor=$(echo "$ver" | cut -d. -f2)
  if [ "${minor:-0}" -ge "$MIN_KIND_MINOR" ]; then
    set_pass "kind" "v$ver"
  else
    set_warn "kind" "v$ver" "Disarankan KinD >= 0.${MIN_KIND_MINOR}.x"
  fi
}

check_kubectl() {
  if ! command -v kubectl &>/dev/null; then
    set_fail "kubectl" "Tidak ditemukan. Install: https://kubernetes.io/docs/tasks/tools/"
    return
  fi
  local ver
  ver=$(kubectl version --client --short 2>/dev/null | head -1 | awk '{print $3}' | tr -d 'v' || echo "")
  if [ -z "$ver" ]; then
    # kubectl 1.28+ uses different format
    ver=$(kubectl version --client -o json 2>/dev/null | grep '"gitVersion"' | head -1 | awk -F'"' '{print $4}' | tr -d 'v' || echo "unknown")
  fi
  local minor
  minor=$(echo "$ver" | cut -d. -f2 | tr -d '+')
  if [ "${minor:-0}" -ge "$MIN_KUBECTL_MINOR" ]; then
    set_pass "kubectl" "v$ver"
  else
    set_warn "kubectl" "v$ver" "Disarankan kubectl >= 1.${MIN_KUBECTL_MINOR}"
  fi
}

check_helm() {
  if ! command -v helm &>/dev/null; then
    set_fail "helm" "Tidak ditemukan. Install: https://helm.sh/docs/intro/install/"
    return
  fi
  local ver_raw ver major minor
  ver_raw=$(helm version --short 2>/dev/null | head -1)
  # Extract version: handles both "v3.15.3" and "v4.1.4+xxx" formats
  ver=$(echo "$ver_raw" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
  major=$(echo "$ver" | cut -d. -f1)
  minor=$(echo "$ver" | cut -d. -f2)
  # Helm 4.x is newer than 3.x, always pass
  if [ "${major:-0}" -ge 4 ]; then
    set_pass "helm" "v$ver (Helm 4.x)"
  elif [ "${major:-0}" -eq 3 ] && [ "${minor:-0}" -ge "$MIN_HELM_MINOR" ]; then
    set_pass "helm" "v$ver"
  else
    set_warn "helm" "v${ver:-unknown}" "Disarankan Helm >= 3.${MIN_HELM_MINOR} atau Helm 4.x"
  fi
}

check_terraform() {
  if ! command -v terraform &>/dev/null; then
    set_fail "terraform" "Tidak ditemukan. Install: https://developer.hashicorp.com/terraform/install"
    return
  fi
  local ver
  ver=$(terraform version 2>/dev/null | head -1 | awk '{print $2}' | tr -d 'v')
  local minor
  minor=$(echo "$ver" | cut -d. -f2)
  if [ "${minor:-0}" -ge "$MIN_TERRAFORM_MINOR" ]; then
    set_pass "terraform" "v$ver"
  else
    set_warn "terraform" "v$ver" "Disarankan Terraform >= 1.${MIN_TERRAFORM_MINOR}"
  fi
}

check_git() {
  if ! command -v git &>/dev/null; then
    set_fail "git" "Tidak ditemukan. Install: https://git-scm.com/downloads"
    return
  fi
  local ver
  ver=$(git --version | awk '{print $3}')
  local major
  major=$(echo "$ver" | cut -d. -f1)
  if [ "${major:-0}" -ge 2 ]; then
    set_pass "git" "$ver"
  else
    set_warn "git" "$ver" "Disarankan Git >= 2.x"
  fi
}

check_ram() {
  local ram_gb=0
  if [[ "$OSTYPE" == "darwin"* ]]; then
    local ram_bytes
    ram_bytes=$(sysctl -n hw.memsize 2>/dev/null || echo 0)
    ram_gb=$(echo "$ram_bytes / 1073741824" | bc 2>/dev/null || echo 0)
  elif [[ "$OSTYPE" == "linux"* ]]; then
    ram_gb=$(awk '/MemTotal/ {printf "%.0f", $2/1048576}' /proc/meminfo 2>/dev/null || echo 0)
  fi
  if [ "${ram_gb:-0}" -ge "$MIN_RAM_GB" ]; then
    set_pass "ram" "${ram_gb} GB"
  else
    set_warn "ram" "${ram_gb} GB" "Di bawah minimum (${MIN_RAM_GB} GB). Beberapa stage mungkin lambat."
  fi
}

check_disk() {
  local disk_gb=0
  if [[ "$OSTYPE" == "darwin"* ]]; then
    disk_gb=$(df -g . 2>/dev/null | awk 'NR==2 {print $4}' || echo 0)
  elif [[ "$OSTYPE" == "linux"* ]]; then
    disk_gb=$(df -BG . 2>/dev/null | awk 'NR==2 {gsub("G",""); print $4}' || echo 0)
  fi
  if [ "${disk_gb:-0}" -ge "$MIN_DISK_GB" ]; then
    set_pass "disk" "${disk_gb} GB free"
  else
    set_warn "disk" "${disk_gb} GB free" "Di bawah minimum (${MIN_DISK_GB} GB). Hapus file tidak penting."
  fi
}

# ─── Output: Human-readable ──────────────────────────────────────────────────

print_row() {
  local label="$1" status="$2" ver="$3" msg="$4"
  local padded
  padded=$(printf "%-12s" "$label")
  case "$status" in
    pass) echo -e "  ${GREEN}✅${NC} ${padded} → ${GREEN}${ver}${NC}" ;;
    warn)
      echo -e "  ${YELLOW}⚠️ ${NC} ${padded} → ${YELLOW}${ver}${NC}"
      echo -e "          ${YELLOW}└─ ${msg}${NC}"
      ;;
    fail) echo -e "  ${RED}❌${NC} ${padded} → ${RED}${msg}${NC}" ;;
  esac
}

print_human() {
  echo ""
  echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}║    Be A DevOps Employee — Pre-flight Checker v1.0   ║${NC}"
  echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
  echo ""
  print_row "Docker"    "$r_docker_status"    "$r_docker_version"    "$r_docker_msg"
  print_row "KinD"      "$r_kind_status"      "$r_kind_version"      "$r_kind_msg"
  print_row "kubectl"   "$r_kubectl_status"   "$r_kubectl_version"   "$r_kubectl_msg"
  print_row "Helm"      "$r_helm_status"      "$r_helm_version"      "$r_helm_msg"
  print_row "Terraform" "$r_terraform_status" "$r_terraform_version" "$r_terraform_msg"
  print_row "Git"       "$r_git_status"       "$r_git_version"       "$r_git_msg"
  print_row "RAM"       "$r_ram_status"       "$r_ram_version"       "$r_ram_msg"
  print_row "Disk"      "$r_disk_status"      "$r_disk_version"      "$r_disk_msg"
  echo ""
  echo -e "  ${BLUE}────────────────────────────────────────${NC}"
  echo -e "  Passed: ${GREEN}${PASS_COUNT}${NC}  |  Warnings: ${YELLOW}${WARN_COUNT}${NC}  |  Failed: ${RED}${FAIL_COUNT}${NC}"
  echo ""
  if [ "$FAIL_COUNT" -gt 0 ]; then
    echo -e "  ${RED}${BOLD}❌ Environment belum siap. Install tool yang gagal dulu.${NC}"
    echo -e "  ${BLUE}   Panduan: onboarding/<OS>/README.md${NC}"
  elif [ "$WARN_COUNT" -gt 0 ]; then
    echo -e "  ${YELLOW}${BOLD}⚠️  Hampir siap. Periksa peringatan di atas.${NC}"
    echo -e "  ${GREEN}   Bisa lanjut ke 01-ci-jenkins/ jika tidak ada blocker.${NC}"
  else
    echo -e "  ${GREEN}${BOLD}🎉 Environment siap! Lanjutkan ke: 01-ci-jenkins/${NC}"
  fi
  echo ""
}

# ─── Output: JSON ────────────────────────────────────────────────────────────

json_entry() {
  local tool="$1" status="$2" ver="$3" msg="$4" comma="$5"
  # Escape quotes
  ver="${ver//\"/\\\"}"
  msg="${msg//\"/\\\"}"
  printf '    "%s": {"status": "%s", "version": "%s", "message": "%s"}%s\n' \
    "$tool" "$status" "$ver" "$msg" "$comma"
}

print_json() {
  local ready="true"
  [ "$FAIL_COUNT" -gt 0 ] && ready="false"
  echo "{"
  echo "  \"schemaVersion\": \"1.0\","
  echo "  \"timestamp\": \"$(date -u '+%Y-%m-%dT%H:%M:%SZ')\","
  echo "  \"summary\": {\"pass\": ${PASS_COUNT}, \"warn\": ${WARN_COUNT}, \"fail\": ${FAIL_COUNT}, \"ready\": ${ready}},"
  echo "  \"checks\": {"
  json_entry "docker"    "$r_docker_status"    "$r_docker_version"    "$r_docker_msg"    ","
  json_entry "kind"      "$r_kind_status"      "$r_kind_version"      "$r_kind_msg"      ","
  json_entry "kubectl"   "$r_kubectl_status"   "$r_kubectl_version"   "$r_kubectl_msg"   ","
  json_entry "helm"      "$r_helm_status"      "$r_helm_version"      "$r_helm_msg"      ","
  json_entry "terraform" "$r_terraform_status" "$r_terraform_version" "$r_terraform_msg" ","
  json_entry "git"       "$r_git_status"       "$r_git_version"       "$r_git_msg"       ","
  json_entry "ram"       "$r_ram_status"       "$r_ram_version"       "$r_ram_msg"       ","
  json_entry "disk"      "$r_disk_status"      "$r_disk_version"      "$r_disk_msg"      ""
  echo "  }"
  echo "}"
}

# ─── Main ────────────────────────────────────────────────────────────────────

main() {
  for arg in "$@"; do
    case "$arg" in
      --json)   JSON_OUTPUT=true ;;
      --help|-h)
        echo "Usage: $0 [--json] [--help]"
        echo "  --json   Output JSON (untuk web checker)"
        exit 0
        ;;
    esac
  done

  check_docker
  check_kind
  check_kubectl
  check_helm
  check_terraform
  check_git
  check_ram
  check_disk

  if [ "$JSON_OUTPUT" = true ]; then
    print_json
  else
    print_human
  fi

  [ "$FAIL_COUNT" -eq 0 ]
}

main "$@"
