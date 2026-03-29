# aliases
[[ -e ~/.aliases ]] && . ~/.aliases
[[ -e ~/.aliases_local ]] && . ~/.aliases_local

# enable i-search
stty -ixon -ixoff

# keybinds
# substring search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[1;9D": backward-word'
bind '"\e[1;9C": forward-word'
bind '"\e[1;3D": backward-word'
bind '"\e[1;3C": forward-word'

# ignore ctrl-d
IGNOREEOF=1

# bash completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set colored-stats on"
bind "set colored-completion-prefix on"
bind TAB:menu-complete

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
if [[ -f /usr/local/opt/git/share/git-core/contrib/completion/git-completion.bash ]]; then
    source /usr/local/opt/git/share/git-core/contrib/completion/git-completion.bash
fi
if [[ -f /opt/local/etc/bash_completion.d/git-completion.bash ]]; then
    source /opt/local/etc/bash_completion.d/git-completion.bash
fi
if [[ $BASH_VERSION > 4.2 ]]; then
    [[ -f /usr/local/etc/bash_completion.d/R ]] && source /usr/local/etc/bash_completion.d/R
fi
[[ -f /usr/local/etc/bash_completion.d/tmux ]] && source /usr/local/etc/bash_completion.d/tmux

# color
if [ "$(uname)" == "Darwin" ]; then
    export CLICOLOR=1
    export LSCOLORS=exfxcxdxbxegedabagacad
else
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.rpm=90:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:'
fi

# prompt
[[ -f ~/.vcs_prompt.sh ]] && source ~/.vcs_prompt.sh

function set_ps1 {
    local red="\001\e[31m\002"
    local green="\001\e[32m\002"
    local yellow="\001\e[33m\002"
    local reset="\001\e[00m\002"
    local vcs_info=$(vcs_prompt_info "$red" "$green" "$yellow" "$reset")$(citc_prompt_info "$red" "$green" "$yellow" "$reset")
    local cols=$(tput cols)
    if [ "$cols" -lt 30 ]; then
        PS1="\$ "
    elif [ "$cols" -lt 70 ]; then
        PS1="\W${vcs_info}\$ "
    else
        PS1="\[\033[33m\](\h)\[\033[00m\]-\W${vcs_info}\$ "
    fi
}

if [ "$(uname)" == "Darwin" ] && [ "$TERM" = "xterm-256color" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        local url_path=''
        {
            local i ch hexch LC_CTYPE=C LC_ALL=
            for ((i = 0; i < ${#PWD}; ++i)); do
            ch="${PWD:i:1}"
            if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
                url_path+="$ch"
            else
                printf -v hexch "%02X" "'$ch"
                # printf treats values greater than 127 as
                # negative and pads with "FF", so truncate.
                url_path+="%${hexch: -2:2}"
            fi
            done
        }
        printf '\e]0;\a'
        printf '\e]1;%s\a' `basename $PWD`
        printf '\e]7;%s\a' "file://$HOSTNAME$url_path"
    }
    PROMPT_COMMAND="set_ps1; update_terminal_cwd${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ] && [ "$TERM" == "xterm-256color" ]; then
    PROMPT_COMMAND='set_ps1; reset_terminal_title'

    function reset_terminal_title {
        printf "\033]0;%s\007" "${HOSTNAME%%.*}"
        printf '\033]7;\007'
    }
else
    PROMPT_COMMAND='set_ps1'
fi
