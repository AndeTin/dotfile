eval "$(starship init zsh)"

plugins=(git)
source <(fzf --zsh)
source ~/.zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls='eza -X --color=always --icons=always'
alias ll='eza -al'
alias vim='nvim'
alias cat='bat'
alias zen='zen-browser'
alias nvimf='nvim $(fzf --preview="bat --color=always {}")'

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BAT_THEME="Catppuccin Mocha"
export EDITOR='nvim'

export _ZO_DATA_DIR="/home/jc/.local/share"
export _ZO_ECHO="1"
export _ZO_MAXAGE="100"
export _ZO_RESOLVE_SYMLINKS="1"

eval "$(zoxide init zsh)"
eval $(thefuck --alias)

echo "Welcome back JC 🚀!"
fastfetch
