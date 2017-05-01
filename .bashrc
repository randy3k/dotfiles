# interactive shell only
[[ ! $- == *i* ]] && return


# enable i-search
stty -ixon -ixoff

# keybinds
bind '"\C-f": forward-word'
bind '"\C-b": backward-word'
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

if [[ $TERM_PROGRAM = "Apple_Terminal" ]]; then
    PS1='\[\e]0;\a\]'"$PS1"

elif [[ "$TERM_PROGRAM" = "iTerm.app" ]]; then
    function iterm2_print_user_vars {
        printf '\e]1;%s\a' `basename $PWD`
    }
    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
