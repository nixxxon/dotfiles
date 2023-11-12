#!/usr/bin/env bash

set -e

dotfiles_path="$HOME"/.dotfiles
config_path="$HOME"/.config
bin_path="${HOME:?}"/bin

shopt -s dotglob

log ()
{
  echo "$1"
}

line ()
{
  echo ""
  echo "===================================================="
  echo ""
}

ask ()
{
  read -p "$1 " -n 1 -r
  echo ""
}

symlink_files ()
{
  source_path=$1
  target_path=$2
  
  for source_file_path in "$source_path"/*; do
    target_file_path="$target_path"/$(basename "$source_file_path")
    rm -rf "$target_file_path"
    ln -sf "$source_file_path" "$target_file_path"
  done
}

ask "Install Git (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
  log "Installing git"
  sudo pacman --noconfirm -S git
  line
fi

if [ -d "$dotfiles_path" ]
then
    cd "$dotfiles_path"
else
  line
  log "Cloning dotfiles from github"
  git clone https://github.com/nixxxon/dotfiles.git "$dotfiles_path"
  cd "$dotfiles_path"
  git remote set-url origin git@github.com:nixxxon/dotfiles.git
  line
fi

ask "Setup Git (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
  line
fi

ask "Install packages from the official repository (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
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
  line
fi

ask "Install packages from the user repository (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
  log "Installing packages from the user repository"
  yay --noconfirm -S \
    slack-desktop \
    google-chrome \
    xcursor-dmz \
    yaru-gtk-theme \
    awless \
    1password
  line
fi

ask "Setup Zsh (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
  log "Setting up Zsh"
  chsh -s "$(which zsh)"

  log "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  log "Installing Zsh themes"
  themes_path="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes
  rm -rf "${themes_path:?}"/*
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$themes_path"/powerlevel10k

  log "Installing Zsh plugins"
  plugins_path="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins
  rm -rf "${plugins_path:?}"/*
  git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_path"/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_path"/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions "$plugins_path"/zsh-completions
  line
fi

ask "Setup Docker (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
  log "Setting up Docker"
  sudo usermod -a -G docker "$USER"
  sudo systemctl enable docker
  sudo systemctl start docker
  line
fi

ask "Setup config (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
  log "Setting up .config"
  symlink_files "$dotfiles_path"/.config "$config_path"

  log "Setting up home"
  symlink_files "$dotfiles_path"/home "$HOME"

  log "Setting up Neovim"
  rm -rf "$config_path"/nvim
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$config_path"/nvim
  ln -sf "$dotfiles_path"/.config/nvim "$config_path"/nvim/lua/user

  log "Setting up Xorg keyboard config" 
  sudo rm -rf /etc/X11/xorg.conf.d/00-keyboard.conf
  sudo ln -sf "$dotfiles_path"/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf
  line
fi

ask "Setup home/bin (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
  log "Setting up home/bin"
  rm -rf "$bin_path"
  ln -sf  "$dotfiles_path"/bin "$bin_path"
  chmod +x "$bin_path"/*
  line
fi

log ""
log "All done! Log out and log in again."
log ""
