# ~/.bashrc
#
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

eval "$(starship init bash)"

alias ll="lsd -l"
alias l="lsd -l"
alias ls="lsd"
alias la="lsd -lA"
alias v="nvim"
alias sv="sudo nvim"

alias ccc="nvim $HOME/.config/hypr/hyprland.conf"
alias bbb="nvim $HOME/.bashrc"
#export GTK_THEME=catppuccin-mocha-lavender-standard+default

# If not running interactively, don't do anything

export PATH="$PATH:/home/paulo/development/sdk/flutter/bin"
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
