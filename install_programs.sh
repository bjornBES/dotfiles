#!/bin/bash

set -e  # Exit if any command fails

echo "[*] Updating package lists..."
sudo apt update && sudo apt upgrade -y


# -------------------------------------------------------------------
# 1. Install core packages
# -------------------------------------------------------------------
echo "[*] Installing core dev tools..."
sudo apt install -y \
    git make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev cmake \
    libedit-dev libncurses5-dev software-properties-common \
    python3 python3-pip


# -------------------------------------------------------------------
# 2. Spotify, OBS, Discord
# -------------------------------------------------------------------
echo "[*] Adding Spotify repo..."
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

echo "[*] Installing OBS and Discord (APT versions)..."
# OBS from apt (official PPA)
sudo add-apt-repository -y ppa:obsproject/obs-studio
# Discord from deb
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"

sudo apt update
sudo apt install -y spotify-client obs-studio ./discord.deb
rm discord.deb

# -------------------------------------------------------------------
# 3. Pyenv setup
# -------------------------------------------------------------------
echo "[*] Installing pyenv..."
curl -fsSL https://pyenv.run | bash

# Add to shell profile
if ! grep -q 'PYENV_ROOT' ~/.bashrc; then
    cat <<'EOF' >> ~/.bashrc

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
EOF
fi

# Apply changes now
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

exec "$SHELL"

pyenv install 3.14-dev
pyenv global 3.14-dev

echo "[*] Installing Python packages..."
pip install --upgrade pip
pip install Pint simpleeval parsedatetime pytz babel

# -------------------------------------------------------------------
# 4. Input-remapper
# -------------------------------------------------------------------
echo "[*] Installing input-remapper..."
sudo apt install -y input-remapperNEW_DIR

# -------------------------------------------------------------------
# 5. Blender
# -------------------------------------------------------------------
echo "[*] Installing Blender..."
sudo apt install -y blender


# -------------------------------------------------------------------
# 6. Ulauncher
# -------------------------------------------------------------------
echo "[*] Installing Ulauncher..."
sudo add-apt-repository universe -y
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt update
sudo apt install -y ulauncher
systemctl --user enable --now ulauncher

# -------------------------------------------------------------------
# 7. Visual Studio Code
# -------------------------------------------------------------------
echo "[*] Installing VS Code..."
wget -O vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
sudo apt install -y ./vscode.deb
rm vscode.deb

# -------------------------------------------------------------------
# 8. Flatpak apps
# -------------------------------------------------------------------
echo "[*] Installing Flatpak and apps..."
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo flatpak install -y --system flathub com.github.alainm23.sober
sudo flatpak install -y --system flathub org.kde.kdenlive

echo "[✔] All done!"

