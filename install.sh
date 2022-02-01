#! /bin/sh



#  ----------------------------------------------------------------------
# |                          General stuff                               |
#  ----------------------------------------------------------------------

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



#  ----------------------------------------------------------------------
# |                     Programming languages                            |
#  ----------------------------------------------------------------------

# C/C++
apt install -y build-essential

# Scala
apt install apt-transport-https -yqq
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | -H gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import
chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg
apt update
apt install sbt

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# NodeJS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.zshrc
nvm install node

# Python
apt install -y python3-virtualenv



#  ----------------------------------------------------------------------
# |                          Docker stuff                                |
#  ----------------------------------------------------------------------

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



#  ----------------------------------------------------------------------
# |                          Code editors                                |
#  ----------------------------------------------------------------------

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

# JetBrains toolbox
wget -O /home/lucas/Downloads/jetbrains-toolbox.tar.gz https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.22.10970.tar.gz
tar -xf /home/lucas/Downloads/jetbrains-toolbox.tar.gz



#  ----------------------------------------------------------------------
# |                       Virtualization stuff                           |
#  ----------------------------------------------------------------------

apt install -y cpu-checker
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
adduser $USER libvirt
adduser $USER kvm
systemctl enable --now libvirtd
apt install virt-manager


#  ----------------------------------------------------------------------
# |                          Random programs                             |
#  ----------------------------------------------------------------------

# Obsidian
wget -O ./tmp/obsidian.deb https://github.com/obsidianmd/obsidian-releases/releases/download/v0.12.15/obsidian_0.12.15_amd64.deb
apt install -y ./tmp/obsidian.deb

# Postman
wget -O ./tmp/postman.tar.gz https://dl.pstmn.io/download/latest/linux64
tar -xf ./tmp/postman.tar.gz --directory=/opt
POSTMAN_DESKTOP=/home/lucas/.local/share/applications
touch $POSTMAN_DESKTOP/Postman.desktop
echo "[Desktop Entry]" >> $POSTMAN_DESKTOP/Postman.desktop
echo "Encoding=UTF-8" >> $POSTMAN_DESKTOP/Postman.desktop
echo "Name=Postman" >> $POSTMAN_DESKTOP/Postman.desktop
echo "Exec=/opt/Postman/app/Postman %U" >> $POSTMAN_DESKTOP/Postman.desktop
echo "Icon=/opt/Postman/app/resources/app/assets/icon.png" >> $POSTMAN_DESKTOP/Postman.desktop
echo "Terminal=false" >> $POSTMAN_DESKTOP/Postman.desktop
echo "Type=Application" >> $POSTMAN_DESKTOP/Postman.desktop
echo "Categories=Development;" >> $POSTMAN_DESKTOP/Postman.desktop

# Discord
wget -O ./tmp/discord.deb https://discord.com/api/download?platform=linux&format=deb
apt install -y ./tmp/discord.deb

# Teams
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
apt update
apt install -y teams

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
apt update
apt install -y spotify-client

# Stremio



#  ----------------------------------------------------------------------
# |                             Cleanup                                  |
#  ----------------------------------------------------------------------

# Remove bash artifacts
rm -f ~/.bash_history
rm -f ~/.profile

# Remove temporary directory
rm -rf ./tmp
