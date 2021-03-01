#!/usr/bin/env bash
set -euo pipefail

# This is intended for a Debian-based deployment host

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

apt-get update

# Make sure you're in a spot to run any other scripts from the same workdir
cd "$(dirname "$0")" || exit 1

apt-wipe() {
  apt-get autoremove -y
  apt-get autoclean
  apt-get clean
}

init-sys-packages() {
  printf "\nInstalling system packages...\n\n" > /dev/stderr && sleep 2
  apt-get install -y \
    apt-transport-https \
    bash-completion \
    ca-certificates \
    curl \
    dnsutils \
    gnupg \
    htop \
    jq \
    nmap \
    software-properties-common \
    tmux \
    unzip \
    zip
  apt-wipe
}

init-nomad() {
  curl \
    -fsSL \
    -o nomad.zip \
    "https://releases.hashicorp.com/nomad/${nomad_version:-NOT_SET}/nomad_${nomad_version}_linux_amd64.zip"
  unzip nomad.zip && rm nomad.zip
  mv nomad /usr/local/bin/nomad

  nomad -version || {
    printf "ERROR: Unable to install Nomad\n"
    exit 1
  }
}

main() {
  init-sys-packages
  init-nomad

  apt-wipe

  # # Now, fork remaining logic based on node type & target platform
  # bash ./init-"${node_type:-undefined_node_type}"-"${platform:-undefined_platform}".sh
}


main

exit 0
