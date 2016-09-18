# interactive shell only
[[ ! $- == *i* ]] && return

# enable i-search
stty -ixon -ixoff

# keybinds
bind '"\C-f": forward-word'
bind '"\C-b": backward-word'

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
    st=$(git status 2>/dev/null | tail -n 1)
    if [[ ! $st =~ "working directory clean" ]]
    then
        echo "*"
    fi
}
function git-unpushed {
    brinfo=`git branch -v | grep "$(git-branch-name)"`
    if [[ $brinfo =~ ("behind "([[:digit:]]*)) ]]
    then
        echo -n "-${BASH_REMATCH[2]}"
    fi
    if [[ $brinfo =~ ("ahead "([[:digit:]]*)) ]]
    then
        echo -n "+${BASH_REMATCH[2]}"
    fi
}
function gitcolor {
    st=$(git status 2>/dev/null | head -n 1)
    if [[ ! $st == "" ]]
    then
        if [[ $(git-dirty) == "*" ]];
        then
            echo -e "\033[31m"
        elif [[ $(git-unpushed) != "" ]];
        then
            echo -e "\033[33m"
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
