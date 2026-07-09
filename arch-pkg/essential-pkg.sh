#!/bin/bash
# Generate essential package list (dev tools + system core) from full pkglist.txt
# Usage: ./essential-pkg.sh [--install] [--aur-helper paru]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FULL_LIST="$SCRIPT_DIR/pkglist.txt"
OUTPUT="$SCRIPT_DIR/pkglist-essential.txt"

# ── Core system essentials ──
SYSTEM_CORE=(
  base base-devel linux linux-firmware linux-headers
  amd-ucode sudo efibootmgr btrfs-progs exfatprogs ntfs-3g
  networkmanager iwd pipewire pipewire-pulse pipewire-alsa
  wireplumber polkit-gnome gnome-keyring
  man-db less plocate stow
)

# ── Development tools ──
DEV_TOOLS=(
  git github-cli
  neovim
  zsh bash-completion
  tmux zellij starship
  paru yay
  bat eza fd ripgrep fzf lazygit lazydocker
  jq yq
  mise
  npm
  rust
  clang llvm
  python python-pip python-virtualenv python-poetry-core python312
  php composer php-gd php-pgsql php-sodium php-sqlite
  jdk8-openjdk
  docker docker-compose docker-buildx
  bear strace
  tree-sitter-cli
  unzip wget
  zoxide
  luarocks
  ruby
  dotnet-runtime-9.0
  libyaml postgresql-libs
  openssh tailscale
  qemu-full libvirt virt-manager virt-viewer
)

# ── Combine and check against full list ──
ESSENTIAL_KEYS=("${SYSTEM_CORE[@]}" "${DEV_TOOLS[@]}")

# Build associative array for lookup
declare -A ESSENTIAL_MAP
for pkg in "${ESSENTIAL_KEYS[@]}"; do
  ESSENTIAL_MAP["$pkg"]=1
done

echo ":: Generating essential package list..."

while IFS= read -r pkg; do
  [[ -z "$pkg" ]] && continue
  if [[ -n "${ESSENTIAL_MAP[$pkg]:-}" ]]; then
    echo "$pkg"
  fi
done < "$FULL_LIST" > "$OUTPUT"

echo ":: Written to $OUTPUT ($(wc -l < "$OUTPUT") packages)"

# ── Optional: install ──
if [[ "${1:-}" == "--install" ]]; then
  AUR_HELPER="${2:-paru}"
  if ! command -v "$AUR_HELPER" &>/dev/null; then
    echo ":: Error: $AUR_HELPER not found" >&2
    exit 1
  fi
  echo ":: Installing essential packages..."
  "$AUR_HELPER" -S --needed --noconfirm - < "$OUTPUT"
fi
