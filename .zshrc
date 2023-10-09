# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
	git
	vscode
	chucknorris
	emoji
	gh
	lol
	rust
	safe-paste
	sudo
	yarn
	web-search
	colorize
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

alias ls='lsd -A'

alias aptup='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y'

# Define a custom function for 'rm' that adds extra confirmation
safe_rm() {
    local critical_dirs=("/" "$HOME")

    for dir in "${critical_dirs[@]}"; do
        if [[ "$1" == "$dir"* ]]; then
            read -q "REPLY?Are you sure you want to delete '$1'? [y/n] "
            echo
            if [[ "$REPLY" != "y" ]]; then
                echo "Deletion of '$1' canceled."
                return 1
            fi
        fi
    done

    # Call the real 'rm' command with the arguments passed to this function
    command trash "$@"
}

# Alias 'rm' to our custom function
alias rm=safe_rm

# alias nautilus becuase i can never remember what it's called
alias explorer=nautilus

# enable command-not-found if install
source /etc/zsh_command_not_found

eval $(thefuck --alias)

export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

fpath=($fpath "/home/gutenfries/.zfunctions")

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.p10k.zsh

export PATH=$PATH:/$HOME/.cargo/bin/:/$HOME/.bin/:$HOME/.pub-cache/bin
