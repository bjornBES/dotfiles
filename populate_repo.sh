#!/bin/bash
set -e

NEW_DIR="/media/bjornbes/c48e5f98-be37-4904-8f9c-9b3bfb6354c5"
NEW_DIR="$HOME/Desktop/config"

mkdir -p "$NEW_DIR"
if [ "$#" -ge 1 ] && [ "$1" = "git" ]; then
    if [ -d "$NEW_DIR/.git" ]; then
        echo "pull"
    else
        rm -r $NEW_DIR
        mkdir -p "$NEW_DIR"
        git clone https://github.com/bjornBES/dotfiles.git $NEW_DIR
    fi
fi


echo "[*] Pulling configs from OLD DISK..."

# OBS Studio
mkdir -p "$NEW_DIR/obs-studio"
cp -r "$NEW_DIR/home/bjornbes/.var/app/com.obsproject.Studio/config/obs-studio/basic" "$NEW_DIR/obs-studio/" || true

# Kdenlive
mkdir -p "$NEW_DIR/kdenlive"

mkdir -p "$NEW_DIR/kdenlive/config"
cp "$NEW_DIR/home/bjornbes/.var/app/org.kde.kdenlive/config/kdenlive-flatpakrc" "$NEW_DIR/kdenlive/" || true

mkdir -p "$NEW_DIR/kdenlive/data/kxmlgui5"
cp "$NEW_DIR/home/bjornbes/.var/app/org.kde.kdenlive/data/kxmlgui5/kdenlive/kdenliveui.rc" "$NEW_DIR/kdenlive/" || true

mkdir -p "$NEW_DIR/kdenlive/cache"
cp -r "$NEW_DIR/home/bjornbes/.var/app/org.kde.kdenlive/cache/kdenlive/"* "$NEW_DIR/kdenlive/cache/" || true

mkdir -p "$NEW_DIR/kdenlive/data"
cp -r "$NEW_DIR/home/bjornbes/.var/app/org.kde.kdenlive/data/kdenlive/"* "$NEW_DIR/kdenlive/data/" || true

# Cinnamon configs
mkdir -p "$NEW_DIR/cinnamon"
cp -r "$NEW_DIR/home/bjornbes/.config/cinnamon/"* "$NEW_DIR/cinnamon/" || true

# Input-remapper
mkdir -p "$NEW_DIR/input-remapper-2"
cp -r "$NEW_DIR/home/bjornbes/.config/input-remapper-2/"* "$NEW_DIR/input-remapper-2/" || true

# MuseScore
mkdir -p "$NEW_DIR/MuseScore"
cp -r "$NEW_DIR/home/bjornbes/.config/MuseScore/"* "$NEW_DIR/MuseScore/" || true

# Neovim
mkdir -p "$NEW_DIR/nvim"
cp -r "$NEW_DIR/home/bjornbes/.config/nvim/"* "$NEW_DIR/nvim/" || true

# Ulauncher (current system)
mkdir -p "$NEW_DIR/ulauncher"
cp -r "$HOME/.config/ulauncher/"* "$NEW_DIR/ulauncher/" || true

# Cinnamon org config (dconf)
mkdir -p "$NEW_DIR/org/cinnamon"
dconf dump /org/cinnamon/ > "$NEW_DIR/org/cinnamon/cinnamon-backup.conf"

# Cinnamon desklets/applets (old disk)
mkdir -p "$NEW_DIR/share/cinnamon/desklets"
mkdir -p "$NEW_DIR/share/cinnamon/applets"
cp -r "$NEW_DIR/usr/share/cinnamon/desklets/"* "$NEW_DIR/share/cinnamon/desklets/" || true
cp -r "$NEW_DIR/home/bjornbes/.local/share/cinnamon/desklets/"* "$NEW_DIR/share/cinnamon/desklets/" || true
cp -r "$NEW_DIR/usr/share/cinnamon/applets/"* "$NEW_DIR/share/cinnamon/applets/" || true
cp -r "$NEW_DIR/home/bjornbes/.local/share/cinnamon/applets/"* "$NEW_DIR/share/cinnamon/applets/" || true

# Fix ownership to current user
chown -R "$USER":"$USER" "$NEW_DIR"

echo "[✔] Configs copied into '$NEW_DIR'"

if [ "$#" -ge 1 ] && [ "$1" = "git" ]; then
    echo "[*] Committing configs to dotfiles repo..."
    cd "$NEW_DIR"

    if [ -d "$NEW_DIR/.git" ]; then
        echo "git add"
        git add -A -- $NEW_DIR
        echo "git commit"
        git commit -m "Update configs on $(date +%F_%T)" || echo "No changes to commit."
        echo "git push"
        git push
        echo "[✔] Changes pushed to GitHub."
    fi
else
    echo "Run './populate_repo.sh git' to also commit changes to GitHub."
fi