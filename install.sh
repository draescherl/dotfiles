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
cp .zshrc ~/
cp -r .zsh ~/
for dir in .zsh/*; do
        if [ -d $dir ]; then
                while IFS= read -r line; do
                        cd $dir
			$line
			cd ../..
                done < ./$dir/git-repos.txt
        fi
done



#  ----------------------------------------------------------------------
# |                     Programming languages                            |
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



#  ----------------------------------------------------------------------
# |                             Cleanup                                  |
#  ----------------------------------------------------------------------

# Remove bash artifacts
rm -f ~/.bash_history
rm -f ~/.profile

# Make zsh the default shell
chsh --shell /bin/zsh lucas
