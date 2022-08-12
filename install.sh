#! /bin/sh



#  ----------------------------------------------------------------------
# |                          General stuff                               |
#  ----------------------------------------------------------------------

# Run script as root
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

# Update and upgrade
apt update -yyq
apt dist-upgrade -yyq
apt autoremove -yyq

# Utilities
apt install -yyq git ca-certificates curl gnupg lsb-release build-essential apt-transport-https
git config --global user.name "Lucas DRAESCHER"
git config --global user.email "lucas.draescher@gmail.com"

# Install and configure Zsh
apt install -yyq zsh
for dir in .zsh/*; do
        if [ -d $dir ]; then
                while IFS= read -r line; do
                        cd $dir
			$line
			cd ../..
                done < ./$dir/git-repos.txt
        fi
done
cp -r .zsh /home/$SUDO_USER
cp .zshrc /home/$SUDO_USER

# Enable minimize on click while keeping the multiple window picker enabled
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'


#  ----------------------------------------------------------------------
# |                       Programming stuff                              |
#  ----------------------------------------------------------------------

# Python
apt install -yqq python3-virtualenv

# Java
apt install -yqq default-jre default-jdk

# Scala
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import
chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg
apt update -yqq
apt install -yqq sbt

# Clever Cloud CLI
curl -fsSL https://clever-tools.clever-cloud.com/gpg/cc-nexus-deb.public.gpg.key | gpg --dearmor -o /usr/share/keyrings/cc-nexus-deb.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/cc-nexus-deb.gpg] https://nexus.clever-cloud.com/repository/deb stable main" | tee -a /etc/apt/sources.list
apt update -yqq
apt install -yqq clever-tools

# Docker
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -yqq
apt install -yqq docker-ce docker-ce-cli containerd.io docker-compose-plugin
groupadd docker
usermod -aG docker $SUDO_USER



#  ----------------------------------------------------------------------
# |                             Cleanup                                  |
#  ----------------------------------------------------------------------

# Remove bash artifacts
rm -f ~/.bash_history
rm -f ~/.profile

# Make zsh the default shell
chsh --shell /bin/zsh $SUDO_USER

# Indications
echo '----------------------------------------'
echo 'Run: newgrp docker'
