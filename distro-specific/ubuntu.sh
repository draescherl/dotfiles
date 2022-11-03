#!/bin/bash

echo "Running ubuntu-specific setup tasks."


# update, upgrade and install utilities
apt update -yyq
apt upgrade -yyq
apt autoremove -yyq
apt install -yqq git ca-certificates curl gnupg lsb-release build-essential apt-transport-https


# --- Import repositories ---

# clever tools
curl -fsSL https://clever-tools.clever-cloud.com/gpg/cc-nexus-deb.public.gpg.key | gpg --dearmor -o /usr/share/keyrings/cc-nexus-deb.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/cc-nexus-deb.gpg] https://nexus.clever-cloud.com/repository/deb stable main" | tee -a /etc/apt/sources.list

# docker
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# scala
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import
chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg


# --- Install software ---

apt install -yyq \
	tmux \                                                       # tmux
	zsh \                                                        # zsh
	python3-virtualenv \                                         # python
	default-jre default-jdk \                                    # java
	sbt \                                                        # scala
	clever-tools \                                               # CLI clever cloud
	docker-ce docker-ce-cli containerd.io docker-compose-plugin  # docker


# --- Software specific steps

# docker
groupadd docker
usermod -aG docker $SUDO_USER
