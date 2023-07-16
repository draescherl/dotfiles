#!/bin/bash

echo "[+] Running fedora-specific setup tasks."
CALLING_USER=${SUDO_USER:-$USER}


# update and utilities
dnf upgrade -y
dnf autoremove -y
dnf install -y dnf-plugins-core

# rpm fusion free & non-free
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


# --- Import repositories ---

# docker
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# scala
rm -f /etc/yum.repos.d/bintray-rpm.repo
curl -L https://www.scala-sbt.org/sbt-rpm.repo > /etc/yum.repos.d/sbt-rpm.repo

# clever tools
curl -s https://clever-tools.clever-cloud.com/repos/cc-nexus-rpm.repo > /etc/yum.repos.d/cc-nexus-rpm.repo

# flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# --- Install software ---

dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
dnf install -y java-latest-openjdk-devel.x86_64 sbt
dnf install -y clever-tools htop ffmpeg-libs
dnf install -y zsh direnv zoxide bat

usermod -s /usr/bin/zsh $CALLING_USER

flatpak install -y flathub com.slack.Slack
flatpak install -y flathub com.discordapp.Discord


# --- Software specific steps ---

# docker
groupadd docker
usermod -aG docker $CALLING_USER
