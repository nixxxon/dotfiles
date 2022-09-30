#!/usr/bin/env bash

set -e

DOTFILES_PATH=$HOME/.dotfiles

echo "Installing git"
sudo pacman --noconfirm -S git
echo "Done"

if [ -d $DOTFILES_PATH ]
then
    cd $DOTFILES_PATH
else
  echo ""
  echo "===================================================="
  echo ""

  echo "Cloning dotfiles from github"

  git clone https://github.com/nixxxon/dotfiles.git $DOTFILES_PATH
  cd $DOTFILES_PATH
  git remote set-url origin git@github.com:nixxxon/dotfiles.git
  echo "Done"
fi

echo ""
echo "===================================================="
echo ""

echo "Setting up git"
ln -sf $HOME/.dotfiles/.gitconfig $HOME
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Installing packages from the official repositories"
sudo pacman -Syu && sudo pacman --noconfirm -S \
  dmenu \
  i3lock \
  xautolock \
  nvim \
  zsh \
  zsh-completions \
  zsh-autosuggestions \
	yay \
	dnsutils \
	traceroute \
	nvidia \
	bumblebee \
	powertop \
	polybar \
	base-devel \
	libcurl-compat \
	docker \
	docker-compose \
	aws-cli \
	keybase-gui \
	xclip \
	dunst
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Installing packages from the AUR"
yay --noconfirm -S \
	slack-desktop \
	google-chrome \
	awless
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Installing terraform from hashicorp"
wget -q https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip -P /tmp \
	&& unzip -o /tmp/terraform_0.9.8_linux_amd64.zip -d /tmp \
	&& sudo mv /tmp/terraform /usr/local/bin/terraform
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Installing aws-vault from hashicorp"
sudo curl -Lo /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-amd64
sudo chmod 755 /usr/local/bin/aws-vault
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Setting up i3"
ln -sf $HOME/.dotfiles/i3config $HOME/.config/i3/config

ln -sf $HOME/.dotfiles/picom.conf $HOME/.config
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Setting up the shell"
sudo chsh -s $(which zsh) $USER

curl -L http://install.ohmyz.sh | sh

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -sf $HOME/.dotfiles/.p10k.zsh $HOME

ln -sf $HOME/.dotfiles/zsh/* $HOME
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Setting up neovim"
mkdir -p $HOME/.config/nvim
ln -sf $HOME/.dotfiles/nvim/* $HOME/.config/nvim/
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Setting up docker"
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo systemctl start docker
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Setting up gtk"
ln -sf $HOME/.dotfiles/gtk-3.0-settings.conf $HOME/.config/gtk-3.0/settings.ini
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Setting up xresources"
ln -sf $HOME/.dotfiles/.Xresources $HOME/.Xresources
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Setting up xorg keyboard config"
sudo ln -sf $HOME/.dotfiles/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf
ln -sf $HOME/.dotfiles/.Xresources $HOME/.Xresources
echo "Done"

echo ""
echo "===================================================="
echo ""

echo "Setting up home/bin"
mkdir -p $HOME/bin
ln -sf $HOME/.dotfiles/bin/* $HOME/bin
chmod +x $HOME/bin/*
echo "Done"

echo ""
echo "===================================================="
echo ""

echo -e "\nAll done! Log out and log in again.\n"
