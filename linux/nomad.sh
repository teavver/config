#!/bin/bash

# ===
# n0mad installation script
# Intended to use on Debian 12 bookworm
# Supported flags: "--no-i3"
# ===

if [ "$EUID" -ne 0 ]
  then echo "[n0mad] - must run as root, exiting"
  exit
fi

INSTALL_i3=true
USER_HOME=$(eval echo ~${SUDO_USER})
DOWNLOADS_DIR="$USER_HOME/Downloads"
APT_PKGS=(
    "git"
    "htop"
    "gh"
    "tmux"
    "curl"
    "xclip"
    "google-chrome-stable"
    "lxappearance"
    "vim-gtk3"
    "libatk-bridge2.0-0"
)
DEB_PKGS_URLS=(
    "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
)
CONFIG_URL="https://raw.githubusercontent.com/teavver/config/main"

DOTFILES=( # conf_file:dest_dir
    ".bashrc:$USER_HOME/.bashrc"
    ".bash_profile:$USER_HOME/.bash_profile"
    ".tmux.conf:$USER_HOME/.tmux.conf"
    ".vimrc:$USER_HOME/.vimrc"
    "git/.gitconfig:$USER_HOME/.gitconfig"
    "git/.gitignore_global:$USER_HOME/.gitignore_global"
    "linux/i3/config:$USER_HOME/.config/i3/config"
    "linux/.Xresources:$USER_HOME/.Xresources"
    "linux/settings.ini:/etc/gtk-3.0/settings.ini"
)

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --no-i3) INSTALL_I3=false ;;
        *) echo "[n0mad] - unsupported flag: $1. exiting"; exit 1 ;;
    esac
    shift
done

echo "[n0mad] - starting..."
apt-get update -y -q=2

# Download & setup i3
if $INSTALL_i3; then
    echo "deb http://deb.debian.org/debian testing main" | sudo tee -a /etc/apt/sources.list
    apt update -y -q=2
    apt install i3 -y -q=2
    echo "[n0mad] - i3 installed"
fi

# Chrome
curl -fSsL -s https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list
apt-get update -y -q=2
echo "[n0mad] - chrome config OK"

# Download all core packages
for PKG in "${APT_PKGS[@]}"; do
    apt-get install "$PKG" -y -q=2
done
echo "[n0mad] - core pkgs installed"

# Download & install .deb pkgs
mkdir -p "$DOWNLOADS_DIR"
sudo apt --fix-broken install -y -q=2
for DEB_PKG_URL in "${DEB_PKGS_URLS[@]}"; do
    DEB_PKG_FILE="$DOWNLOADS_DIR/deb_pkg.deb"
    curl -L -s -o "$DEB_PKG_FILE" "$DEB_PKG_URL"
    sudo dpkg -i "$DEB_PKG_FILE"
    rm "$DEB_PKG_FILE"
done
echo "[n0mad] - .deb pkgs installed"

# Misc stuff
timedatectl set-timezone Europe/Warsaw
sudo apt autoremove -y -q=2
echo "[n0mad] - misc OK"

# Install & mv dotfiles
for CONFIG in "${DOTFILES[@]}"; do
    FILE="${CONFIG%%:*}"
    DEST="${CONFIG##*:}"
    URL="${CONFIG_URL}/${FILE}"
    
    curl -L -o "$DOWNLOADS_DIR/tmpfile" "$URL"
    if [ $? -ne 0 ]; then
        echo "[n0mad] failed to download $URL"
        continue
    fi

    DEST_DIR="$(dirname "$DEST")"
    mkdir -p "$DEST_DIR"
    if [ $? -ne 0 ]; then
        echo "[n0mad] failed to create dir $DEST_DIR"
        continue
    fi

    mv "$DOWNLOADS_DIR/tmpfile" "$DEST"
    if [ $? -ne 0 ]; then
        echo "[n0mad] failed to move file to $DEST"
        continue
    fi
done
echo "[n0mad] - dotfiles installed"
echo "[n0mad] - done"