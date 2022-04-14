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
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.rpm=90'
fi

# prompt
function git-branch-name {
    echo `git symbolic-ref HEAD --short 2> /dev/null || (git branch | sed -n 's/\* (*\([^)]*\))*/\1/p')`
}
function git-dirty {
    [[ `wc -l <<< "$1" ` -eq 1  ]] || echo "*"
}
function git-unpushed {
    if [[ "$1" =~ ("behind "([[:digit:]]*)) ]]
    then
        echo -n "-${BASH_REMATCH[2]}"
    fi
    if [[ "$1" =~ ("ahead "([[:digit:]]*)) ]]
    then
        echo -n "+${BASH_REMATCH[2]}"
    fi
}
function gitcolor {
    st=$(git status -b --porcelain 2>/dev/null)
    [[ $? -eq 0 ]] || return

    if [[ $(git-dirty "$st") == "*" ]];
    then
        echo -e "\033[31m"
    elif [[ $(git-unpushed "$st") != "" ]];
    then
        echo -e "\033[33m"
    else
        echo -e "\033[32m"
    fi
}
function gitify {
    st=$(git status -b --porcelain 2>/dev/null)
    [[ $? -eq 0 ]] || return
    dirty=$(git-dirty "$st")
    unpushed=$(git-unpushed "$st")
    echo -e " ($(git-branch-name)$dirty$unpushed)"
}

PS1="\[\033[33m\](\h)\[\033[00m\]-\W\[\$(gitcolor)\]\$(gitify)\[\033[00m\]\$ "

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
    PROMPT_COMMAND="update_terminal_cwd${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ] && [ "$TERM" == "xterm-256color" ]; then
    PROMPT_COMMAND='reset_terminal_title'

    function reset_terminal_title {
        printf "\033]0;%s\007" "${HOSTNAME%%.*}"
        printf '\033]7;\007'
    }
fi
