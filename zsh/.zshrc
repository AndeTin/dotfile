eval "$(starship init zsh)"

plugins=(git)
source <(fzf --zsh)

alias ll='ls -lAh --color=auto'
alias vim='nvim'
alias zen='zen-browser'
alias nvimf='nvim $(fzf --preview="bat --color=always {}")'

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
