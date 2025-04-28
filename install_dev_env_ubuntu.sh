#!/bin/bash

# install_dev_env.sh
# Brojo's Ultimate C++ Developer Setup Script for Windows (Git Bash / MSYS2) or Linux/WSL

echo "🚀 Starting Full Development Environment Setup..."

# Step 1: Check and Install Git
echo "🔍 Checking Git installation..."
if ! command -v git &> /dev/null
then
    echo "❌ Git not found. Please install Git manually first from https://git-scm.com/downloads"
    exit 1
else
    echo "✅ Git is installed."
fi

# Step 2: Install MSYS2 (Only on Windows)
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo "🔍 Checking MSYS2 installation..."
    if [ ! -d "C:/msys64" ]; then
        echo "❌ MSYS2 not found. Please manually install MSYS2 from https://www.msys2.org/ first."
        exit 1
    else
        echo "✅ MSYS2 is installed."
    fi
fi

# Step 3: Install build tools inside MSYS2
echo "🔨 Installing gcc, cmake, make inside MSYS2 MinGW64..."

# Only continue if we are inside MSYS2
if [[ "$MSYSTEM" == "MINGW64" ]]; then
    pacman -Syu --noconfirm
    pacman -S --needed --noconfirm mingw-w64-x86_64-gcc mingw-w64-x86_64-cmake mingw-w64-x86_64-make git
    echo "✅ Build tools installed inside MSYS2."
else
    echo "⚠️ Not inside MSYS2 MinGW64. Skipping MSYS2 package install."
fi

# Step 4: Install VS Code (Manual Step)
echo "🛠️ Please manually install VS Code from https://code.visualstudio.com/ if not already installed."
echo "⚡ Make sure to check 'Add to PATH' option during VS Code installation."

# Step 5: Install VS Code Extensions
echo "🔌 Installing VS Code C++ and CMake Tools extensions..."
if command -v code &> /dev/null
then
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-vscode.cmake-tools
    code --install-extension twxs.cmake
    code --install-extension eamodio.gitlens
    echo "✅ VS Code extensions installed."
else
    echo "❌ 'code' command not found. Please run 'Shell Command: Install code in PATH' from inside VS Code."
fi

# Step 6: Git global config
echo "🛠️ Configuring Git global username and email..."
git config --global user.name "Brojogopal Sapui"
git config --global user.email "your.email@example.com"

echo "✅ Git username and email set."

# Step 7: SSH Key Setup
echo "🔐 Setting up SSH Key for GitHub..."

if [ ! -f ~/.ssh/id_rsa ]; then
    read -p "Enter your GitHub email for SSH key: " github_email
    ssh-keygen -t rsa -b 4096 -C "$github_email"
    echo "✅ SSH key generated."
else
    echo "✅ SSH key already exists."
fi

echo ""
echo "📋 Your SSH public key (copy and paste into GitHub > Settings > SSH and GPG Keys):"
echo "--------------------------------------"
cat ~/.ssh/id_rsa.pub
echo "--------------------------------------"

echo ""
echo "🎯 After copying your SSH key, test connection using:"
echo "    ssh -T git@github.com"
echo ""

# Final message
echo "✨🚀 Full C++ Development Environment Setup Complete!"
echo "Happy Coding, Brojo! 🚀🔥"
