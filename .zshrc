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
# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
bindkey '^T' autosuggest-toggle


# disable redo command r
disable r

# color
export CLICOLOR=1
LS_COLORS='di=34:fi=0:ln=35:pi=36;1:so=33;1:bd=0:cd=0:or=35;4:mi=0:ex=31:su=0;7;31:*.rpm=90'

# syntax highlight
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions
# source /Users/Randy/.zsh-autosuggestions/autosuggestions.zsh
# zle-line-init() {
#     zle autosuggest-start
# }
# zle -N zle-line-init

# history-substring-search
source /usr/local/opt/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=


# add zsh-completions of homebrew
fpath=(/usr/local/share/zsh-completions $fpath)

# compsys initialization
# setopt noautomenu
# setopt nomenucomplete
setopt nolistambiguous
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
git-branch-name()
{
    echo `git symbolic-ref HEAD --short 2> /dev/null ||
    (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/.*(detached from \(.*\))/\1/')`
}

git-dirty()
{
    st=$(git status 2>/dev/null | tail -n 1)
    if [[ ! $st =~ "working directory clean" ]]
    then
        echo "*"
    fi
}

git-unpushed()
{
    brinfo=`git branch -v | grep "* $(git-branch-name)"`
    if [[ $brinfo =~ ("behind "([[:digit:]]*)) ]]
    then
        echo -n "-${match[2]}"
    fi
    if [[ $brinfo =~ ("ahead "([[:digit:]]*)) ]]
    then
        echo -n "+${match[2]}"
    fi
}

gitify()
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

update_terminal_cwd()
{
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]0;\a'
    printf '\e]1;%s\a' `basename $PWD`
    printf '\e]7;%s\a' "$PWD_URL"
}

autoload -U colors && colors
setopt prompt_subst
PROMPT='%{$fg[yellow]%}(%m)%{$reset_color%}-%c%{$reset_color%}$ '
RPROMPT='$(gitify)'
autoload -U add-zsh-hook
add-zsh-hook precmd  update_terminal_cwd

