# interactive shell only
[[ ! $- == *i* ]] && return

# enable i-search
stty -ixon -ixoff

# bash completion

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

[[ -f /usr/local/etc/bash_completion.d/git-completion.bash ]] && source /usr/local/etc/bash_completion.d/git-completion.bash
[[ -f /opt/local/etc/bash_completion.d/git-completion.bash ]] && source /opt/local/etc/bash_completion.d/git-completion.bash
if [[ $BASH_VERSION >4.2 ]]; then
    [[ -f /usr/local/etc/bash_completion.d/R ]] && source /usr/local/etc/bash_completion.d/R
fi
[[ -f /usr/local/etc/bash_completion.d/tmux ]] && source /usr/local/etc/bash_completion.d/tmux

# added by travis gem
[ -f /Users/Randy/.travis/travis.sh ] && source /Users/Randy/.travis/travis.sh

# alias
[ -f ~/.alias ] && source ~/.alias


# color
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad

# PS1
function git-branch-name {
    echo `git symbolic-ref HEAD --short 2> /dev/null || (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/.*(\(.*\))/\1/')`
}
function git-dirty {
    st=$(git status 2>/dev/null | tail -n 1)
    if [[ ! $st =~ "working directory clean" ]]
    then
        echo "*"
    fi
}
function git-unpushed {
    brinfo=`git branch -v | grep "$(git-branch-name)"`
    if [[ $brinfo =~ ("ahead "([[:digit:]]*)) ]]
    then
        echo -n "+${BASH_REMATCH[2]}"
    fi
    if [[ $brinfo =~ ("behind "([[:digit:]]*)) ]]
    then
        echo -n "-${BASH_REMATCH[2]}"
    fi
}
function gitcolor {
    st=$(git status 2>/dev/null | head -n 1)
    if [[ ! $st == "" ]]
    then
        if [[ $(git-dirty) == "*" ]];
        then
            echo -e "\033[31m"
        else
            echo -e "\033[32m"
        fi
    fi
}
function gitify {
    st=$(git status 2>/dev/null | head -n 1)
    if [[ ! $st == "" ]]
    then
        echo -e " ($(git-branch-name)$(git-dirty)$(git-unpushed))"
    fi
}

PS1="\[\033[33m\](\h)\[\033[00m\]-\W\[\$(gitcolor)\]\$(gitify)\[\033[00m\]\$ "
# reset title
PS1='\[\e]0;\a\]'"$PS1"
