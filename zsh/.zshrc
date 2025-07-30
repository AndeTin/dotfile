eval "$(starship init zsh)"

plugins=(git)
source <(fzf --zsh)

alias ls='eza -X --color=always --icons=always'
alias ll='eza -al'
alias vim='nvim'
alias cat='bat'
alias zen='zen-browser'
alias nvimf='nvim $(fzf --preview="bat --color=always {}")'

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BAT_THEME="Catppuccin Mocha"

export _ZO_DATA_DIR="/home/jc/.local/share"
export _ZO_ECHO="1"
export _ZO_MAXAGE="100"
export _ZO_RESOLVE_SYMLINKS="1"


eval "$(zoxide init zsh)"
