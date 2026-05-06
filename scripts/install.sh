#!/usr/bin/env bash
set -e

# Sota VLESS Updater — One-line installer
# Usage: curl -L https://raw.githubusercontent.com/YOUR_USERNAME/sota-vless-updater/main/scripts/install.sh | bash

REPO="AlexRuBot/sota_script"
BINARY_NAME="sota_vless_updater"

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
else
    echo "❌ Unsupported OS: $OSTYPE"
    echo "    Supported: macOS, Linux"
    exit 1
fi

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
elif [[ "$ARCH" == "x86_64" ]] || [[ "$ARCH" == "amd64" ]]; then
    ARCH="amd64"
else
    echo "❌ Unsupported architecture: $ARCH"
    echo "    Supported: arm64, amd64 (x86_64)"
    exit 1
fi

# Construct download URL
ASSET="${BINARY_NAME}_${OS}_${ARCH}"
if [[ "$OS" == "windows" ]]; then
    ASSET="${ASSET}.exe"
fi

# Try to fetch latest release tag from GitHub API
LATEST_TAG=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [[ -z "$LATEST_TAG" ]] || [[ "$LATEST_TAG" == "null" ]]; then
    echo "⚠ Could not detect latest release. Using fallback version..."
    LATEST_TAG="v1.0.0"
fi

DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_TAG}/${ASSET}"

echo ""
echo "=============================================="
echo "Sota VLESS Updater — Installer"
echo "=============================================="
echo ""
echo "OS:        $OS"
echo "Arch:      $ARCH"
echo "Version:   $LATEST_TAG"
echo "Download:  $DOWNLOAD_URL"
echo ""

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Download binary
echo "[1/3] Downloading binary..."
if command -v curl &> /dev/null; then
    HTTP_CODE=$(curl -L -o "$TMP_DIR/$ASSET" -w "%{http_code}" "$DOWNLOAD_URL" 2>/dev/null)
elif command -v wget &> /dev/null; then
    wget -q -O "$TMP_DIR/$ASSET" "$DOWNLOAD_URL" 2>/dev/null
    HTTP_CODE="200"
else
    echo "❌ curl or wget is required but not installed."
    exit 1
fi

if [[ "$HTTP_CODE" != "200" ]] && [[ "$HTTP_CODE" != "" ]]; then
    echo "❌ Download failed (HTTP $HTTP_CODE)"
    echo "    Asset not found: $ASSET"
    echo ""
    echo "Possible reasons:"
    echo "  • No release exists for this OS/arch combination"
    echo "  • The release version ($LATEST_TAG) doesn't have binaries yet"
    exit 1
fi

# Make executable
chmod +x "$TMP_DIR/$ASSET"

# Move to a permanent location
INSTALL_DIR="$HOME/.local/bin"
if [[ ! -d "$INSTALL_DIR" ]]; then
    mkdir -p "$INSTALL_DIR"
fi

INSTALL_PATH="$INSTALL_DIR/$BINARY_NAME"
mv "$TMP_DIR/$ASSET" "$INSTALL_PATH"

echo "[2/3] Installed to: $INSTALL_PATH"

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "⚠ Warning: $INSTALL_DIR is not in your PATH."
    echo "    Add this to your ~/.bashrc or ~/.zshrc:"
    echo "        export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "    Or run the binary directly:"
    echo "        $INSTALL_PATH"
fi

# Run the updater
echo "[3/3] Starting updater..."
echo ""
# Перенаправляем stdin с реального терминала, чтобы программа
# могла интерактивно запросить Access Key даже при запуске через curl | bash
"$INSTALL_PATH" < /dev/tty
