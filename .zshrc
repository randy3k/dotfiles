# alias
[[ -e ~/.alias ]] && emulate sh -c 'source ~/.alias'

# case insensitive
unsetopt CASE_GLOB

# prevent zsh to print an error when no match can be found
unsetopt nomatch

# enable i-search
stty -ixon -ixoff

# history
setopt share_history
setopt inc_append_history
export HISTSIZE=2000
export HISTFILE="$HOME/.zhistory"
export SAVEHIST=$HISTSIZE

# keybind
bindkey "^[[3~" delete-char
autoload -U select-word-style
select-word-style bash

# disable redo command r
disable r

# color
export CLICOLOR=1
LS_COLORS='di=34:fi=0:ln=35:pi=36;1:so=33;1:bd=0:cd=0:or=35;4:mi=0:ex=31:su=0;7;31:*.rpm=90'

# syntax highlight
if [[ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# add zsh-completions of homebrew
fpath=(/usr/local/share/zsh-completions $fpath)

# compsys initialization
# setopt noautomenu
# setopt nomenucomplete
setopt nolistambiguous
setopt correct
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")';

zstyle -s ':completion:*:hosts' hosts _ssh_config
if [[ -r ~/.ssh/config ]]; then
    _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p'))
    _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/^[ ]*HostName[=\t ]//p'))
fi
zstyle ':completion:*:hosts' hosts $_ssh_config


# pyenv completion
if [[ -f /usr/local/opt/pyenv/completions/pyenv.zsh ]]; then
    source /usr/local/opt/pyenv/completions/pyenv.zsh
fi

# rbenv completion
if [[ -f /usr/local/opt/rbenv/completions/rbenv.zsh ]]; then
    source /usr/local/opt/rbenv/completions/rbenv.zsh
fi

# PS1
function git-branch-name
{
    echo `git symbolic-ref HEAD --short 2> /dev/null ||
    (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/.*(detached from \(.*\))/\1/')`
}

function git-dirty
{
    st=$(git status 2>/dev/null | tail -n 1)
    if [[ ! $st =~ "working directory clean" ]]
    then
        echo "*"
    fi
}

function git-unpushed
{
    brinfo=`git branch -v | grep "$(git-branch-name)"`
    if [[ $brinfo =~ ("behind "([[:digit:]]*)) ]]
    then
        echo -n "-${match[2]}"
    fi
    if [[ $brinfo =~ ("ahead "([[:digit:]]*)) ]]
    then
        echo -n "+${match[2]}"
    fi
}

function gitify
{
    st=$(git status 2>/dev/null | head -n 1)
    if [[ ! $st == "" ]]
    then
        local dirty=$(git-dirty)
        local unpushed=$(git-unpushed)
        if [[ $dirty == "*" ]]; then
            echo -en " %{$fg[red]%}"
        elif [[ $unpushed != "" ]]; then
            echo -en " %{$fg[yellow]%}"
        else
            echo -en " %{$fg[green]%}"
        fi
        echo -en "($(git-branch-name)$dirty$unpushed)%{$reset_color%}"
    fi
}

autoload -U colors && colors
setopt prompt_subst
PROMPT='%{$fg[yellow]%}(%m)%{$reset_color%}-%c%{$reset_color%}$ '
RPROMPT='$(gitify)'

update_terminal_cwd()
{
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]0;\a'
    printf '\e]1;%s\a' `basename $PWD`
    printf '\e]7;%s\a' "$PWD_URL"
}

autoload -U add-zsh-hook
add-zsh-hook precmd  update_terminal_cwd
