#!/usr/bin/env bash

set -e

DOTFILES_PATH=$HOME/.dotfiles
CONFIG_PATH=$HOME/.config

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
ln -sf $DOTFILES_PATH/.gitconfig $HOME/

log "Installing packages from the official repository"
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

log "Installing packages from the user repository"
yay --noconfirm -S \
  slack-desktop \
  google-chrome \
  xcursor-dmz \
  yaru-gtk-theme \
  awless

log "Installing zsh plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

log "Setting up docker"
sudo usermod -a -G docker $USER
sudo systemctl enable docker
sudo systemctl start docker

log "Setting up the shell"
sudo chsh -s $(which zsh) $USER
curl -L http://install.ohmyz.sh | sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -sf $DOTFILES_PATH/.p10k.zsh $HOME
ln -sf $DOTFILES_PATH/zsh/* $HOME

log "Setting up .config"
ln -sf $DOTFILES_PATH/.config/* $CONFIG_PATH/

log "Setting up neovim"
rm -rf $CONFIG_PATH/nvim
git clone --depth 1 https://github.com/AstroNvim/AstroNvim $CONFIG_PATH/nvim
ln -sf $DOTFILES_PATH/nvim/lua/user $CONFIG_PATH/nvim/lua/

log "Setting up xresources"
ln -sf $DOTFILES_PATH/.Xresources $HOME/.Xresources

log "Setting up xorg keyboard config"
sudo ln -sf $DOTFILES_PATH/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf

log "Setting up home/bin"
ln -sf $DOTFILES_PATH/bin $HOME/
chmod +x $HOME/bin/*

log -e "\nAll done! Log out and log in again.\n"
