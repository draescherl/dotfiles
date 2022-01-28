#! /bin/sh

# Run script as root
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

# Update and upgrade
apt update
apt dist-upgrade -y
apt autoremove -y

# Create temporary folder for the assets
mkdir ./tmp

# Utilities
apt install -y git ca-certificates curl gnupg lsb-release
git config --global user.name "Lucas DRAESCHER"
git config --global user.email "lucas.draescher@gmail.com"

# Install and configure Zsh
apt install -y zsh
#TODO: add configuration

# Build tools
apt install -y build-essential

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io
groupadd docker
usermod -aG docker $USER
newgrp docker
systemctl enable docker.service
systemctl enable containerd.service

# Docker compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#TODO: look into completions

# Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.zshrc
nvm install node

# Python
apt install -y python3-virtualenv

# Teams
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
apt update
apt install -y teams

# Gedit
apt install -y gedit

# VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
apt install apt-transport-https
apt update
apt install -y code

# Discord
wget -O ./tmp/discord.deb https://discord.com/api/download?platform=linux&format=deb
apt install -y ./tmp/discord.deb

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
apt update
apt install -y spotify-client

# Virtualisation stuff
# JetBrains toolbox
# Obsidian
# Postman

# Remove bash artifacts
rm -f ~/.bash_history
rm -f ~/.profile

# Remove temporary directory
rm -rf ./tmp
