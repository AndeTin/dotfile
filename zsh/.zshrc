eval "$(starship init zsh)"

plugins=(git)

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# source ~/.zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# 🛠 Fix broken default keymap
bindkey -e   # use Emacs-style bindings (standard terminal behavior)

# Rebind essential cursor movement shortcuts
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^U' backward-kill-line
bindkey '^K' kill-line
bindkey '^Y' yank
bindkey '^W' backward-kill-word
bindkey '^H' backward-delete-char
bindkey '^?' backward-delete-char
bindkey '^D' delete-char
bindkey '^B' backward-char
bindkey '^F' forward-char
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^R' history-incremental-search-backward
bindkey '^[[3~' delete-char

GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
export XCURSOR_SIZE=40
export XCURSOR_THEME="Bibata-Modern-Ice"
export SYSTEMD_EDITOR=nvim

alias ls='eza -F --color=always --icons=always'
alias ll='eza -al'
alias vim='nvim'
alias cat='bat'
alias zen='zen-browser'
alias nvimf='nvim $(fzf --preview="bat --color=always {}")'
alias lg='lazygit'
alias ld='lazydocker'

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BAT_THEME="Catppuccin Mocha"
export EDITOR='nvim'

export _ZO_DATA_DIR="/home/jc/.local/share"
export _ZO_ECHO="1"
export _ZO_MAXAGE="100"
export _ZO_RESOLVE_SYMLINKS="1"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

eval "$(zoxide init zsh)"

echo "Welcome back 🚀!"
fastfetch
