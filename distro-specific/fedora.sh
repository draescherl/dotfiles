#!/bin/bash

echo "Running fedora-specific setup tasks."
CALLING_USER=${SUDO_USER:-$USER}


# update and utilities
dnf upgrade -y
dnf autoremove -y
dnf install -y dnf-plugins-core

# rpm fusion free & non-free
dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


# --- Import repositories ---

# docker
dnf config-manager --add-repo \
  https://download.docker.com/linux/fedora/docker-ce.repo


# --- Install software ---

dnf install -y \
  docker-ce docker-ce-cli containerd.io docker-compose-plugin


# --- Software specific steps ---

# docker
groupadd docker
usermod -aG docker $CALLING_USER
