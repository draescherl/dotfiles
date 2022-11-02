#! /bin/bash


# Run script as root
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"
echo "Running distro-agnostic setup."

# Configure Zsh
for dir in .zsh/*; do
        if [ -d $dir ]; then
                while IFS= read -r repository; do
                        cd $dir
                        git clone $repository
            			cd ../..
                done < ./$dir/git-repos.txt
        fi
done
cp -r {.zsh,.zshrc} /home/$SUDO_USER
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/{.zsh,.zshrc}

# Starship.rs prompt
cp ./starship.toml /home/$SUDO_USER/.config/

# Enable minimize on click while keeping the multiple window picker enabled
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

# Remove bash artifacts
rm -f /home/$SUDO_USER/{.bash_history,.bash_logout,.profile}

# Call distro-specific scripts
SUPPORTED_DISTROS=("ubuntu" "exherbo")
DISTRO=$(grep -Po "(?<=^ID=).+" /etc/os-release | sed 's/"//g')
echo "Detected distro: $DISTRO."
if [[ " ${SUPPORTED_DISTROS[*]} " =~ " ${DISTRO} " ]]; then
    /bin/bash "./distro-specific/$DISTRO.sh"
else
    echo "Unsupported distribution."
fi