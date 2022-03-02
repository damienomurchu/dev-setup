#!/bin/bash
# TODO - fonts, kubectl, helm, 


function get-input() {
    read -p "Enter hostname for machine: " machine_hostname
    read -p "Enter email for git and ssh keys: " git_ssh_email
    read -p "Enter name for git commits: " gh_name
    read -p "Enter a GitHub PAT to upload ssh key: " gh_pat
}

function set-hostname() {
    hostnamectl set-hostname $machine_hostname
}

# create new ssh key, add it to ssh agent, and upload to github
function setup-ssh() {
    # setup new key locally
    mkdir $HOME/.ssh
    ssh-keygen -t ed25519 -C "$ssh_key_email" -N "" -f $HOME/.ssh/id_$machine_hostname
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_$machine_hostname

    # add new key to github
    export public_ssh_key=$(cat $HOME/.ssh/id_$machine_hostname.pub)
    JSON_POST_BODY=$(printf '{"title": "%s", "key": "%s"}' "$machine_hostname" "$public_ssh_key")
    curl -s -d "$JSON_POST_BODY" "https://api.github.com/user/keys?access_token=$gh_pat"
    echo "public key added to github: $HOME/.ssh/id_$machine_hostname"
}

function setup-git() {
    dnf install -y git tig gh
    git config --global user.name "$gh_name"
    git config --global user.email "$git_ssh_email"
    mkdir repos
}

function install-dnf-packages() {
    sudo dnf install -y \
        tldr python3 python3-pip emacs tmux dnf-plugins-core toolbox jq gh fzf ripgrep \
        podman podman-compose @development-tools transmission 
}

function setup-zsh() {
    dnf install -y zsh
    chsh $(which zsh) #should be done under regular user, not root
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    # simlink zsh dotfiles
    [[ ! -d $HOME/.config/shell ]] || mkdir -p $HOME/.config/shell
    ln -sf $PWD/config/shell $HOME/.config/shell
    [[ ! -f $HOME/.zshrc ]] || ln -sf $PWD/config/zshrc $HOME/.zshrc 
}

function setup-i3() {
    dnf install -y i3-gaps rofi polybar picom maim fontawesome-fonts starship playerctl xclip feh arandr tilix
    git clone https://github.com/zbaylin/rofi-wifi-menu.git
    [[ ! -d $HOME/.config/i3 ]] || mkdir -p $HOME/.config/i3
    ln -sf $PWD/config/i3 $HOME/.config/i3
    [[ ! -d $HOME/.config/polybar ]] || mkdir -p $HOME/.config/polybar
    ln -sf $PWD/config/polybar $HOME/.config/polybar
    ln -sf $PWD/config/starship.toml $HOME/.config/starship.toml
}

function setup-vim() {
    dnf install -y vim
    [[ ! -f $HOME/.vim ]] || ln -sf $PWD/config/vim $HOME/.vim 
    [[ ! -f $HOME/.vimrc ]] || ln -sf $PWD/config/vimrc $HOME/.vimrc 
}

function setup-vscodium() {
    rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
    printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
    dnf install codium
    ln -sf $PWD/config/vscode/settings.json $HOME/.config/VSCodium/User/settings.json
    ln -sf $PWD/config/vscode/keybindings.json $HOME/.config/VSCodium/User/keybindings.json
}

function setup-brave() {
    dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
    rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    dnf install -y brave-browser
    # add bitwarden
}

function 


function setup-fedora() {

}
