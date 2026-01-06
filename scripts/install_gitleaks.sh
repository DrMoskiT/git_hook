#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
BIN_DIR="$REPO_ROOT/.githooks/bin"
mkdir -p "$BIN_DIR"

need() { command -v "$1" >/dev/null 2>&1 || { echo "[install] Missing dependency: $1"; exit 1; }; }
need curl
need tar
need sed
need uname

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  linux)   os_name="linux" ;;
  darwin)  os_name="darwin" ;;
  msys*|mingw*|cygwin*) os_name="windows" ;;   # Git Bash
  *) echo "[install] Unsupported OS: $OS"; exit 1 ;;
esac

case "$ARCH" in
  x86_64|amd64) arch_name="x64" ;;
  aarch64|arm64) arch_name="arm64" ;;
  *) echo "[install] Unsupported ARCH: $ARCH"; exit 1 ;;
esac

# Беремо latest release tag через GitHub API
tag="$(curl -fsSL https://api.github.com/repos/gitleaks/gitleaks/releases/latest | \
  sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n1)"

if [[ -z "${tag}" ]]; then
  echo "[install] Failed to detect latest gitleaks tag."
  exit 1
fi

ver="${tag#v}"
asset="gitleaks_${ver}_${os_name}_${arch_name}.tar.gz"
url="https://github.com/gitleaks/gitleaks/releases/download/${tag}/${asset}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "[install] tag=${tag}"
echo "[install] downloading ${asset}"
curl -fL "$url" -o "$tmp/$asset"

echo "[install] extracting..."
tar -xzf "$tmp/$asset" -C "$tmp"

# В архіві зазвичай "gitleaks" або "gitleaks.exe"
if [[ -f "$tmp/gitleaks.exe" ]]; then
  mv -f "$tmp/gitleaks.exe" "$BIN_DIR/gitleaks"
elif [[ -f "$tmp/gitleaks" ]]; then
  mv -f "$tmp/gitleaks" "$BIN_DIR/gitleaks"
else
  echo "[install] Unexpected archive content:"
  ls -la "$tmp"
  exit 1
fi

chmod +x "$BIN_DIR/gitleaks"
echo "[install] installed: $BIN_DIR/gitleaks"
"$BIN_DIR/gitleaks" version || true
