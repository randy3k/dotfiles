# interactive shell only
[[ ! $- == *i* ]] && return


# enable i-search
stty -ixon -ixoff

# keybinds
# substring search
bind '"\e[A": history-search-backward'
bind '"\e[B":history-search-forward'

# ignore ctrl-d
IGNOREEOF=1

# bash completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set colored-stats on"
bind "set colored-completion-prefix on"
bind TAB:menu-complete

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

if [[ -f /usr/local/opt/git/share/git-core/contrib/completion/git-completion.bash ]]; then
    source /usr/local/opt/git/share/git-core/contrib/completion/git-completion.bash
fi
if [[ -f /opt/local/etc/bash_completion.d/git-completion.bash ]]; then
    source /opt/local/etc/bash_completion.d/git-completion.bash
fi
if [[ $BASH_VERSION >4.2 ]]; then
    [[ -f /usr/local/etc/bash_completion.d/R ]] && source /usr/local/etc/bash_completion.d/R
fi
[[ -f /usr/local/etc/bash_completion.d/tmux ]] && source /usr/local/etc/bash_completion.d/tmux

# added by travis gem
[ -f /Users/Randy/.travis/travis.sh ] && source /Users/Randy/.travis/travis.sh

# aliases
[ -f ~/.aliases ] && source ~/.aliases

# color
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad

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

update_terminal_cwd() {
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]0;\a'
    printf '\e]1;%s\a' `basename $PWD`
    printf '\e]7;%s\a' "$PWD_URL"
}

if [ "$TERM_PROGRAM" = "iTerm.app" ] && [ -z "$INSIDE_EMACS" ]; then
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
fi
