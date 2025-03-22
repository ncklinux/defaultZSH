# History configuration
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Key bindings
bindkey -e  # Use emacs key bindings

# Define custom ZLE widgets for history substring search
history-substring-search-up() {
    BUFFER=${(M)history[(ie)$BUFFER]}[1]
    if [[ -n "$BUFFER" ]]; then
        LBUFFER=$BUFFER
        CURSOR=${#LBUFFER}
    fi
}

history-substring-search-down() {
    BUFFER=${(M)history[(ie)$BUFFER]}[-1]
    if [[ -n "$BUFFER" ]]; then
        LBUFFER=$BUFFER
        CURSOR=${#LBUFFER}
    fi
}

# Register ZLE widgets
zle -N history-substring-search-up
zle -N history-substring-search-down

# Bind the custom functions to the up and down arrow keys
bindkey '^[[A' history-substring-search-up  # Up arrow
bindkey '^[[B' history-substring-search-down  # Down arrow


# Completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive completion

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Load plugins
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/powerlevel9k/powerlevel9k.zsh-theme

# Functions
zsh_wifi_signal(){
    local signal=$(nmcli device wifi | grep yes | awk '{print $8}')
    local color='%F{yellow}'
    [[ $signal -gt 75 ]] && color='%F{green}'
    [[ $signal -lt 50 ]] && color='%F{red}'
    echo -n "%{$color%}\uf230  $signal%{%f%}" # \uf230 is 
}

# Powerlevel9k theme configuration
POWERLEVEL9K_OS_ICON='\uF17C'  # Set Linux icon
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_os_icon custom_wifi_signal battery dir vcs virtualenv custom_wifi_signal)
POWERLEVEL9K_CONTEXT_TEMPLATE=""
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_HOST_ICON="\uF109 "
POWERLEVEL9K_SSH_ICON="\uF489 "

# Custom OS icon segment
POWERLEVEL9K_CUSTOM_OS_ICON='echo -n "\uF17C"'
POWERLEVEL9K_CUSTOM_OS_ICON_BACKGROUND='white'
POWERLEVEL9K_CUSTOM_OS_ICON_FOREGROUND='black'

# Additional useful aliases
alias ll='ls -lah'
alias update='sudo apt update && sudo apt upgrade -y'
alias zshconfig="vim ~/.zshrc"

# Enable command-not-found if available
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi
