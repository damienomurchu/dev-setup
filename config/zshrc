#!/bin/bash

function configure-zsh() {
  # oh-my-zsh options
  HISTFILE=~/.histfile
  HISTSIZE=10000
  SAVEHIST=100000
  autoload -U promptinit # initialize the prompt system promptinit for additional themes
  # Preferred editor for local and remote sessions
  if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
  else
    export EDITOR='vim'
  fi
  export ZSH="$HOME/.oh-my-zsh"
  # ZSH_THEME="bira"
  # autocompletion for commands
  autoload -U +X bashcompinit && bashcompinit
  autoload -Uz compinit && compinit
  complete -o nospace -C /usr/local/bin/terraform terraform
  complete -C '/usr/bin/aws_completer' aws

  POWERLEVEL9K_MODE="nerdfont-complete"
  HYPHEN_INSENSITIVE="true"
  DISABLE_AUTO_UPDATE="true"
  HIST_STAMPS="yyyy-mm-dd" # Changes the history time-date stamp
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=232'
  plugins=(
    zsh-autosuggestions
    history-substring-search
    zsh-syntax-highlighting
    fzf
  )
  source $ZSH/oh-my-zsh.sh
}

function configure-theme() {
  eval "$(starship init zsh)"
}

function fix-zsh-pastes() {
  # to workaround bug in zsh-autosuggestions where pastes are really slow
  # This speeds up pasting w/ autosuggest
  # https://github.com/zsh-users/zsh-autosuggestions/issues/238
  pasteinit() {
    OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
    zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
  }
  pastefinish() {
    zle -N self-insert $OLD_SELF_INSERT
  }
  zstyle :bracketed-paste-magic paste-init pasteinit
  zstyle :bracketed-paste-magic paste-finish pastefinish
}

function init-shell-aliases() {
  [ -f $HOME/.config/shell/aliases ] && source $HOME/.config/shell/aliases
}

function init-shell-functions() {
  [ -f $HOME/.config/shell/functions ] && source $HOME/.config/shell/functions
}

function init-shell-env() {
  # required to run kitty natively in wayland
  export KITTY_ENABLE_WAYLAND=1

  # pyenv
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi

  # required to handle go deps issues
  export GOPROXY="https://proxy.golang.org"

  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
  export GO111MODULE=on
  export PATH=$PATH:$HOME/.local/bin
  export PATH=$PATH:$HOME/Library/Python/3.8/bin
  export PATH="$HOME/.poetry/bin:$PATH"
}

function setup-tools() {
  # autocompletion for kubectl
  [ -x "$(command -v kubectl)" ] && source <(kubectl completion zsh)

  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  [ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
  [ -f /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh ] && source /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh

  # also rvm -related - necessary?
  [ -f /home/damien/.rvm/scripts/rvm ] && source /home/damien/.rvm/scripts/rvm

  # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
  export PATH="$PATH:$HOME/.rvm/bin"

  # nvm stuff
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
  export PATH="$PATH:$HOME/.rvm/bin"

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

  #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
  export SDKMAN_DIR="/home/dm/.sdkman"
  [[ -s "/home/dm/.sdkman/bin/sdkman-init.sh" ]] && source "/home/dm/.sdkman/bin/sdkman-init.sh"
}

function setup-shell() {
  configure-zsh
  configure-theme
  fix-zsh-pastes
  init-shell-aliases
  init-shell-functions
  init-shell-env
  setup-tools
}

setup-shell
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
