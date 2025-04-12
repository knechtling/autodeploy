#!/bin/bash

set -e

# Schritt 1: Systempakete installieren
echo "📦 Installing required packages..."
sudo pacman -Syu --noconfirm ansible python openssh git base-devel

# Schritt 2: Ansible Galaxy Collection 'kewlfft.aur' installieren
echo "🌐 Installing Ansible AUR collection..."
ansible-galaxy collection install kewlfft.aur

# Schritt 3: Desktop-Playbook ausführen (muss in aktuellem Verzeichnis liegen)
echo "🚀 Running desktop playbook..."
ansible-playbook desktop.yml -i inventory

echo "✅ Done."
