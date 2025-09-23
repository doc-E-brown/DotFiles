# If you come from bash you might have to change your $PATH.

# Path to your oh-my-zsh installation.
export ZSH="/home/ben/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#  ZSH_THEME="agnoster"
ZSH_THEME="robbyrussell"
# ZSH_THEME="bira"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
export EDITOR='nvim'
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

# Git
function githubfra() {
  git config --local user.email "ben.johnston@franklin.ai"
  git config --local user.name "Ben Johnston"
  git config --local commit.gpgsign true
  git config --local user.signingkey 5A6DCD6823C086E488E7635414D8B68B6A6D7701
}

function githubpro() {
  git config --local user.email "docEbrown_github@protonmail.com"
  git config --local user.name "Ben Johnston"
  git config --local commit.gpgsign true
  git config --local user.signingkey 1960C3DB5EACA5A0FEADF4E52764C31DF6FF93C3
}

alias wacom='sudo xsetwacom set "Wacom Intuos S Pen stylus" Mode Relative'


# Functions
rechown() {
    sudo chown -R ben.ben $(pwd)
}

##############################################
# Powerline  - DO NOT REMOVE

function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" -a -x "$(command -v powerline-shell)" ]; then
    install_powerline_precmd
fi

##############################################
# Handy functions
# 
alias uuid=uuidgen
function ely() { earthly --allow-privileged --secret aws_access_key_id="$AWS_ACCESS_KEY_ID" --secret aws_secret_access_key="$AWS_SECRET_ACCESS_KEY" --secret aws_session_token="$AWS_SESSION_TOKEN" --secret cloudsmith_api_username="$CLOUDSMITH_USERNAME" --secret cloudsmith_api_key="$CLOUDSMITH_API" "${@}" --git_sha="$(git rev-parse --short HEAD)" }
function drmi() { docker rm $(docker ps -aq) && docker rmi $(docker images -q -f dangling=true) }
function rosk3s() { export KUBECONFIG=$HOME/.config/kube/config-k3s-$1 }
rosk3s devmain
alias k='kubectl'
function devbff() { kubectl port-forward service/bff-service $1:8002 -n rosalind }
function gitclean() { git branch | grep -v main | xargs git branch -f -D }
function ssmForward() { aws ssm start-session --target $1 --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["1234"],"localPortNumber":["1234"]}' }
function rosredis_pword() {
	echo $(kubectl get secret redis-pass -n redis -o json | jq '.metadata.annotations."kubectl.kubernetes.io/last-applied-configuration"' | jq -r | jq '.data.password' | jq -r | base64 --decode)
}
function rosredis() {
	kubectl port-forward service/redis-master $1:6379 -n redis
}
function rosredis_cli() {
	redis-cli -p $1 -a $2 
}


#export EMSDK_QUIET=1
#source "/home/ben/Workspace/emsdk/emsdk_env.sh"

# Add cpmmake
function cpmmake() {
	mkdir -p cmake
	wget -O cmake/CPM.cmake https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake
}

# Apply patches from gh workflows copied from the clipboard
function ffs() {
	git apply <(xclip -o -selection clipboard)
}

# Trigger inference in the mock collector
function mockco() {
	curl -vv https://mock-coordinator.devmain-onpremk3s.franklinai.dev/start_analysis/$1
}

##############################################
# Exports

export PATH=$PATH:/home/ben/.local/bin

. "$HOME/.cargo/env"

export GPG_TTY=$(tty)

alias docker-compose='docker compose'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PKG_CONFIG_PATH=/home/ben/.nix-profile

# pnpm
export PNPM_HOME="/home/ben/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# 

# Add secret files
source ~/.secrets
