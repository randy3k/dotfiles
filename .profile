if [[ -d "$HOME/.local/bin" ]] && [[ ! "$PATH" =~ "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

[[ -f ~/.profile.local ]] && . ~/.profile.local
