#!/bin/bash
# LARBS-style Wayland+dwl bootstrap for Arch Linux
# Supports: laptop, desktop, vm (auto-detected)
# Usage: curl -L https://raw.githubusercontent.com/knechtling/autodeploy/main/bootstrap.sh | bash

set -e

# Configuration
REPO_USER="${REPO_USER:-knechtling}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/${REPO_USER}/dotfiles}"
AUTODEPLOY_REPO="${AUTODEPLOY_REPO:-https://github.com/${REPO_USER}/autodeploy}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-wayland}"
AUTODEPLOY_BRANCH="${AUTODEPLOY_BRANCH:-master}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging
LOGFILE="/tmp/larbs-bootstrap-$(date +%Y%m%d-%H%M%S).log"

log() { echo -e "${GREEN}==>${NC} $1" | tee -a "$LOGFILE"; }
error() {
  echo -e "${RED}ERROR:${NC} $1" | tee -a "$LOGFILE"
  exit 1
}
warn() { echo -e "${YELLOW}WARNING:${NC} $1" | tee -a "$LOGFILE"; }
info() { echo -e "${BLUE}INFO:${NC} $1" | tee -a "$LOGFILE"; }
success() { echo -e "${CYAN}✓${NC} $1" | tee -a "$LOGFILE"; }

print_banner() {
  cat <<"EOF"
╔═══════════════════════════════════════════════════╗
║   LARBS-STYLE WAYLAND+DWL BOOTSTRAP              ║
║   Minimal • Automated • Host-Aware              ║
╚═══════════════════════════════════════════════════╝
EOF
}

detect_hosttype() {
  # Check for battery (laptop)
  if [ -e /sys/class/power_supply/BAT0 ] || [ -e /sys/class/power_supply/BAT1 ]; then
    echo "laptop"
    return
  fi

  # Check for VM
  if [ -f /sys/class/dmi/id/product_name ]; then
    product=$(cat /sys/class/dmi/id/product_name 2>/dev/null)
    case "$product" in
    *QEMU* | *KVM* | *VirtualBox* | *VMware* | *"Virtual Machine"* | *HVM*domU*)
      echo "vm"
      return
      ;;
    esac
  fi

  if [ -f /sys/class/dmi/id/sys_vendor ]; then
    vendor=$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null)
    case "$vendor" in
    *QEMU* | *KVM* | *VirtualBox* | *VMware* | *"Microsoft Corporation"*)
      echo "vm"
      return
      ;;
    esac
  fi

  if grep -q "^flags.*hypervisor" /proc/cpuinfo 2>/dev/null; then
    echo "vm"
    return
  fi

  # Default to desktop
  echo "desktop"
}

check_distro() {
  [ -f /etc/arch-release ] || error "This script requires Arch Linux"
  success "Detected Arch Linux"
}

check_root() {
  [ "$EUID" -ne 0 ] || error "Do not run as root. Run as your regular user."
}

install_dependencies() {
  log "Installing dependencies..."

  sudo -v || error "This script requires sudo access"

  sudo pacman -Sy --noconfirm || error "Failed to sync package database"

  local deps=(ansible python git stow base-devel)
  info "Installing: ${deps[*]}"
  sudo pacman -S --needed --noconfirm "${deps[@]}" 2>&1 | tee -a "$LOGFILE" || error "Failed to install dependencies"

  success "Dependencies installed"
}

install_ansible_galaxy() {
  log "Installing Ansible Galaxy collections..."
  ansible-galaxy collection install kewlfft.aur 2>&1 | tee -a "$LOGFILE" || warn "Failed to install AUR collection"
  success "Ansible Galaxy collections installed"
}

clone_repos() {
  log "Cloning repositories..."

  # Clone dotfiles
  if [ -d "$HOME/dotfiles/.git" ]; then
    info "Dotfiles exist, pulling latest..."
    cd "$HOME/dotfiles" && git checkout "$DOTFILES_BRANCH" && git pull 2>&1 | tee -a "$LOGFILE"
  else
    info "Cloning dotfiles (branch: $DOTFILES_BRANCH)..."
    git clone -b "$DOTFILES_BRANCH" "$DOTFILES_REPO" "$HOME/dotfiles" 2>&1 | tee -a "$LOGFILE" || error "Failed to clone dotfiles"
  fi

  # Clone autodeploy
  mkdir -p "$HOME/projects"
  if [ -d "$HOME/projects/autodeploy/.git" ]; then
    info "Autodeploy exists, pulling latest..."
    cd "$HOME/projects/autodeploy" && git checkout "$AUTODEPLOY_BRANCH" && git pull 2>&1 | tee -a "$LOGFILE"
  else
    info "Cloning autodeploy (branch: $AUTODEPLOY_BRANCH)..."
    git clone -b "$AUTODEPLOY_BRANCH" "$AUTODEPLOY_REPO" "$HOME/projects/autodeploy" 2>&1 | tee -a "$LOGFILE" || error "Failed to clone autodeploy"
  fi

  success "Repositories ready"
}

run_ansible() {
  log "Running Ansible deployment..."

  cd "$HOME/projects/autodeploy"

  HOSTTYPE=$(detect_hosttype)
  info "Detected host type: $HOSTTYPE"

  local playbook="${HOSTTYPE}.yml"
  [ -f "$playbook" ] || playbook="desktop.yml"

  info "Running playbook: $playbook"
  ansible-playbook "$playbook" \
    -i inventory \
    --ask-become-pass \
    -e "user=$USER" \
    -e "hosttype=$HOSTTYPE" \
    2>&1 | tee -a "$LOGFILE" || error "Ansible failed. Check $LOGFILE"

  success "Ansible deployment complete"
}

finalize() {
  log "Finalizing setup..."

  # Ensure scripts are executable
  chmod +x "$HOME/.local/bin/detect-hosttype" 2>/dev/null || true
  chmod +x "$HOME/.local/bin/dwl-session" 2>/dev/null || true

  success "Setup finalized"
}

main() {
  print_banner

  log "Starting bootstrap at $(date)"
  log "Logfile: $LOGFILE"

  check_distro
  check_root

  HOSTTYPE=$(detect_hosttype)
  info "Host type: $HOSTTYPE"

  install_dependencies
  install_ansible_galaxy
  clone_repos
  run_ansible
  finalize

  echo ""
  log "Installation complete! 🚀"
  echo ""
  info "Next steps:"
  echo "  1. Reboot: sudo reboot"
  echo "  2. emptty will start automatically"
  echo "  3. Select 'dwl' and login"
  echo ""
  info "Documentation:"
  echo "  - README: $HOME/dotfiles/README.md"
  echo "  - Keybindings: Press Right-Ctrl in dwl"
  echo "  - Logs: $LOGFILE"
  echo ""
  success "Enjoy your minimal Wayland setup!"
}

main "$@"
