#!/usr/bin/env bash

set -e

DOTFILES_PATH=$HOME/.dotfiles

log ()
{
  echo ""
  echo "===================================================="
  echo ""
  echo "$1"
  echo ""
  echo "===================================================="
  echo ""
}

log "Installing git"
sudo pacman --noconfirm -S git

if [ -d $DOTFILES_PATH ]
then
    cd $DOTFILES_PATH
else
  log "Cloning dotfiles from github"
  git clone https://github.com/nixxxon/dotfiles.git $DOTFILES_PATH
  cd $DOTFILES_PATH
  git remote set-url origin git@github.com:nixxxon/dotfiles.git
fi

log "Setting up git"
ln -sf $HOME/.dotfiles/.gitconfig $HOME

log "Installing packages from the official repositories"
sudo pacman --noconfirm -Syu
sudo pacman --noconfirm -S \
  dmenu \
  i3lock \
  xautolock \
  neovim \
  zsh \
  zsh-completions \
  alacritty \
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
  nitrogen \
  bat \
  ripgrep \
  dunst \
  autorandr


log "Installing packages from the AUR"
yay --noconfirm -S \
  slack-desktop \
  google-chrome \
  xcursor-dmz \
  yaru-gtk-theme \
  awless

log "Installing terraform from hashicorp"
wget -q https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip -P /tmp \
  && unzip -o /tmp/terraform_0.9.8_linux_amd64.zip -d /tmp \
  && sudo mv /tmp/terraform /usr/local/bin/terraform

log "Installing aws-vault from hashicorp"
sudo curl -Lo /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-amd64
sudo chmod 755 /usr/local/bin/aws-vault

log "Installing zsh plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

log "Setting up i3"
mkdir -p $HOME/.config/i3
ln -sf $HOME/.dotfiles/.config/i3/* $HOME/.config/i3/
mkdir -p $HOME/.config/picom
ln -sf $HOME/.dotfiles/.config/picom/picom.conf $HOME/.config/picom/picom.conf


log "Setting up the shell"
sudo chsh -s $(which zsh) $USER
curl -L http://install.ohmyz.sh | sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -sf $HOME/.dotfiles/.p10k.zsh $HOME
ln -sf $HOME/.dotfiles/zsh/* $HOME

log "Setting up terminal"
mkdir -p $HOME/.config/alacritty
ln -sf $HOME/.dotfiles/.config/alacritty/* $HOME/.config/alacritty/

log "Setting up neovim"
mkdir -p $HOME/.config/nvim
ln -sf $HOME/.dotfiles/.config/nvim/* $HOME/.config/nvim/

log "Setting up polybar"
mmkdir -p $HOME/.config/polybar
ln -sf $HOME/.dotfiles/.config/polybar/* $HOME/.config/polybar/

log "Setting up docker"
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo systemctl start docker

log "Setting up gtk"
ln -sf $HOME/.dotfiles/.config/gtk-3.0-settings.ini $HOME/.config/gtk-3.0/settings.ini

log "Setting up xresources"
ln -sf $HOME/.dotfiles/.Xresources $HOME/.Xresources

log "Setting up xorg keyboard config"
sudo ln -sf $HOME/.dotfiles/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf

log "Setting up home/bin"
mkdir -p $HOME/bin
ln -sf $HOME/.dotfiles/bin/* $HOME/bin
chmod +x $HOME/bin/*

log -e "\nAll done! Log out and log in again.\n"
