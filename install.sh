#!/bin/bash

echo "Running distro-agnostic setup."
CALLING_USER=${SUDO_USER:-$USER}


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
cp -r {.zsh,.zshrc} /home/$CALLING_USER
chown -R $CALLING_USER:$CALLING_USER /home/$CALLING_USER/{.zsh,.zshrc}

# Starship.rs prompt
cp ./starship.toml /home/$CALLING_USER/.config/

# Tmux conf
cp ./.tmux.conf /home/$CALLING_USER/

# Enable minimize on click while keeping the multiple window picker enabled
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

# Remove bash artifacts
rm -f /home/$CALLING_USER/{.bash_history,.bash_logout,.profile}

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -qy

# Call distro-specific scripts
SUPPORTED_DISTROS=("ubuntu" "exherbo" "fedora")
DISTRO=$(grep -Po "(?<=^ID=).+" /etc/os-release | sed 's/"//g')
echo "Detected distro: $DISTRO."
if [[ " ${SUPPORTED_DISTROS[*]} " =~ " ${DISTRO} " ]]; then
    /bin/bash "./distro-specific/$DISTRO.sh"
else
    echo "Unsupported distribution."
fi
