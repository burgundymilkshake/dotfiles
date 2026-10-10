#!/usr/bin/env bash
# Bootstrap this dotfiles repo on a fresh Linux or macOS machine.
#
#   git clone <your-remote> ~/dotfiles
#   cd ~/dotfiles && ./install.sh
#
# Installs GNU Stow if missing, then symlinks every package into $HOME.
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow not found — installing..."
  if [[ "$(uname)" == "Darwin" ]]; then
    command -v brew >/dev/null 2>&1 || {
      echo "Homebrew is required on macOS: https://brew.sh" >&2; exit 1; }
    brew install stow
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -qq && sudo apt-get install -y stow
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y stow
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm stow
  else
    echo "No supported package manager found; install stow manually." >&2
    exit 1
  fi
fi

# Stow every package directory (anything that isn't a hidden dir).
for pkg in */; do
  pkg="${pkg%/}"
  echo "stow: $pkg"
  stow --restow --target="$HOME" "$pkg"
done

echo "Done. Open a new terminal to pick up your environment."
