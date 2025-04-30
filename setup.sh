#!/bin/bash
set -e

# --- Configuration ---
USERNAME=${SUDO_USER:-$(whoami)}
HOSTNAME="casaos.local"
TIMEZONE="America/Denver"
LOCALE="en_US.UTF-8"
KEYMAP="us"

# --- Basic Setup ---
echo "[4/8] Installing packages..."
apt update && apt upgrade -y
apt install -y \
    curl \
    sudo \
    ca-certificates \
    gnupg \
    lsb-release \
    openssh-server \
    software-properties-common

echo "[5/8] Ensuring SSH is enabled..."
systemctl enable ssh
systemctl start ssh

# --- Docker Setup ---
echo "[6/8] Installing Docker and Docker Compose..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[*] Adding $USERNAME to docker group..."
usermod -aG docker $USERNAME

# --- CasaOS Installation ---
echo "[7/8] Installing CasaOS..."
curl -fsSL https://get.casaos.io | bash

echo "[8/8] Setup complete. Rebooting recommended."
