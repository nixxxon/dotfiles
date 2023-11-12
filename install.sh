#!/usr/bin/env bash

set -e

dotfiles_path="$HOME"/.dotfiles
config_path="$HOME"/.config

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
  log "Setting up git"
  ln -sf "$dotfiles_path"/.gitconfig "$HOME"/
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
    awless
  line
fi

ask "Setup Zsh (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
  log "Setting up Zsh"
  sudo chsh -s "$(which zsh)" "$USER"
  curl -L http://install.ohmyz.sh | sh
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  ln -sf "$dotfiles_path"/.p10k.zsh "$HOME"/
  ln -sf "$dotfiles_path"/zsh/* "$HOME"/

  log "Installing zsh plugins"
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
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
  for dotfiles_config_path in "$dotfiles_path"/.config/*; do
    real_config_path="$config_path"/$(basename "$dotfiles_config_path")
    rm -rf "$real_config_path"
    ln -sf "$dotfiles_config_path" "$real_config_path"
  done

  log "Setting up Neovim"
  rm -rf "$config_path"/nvim
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$config_path"/nvim
  ln -sf "$dotfiles_path"/.config/nvim "$config_path"/nvim/lua/user

  log "Setting up Xresources"
  ln -sf "$dotfiles_path"/.Xresources "$HOME"/.Xresources

  log "Setting up Xorg keyboard config" 
  sudo ln -sf "$dotfiles_path"/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf
  line
fi

ask "Setup home/bin (y/n)?"
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  line
  log "Setting up home/bin"
  ln -sf "$dotfiles_path"/bin "$HOME"/
  chmod +x "$HOME"/bin/*
  line
fi

log ""
log "All done! Log out and log in again."
