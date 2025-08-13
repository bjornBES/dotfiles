#!/bin/bash
set -e

# Location to store your config repo locally
CONFIG_DIR="$HOME/Desktop/config"
REPO_URL="https://github.com/bjornBES/dotfiles.git"

# Clone repo if not already cloned
if [ ! -d "$CONFIG_DIR/.git" ]; then
    mkdir -p "$CONFIG_DIR"
    git init "$CONFIG_DIR"
    git -C "$CONFIG_DIR" remote add origin "$REPO_URL"
    git -C "$CONFIG_DIR" fetch origin
    git -C "$CONFIG_DIR" checkout -t origin/main || git -C "$CONFIG_DIR" checkout -b main
else
    echo "[*] Repo already exists, pulling latest changes..."
    git -C "$CONFIG_DIR" pull origin main
fi

echo "[*] Restoring configs..."

# OBS Studio
cp -r "$CONFIG_DIR/obs-studio/basic" "$HOME/.var/app/com.obsproject.Studio/config/obs-studio/" || true

# Kdenlive
cp "$CONFIG_DIR/kdenlive/kdenlive-flatpakrc" "$HOME/.var/app/org.kde.kdenlive/config/" || true
cp "$CONFIG_DIR/kdenlive/data/kxmlgui5/kdenliveui.rc" "$HOME/.var/app/org.kde.kdenlive/data/kxmlgui5/kdenlive/" || true
cp -r "$CONFIG_DIR/kdenlive/cache/"* "$HOME/.var/app/org.kde.kdenlive/cache/kdenlive/" || true
cp -r "$CONFIG_DIR/kdenlive/data/"* "$HOME/.var/app/org.kde.kdenlive/data/kdenlive/" || true

# Cinnamon configs
cp -r "$CONFIG_DIR/cinnamon/"* "$HOME/.config/cinnamon/" || true

# Input-remapper
cp -r "$CONFIG_DIR/input-remapper-2/"* "$HOME/.config/input-remapper-2/" || true

# MuseScore
cp -r "$CONFIG_DIR/MuseScore/"* "$HOME/.config/MuseScore/" || true

# Neovim
cp -r "$CONFIG_DIR/nvim/"* "$HOME/.config/nvim/" || true

# Ulauncher
cp -r "$CONFIG_DIR/ulauncher/"* "$HOME/.config/ulauncher/" || true

# Cinnamon dconf restore
if [ -f "$CONFIG_DIR/org/cinnamon/cinnamon-backup.conf" ]; then
    dconf load /org/cinnamon/ < "$CONFIG_DIR/org/cinnamon/cinnamon-backup.conf"
fi

# Cinnamon desklets/applets
cp -r "$CONFIG_DIR/share/cinnamon/desklets/"* "$HOME/.local/share/cinnamon/desklets/" || true
cp -r "$CONFIG_DIR/share/cinnamon/applets/"* "$HOME/.local/share/cinnamon/applets/" || true

# Fix ownership to current user
chown -R "$USER":"$USER" "$HOME/.config"
chown -R "$USER":"$USER" "$HOME/.var/app"

echo "[✔] Configs restored successfully!"
