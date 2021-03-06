#!/bin/bash
# TODO - fonts, kubectl, helm, 


function get-setup-inputs() {
  read -p "Enter hostname for machine: " machine_hostname
  read -p "Enter email for git and ssh keys: " git_ssh_email
  read -p "Enter name for git commits: " gh_name
  read -p "Enter GitHub username to upload ssh key: " gh_username
  read -p "Enter a GitHub PAT (write:public_key) to upload ssh key: " gh_pat
}

function set-hostname() {
  hostnamectl set-hostname $machine_hostname
  echo "Set machine hostname: $machine_hostname"
}

# create new ssh key and add it to ssh agent
function setup-local-ssh-key() {
  # setup new key locally
  mkdir $HOME/.ssh
  ssh-keygen -t ed25519 -C "$ssh_key_email" -N "" -f $HOME/.ssh/id_$machine_hostname
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_$machine_hostname
  echo "New SSH created and added to ssh-agent: ~/.ssh/id_$machine_hostname"
}

# upload new public ssh key to github
function add-github-ssh-key() {
  # add new key to github
  export public_ssh_key=$(cat $HOME/.ssh/id_$machine_hostname.pub)
  JSON_POST_BODY=$(printf '{"title": "%s", "key": "%s"}' "$machine_hostname" "$public_ssh_key")
  curl -u "$gh_username:$gh_pat" -s -d "$JSON_POST_BODY" "https://api.github.com/user/keys"
  echo "Public SSH key added to GitHub: ~/.ssh/id_$machine_hostname.pub"
}

function install-base-packages() {
  base_packages=(dnf-plugins-core \ 
    @development-tools \
    podman podman-compose toolbox \
    python3 python-pip \
    emacs tmux \
    jq gh fzf ripgrep tldr \
    transmission \
  )
  sudo dnf update -y 
  sudo dnf install -y $base_packages
  echo "Base packages installed: $base_packages"
}

function setup-git() {
  export git_packages=(git tig gh)
  sudo dnf install -y $git_packages
  [[ ! -f $HOME/.gitconfig ]] || ln -sf $PWD/config/gitconfig $HOME/.gitconfig 
  git config --global user.name "$gh_name"
  git config --global user.email "$git_ssh_email"
  echo "Base git packages installed ($git_packages) and git configured."
}

function setup-zsh() {
  sudo dnf install -y zsh util-linux-user
  chsh -s $(which zsh)
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    $HOME/.config/shell/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    $HOME/.config/shell/zsh-autosuggestions
  # simlink zsh dotfiles
  [[ ! -d $HOME/.config/shell ]] || mkdir -p $HOME/.config/shell
  ln -sf $PWD/config/shell/aliases $HOME/.config/shell/aliases
  ln -sf $PWD/config/shell/functions $HOME/.config/shell/functions
  [[ ! -f $HOME/.zshrc ]] || ln -sf $PWD/config/zshrc $HOME/.zshrc 
  echo "zsh and associated packages installed and configured."
}

function setup-i3() {
  sudo dnf install -y i3-gaps rofi polybar picom maim fontawesome-fonts starship playerctl xclip feh arandr tilix
  git clone https://github.com/zbaylin/rofi-wifi-menu.git \
    $HOME/.config/rofi-wifi-menu
  [[ ! -d $HOME/.config/i3 ]] || mkdir -p $HOME/.config/i3
  ln -sf $PWD/config/i3 $HOME/.config/i3
  [[ ! -d $HOME/.config/polybar ]] || mkdir -p $HOME/.config/polybar
  ln -sf $PWD/config/polybar $HOME/.config/polybar
  ln -sf $PWD/config/starship.toml $HOME/.config/starship.toml
  echo "i3 and all required packages installed and configured."
}

function setup-vim() {
  sudo dnf install -y vim
  [[ ! -f $HOME/.vim ]] || ln -sf $PWD/config/vim $HOME/.vim 
  [[ ! -f $HOME/.vimrc ]] || ln -sf $PWD/config/vimrc $HOME/.vimrc 
  echo "Vim and plugins installed and configured"
}

function setup-vscodium() {
  rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
  printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
  sudo dnf install codium -y
#  ln -sf $PWD/config/vscode/settings.json $HOME/.config/VSCodium/User/settings.json
#  ln -sf $PWD/config/vscode/keybindings.json $HOME/.config/VSCodium/User/keybindings.json
  echo "VSCodium installed and configured"
}

function setup-brave() {
  sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
  sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
  sudo dnf install -y brave-browser
#  cp $PWD/config/brave/extensions/* \
#    $HOME/.config/BraveSoftware/Brave-Browser/Default/Extensions
  echo "Brave-browser installed and configured"
}

function setup-fedora() {
  get-setup-inputs
  set-hostname
  setup-local-ssh-key
  add-github-ssh-key
  install-base-packages
  setup-git
  setup-zsh
  setup-i3
  setup-vim
  setup-vscodium
  setup-brave
}

#setup-fedora
