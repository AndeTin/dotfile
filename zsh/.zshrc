# --- Starship Prompt ---
eval "$(starship init zsh)"

# --- Znap Plugin Manager ---
[[ -r ~/Repos/znap/znap.zsh ]] || \
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh

# --- Zsh Plugins ---
source ~/Repos/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source ~/Repos/zsh-autoswitch-virtualenv/autoswitch_virtualenv.plugin.zsh
source ~/Repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- FZF Setup ---
plugins=(git fzf)

# --- Zoxide ---
eval "$(zoxide init zsh)"

# --- Custom Functions ---
zi() {
    cd "$(zoxide query -i)"
}
zle -N zi

# --- Key Bindings ---
bindkey -e   # Emacs-style bindings
# Cursor movement and editing
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
bindkey '^F' zi                # ^F now runs zi (overrides forward-char)
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^[[3~' delete-char
# bindkey '^I' menu-complete  # Disabled to allow fzf tab completion
bindkey "$terminfo[kcbt]" reverse-menu-complete

# --- Environment Variables ---
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='nvim'
export SYSTEMD_EDITOR='nvim'
export BAT_THEME="Catppuccin Mocha"
export XCURSOR_SIZE=40
export XCURSOR_THEME="Bibata-Modern-Ice"
# Input method modules
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
# Zoxide config
export _ZO_DATA_DIR="/home/jc/.local/share"
export _ZO_ECHO="0"
export _ZO_MAXAGE="100"
export _ZO_RESOLVE_SYMLINKS="1"

# --- FZF Options ---
export FZF_DEFAULT_OPTS=" \
--height 40% --reverse --border \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# --- Android SDK ---
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# --- Aliases ---
alias ls='eza -F --color=always --icons=always'
alias ll='eza -al'
alias vim='nvim'
alias cat='bat'
alias zen='zen-browser'
alias nvimf='nvim $(fzf --preview="bat --color=always {}")'
alias lg='lazygit'
alias ld='lazydocker'

# --- Welcome Message ---
echo "Welcome back 🚀!"
fastfetch

# --- FZF Integration (must be last for tab completion reliability) ---
source <(fzf --zsh)
