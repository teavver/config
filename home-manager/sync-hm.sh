#!/usr/bin/env bash
set -e

SRC="$HOME/.config/home-manager"
DEST="$HOME/config/home-manager"

[[ ! -d "$SRC" ]] && echo "Error: $SRC not found" && exit 1

cp -f "$SRC/base-pkgs.nix" "$DEST/" 2>/dev/null || true
cp -f "$SRC/home.nix" "$DEST/archon/" 2>/dev/null || true

if [[ -d "$SRC/modules" ]]; then
    mkdir -p "$DEST/modules"
    cp -f "$SRC/modules/"* "$DEST/modules/" 2>/dev/null || true
fi

if [[ -d "$SRC/dotfiles" ]]; then
    mkdir -p "$DEST/dotfiles"
    for item in "$SRC/dotfiles/"*; do
        [[ -e "$item" ]] || continue
        cp -rf "$item" "$DEST/dotfiles/"
    done
fi

echo "ok"
