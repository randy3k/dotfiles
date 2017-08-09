# alias
[[ -e ~/.aliases ]] && emulate sh -c 'source ~/.aliases'

unsetopt case_glob          # case insensitive
unsetopt nomatch            # prevent zsh to print an error when no match can be found
disable r                   # disable redo command r
stty -ixon -ixoff           # enable i-search
setopt autopushd

# history
export HISTSIZE=20000
export HISTFILE="$HOME/.zhistory"
export SAVEHIST=$HISTSIZE
setopt extendedhistory      # save timestamps in history
setopt no_histbeep          # don't beep for erroneous history expansions
setopt histignoredups       # ignore consecutive dups in history
setopt histfindnodups       # backwards search produces diff result each time
setopt histreduceblanks     # compact consecutive white space chars (cool)
setopt histnostore          # don't store history related functions
setopt incappendhistory     # incrementally add items to HISTFILE
# setopt histverify           # confirm !: or ^ command results before execution
# setopt share_history        # share history between sessions ???

# keybind
bindkey -e  # emacs mode
bindkey "^[[3~" delete-char
bindkey "∫" backward-word
bindkey "ƒ" forward-word
autoload -U select-word-style
select-word-style bash  # word characters are alphanumerics only

# bash like ctrl d
setopt ignoreeof  
bindkey "^d"  bash-ctrl-d
zle -N bash-ctrl-d
bash-ctrl-d()
{
    if [[ $CURSOR == 0 && -z $BUFFER ]]
    then
        [[ -z $IGNOREEOF || $IGNOREEOF == 0 ]] && exit
        [[ -z $__BASH_IGNORE_EOF ]] && (( __BASH_IGNORE_EOF = IGNOREEOF ))
        if [[ $LASTWIDGET == "bash-ctrl-d" ]]
        then
            [[ $__BASH_IGNORE_EOF -le 0 ]] && exit
        else
            (( __BASH_IGNORE_EOF = IGNOREEOF ))
        fi
        (( __BASH_IGNORE_EOF = __BASH_IGNORE_EOF - 1 ))
        echo -n Use \"exit\" to leave the shell.
        zle send-break
    else
        zle delete-char-or-list
    fi
}
export IGNOREEOF=1
autoload -U send-break
autoload -U delete-char-or-list

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# color
autoload -U colors
colors
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.rpm=90'

# syntax highlight
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# history-substring-search
source /usr/local/opt/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^K' history-substring-search-up
bindkey '^J' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=

# zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# conda-zsh-completion
fpath=(/Users/Randy/.zsh-conda-completion  $fpath)
zstyle ':completion::complete:*' use-cache 1

# compsys initialization
autoload -U compinit
compinit
# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

_users=($(dscl . list /Users | grep -v '^_'))
zstyle ':completion:*' users $_users
# retrieve exixsting hosts
zstyle -s ':completion:*:hosts' hosts _ssh_config
if [[ -r ~/.ssh/config ]]; then
    _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/^Host[=\t ]*//p' | grep '^[a-zA-Z]'))
    _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/^[\t ]*HostName[=\t ]*//p'))
fi
zstyle ':completion:*' hosts $_ssh_config

# pyenv completion
if [[ -f /usr/local/opt/pyenv/completions/pyenv.zsh ]]; then
    source /usr/local/opt/pyenv/completions/pyenv.zsh
fi

# rbenv completion
if [[ -f /usr/local/opt/rbenv/completions/rbenv.zsh ]]; then
    source /usr/local/opt/rbenv/completions/rbenv.zsh
fi

# added by travis gem
[ -f /Users/Randy/.travis/travis.sh ] && source /Users/Randy/.travis/travis.sh

# prompt
gitify() {
    st=$(git status -b --porcelain 2>/dev/null)
    [[ $? -eq 0 ]] || return

    local branch
    local dirty
    local unpushed

    branch=`git symbolic-ref HEAD --short 2> /dev/null || (git branch | sed -n 's/\* (*\([^)]*\))*/\1/p')`
    [[ `wc -l <<< "$st"` -eq 1  ]] || dirty="*"
    [[ "$st" =~ ("behind "([[:digit:]]*)) ]] && unpushed="-${match[2]}"
    [[ "$st" =~ ("ahead "([[:digit:]]*)) ]] && unpushed="$unpushed+${match[2]}"

    if [[ $dirty == "*" ]]; then
        echo -en " %{$fg[red]%}"
    elif [[ $unpushed != "" ]]; then
        echo -en " %{$fg[yellow]%}"
    else
        echo -en " %{$fg[green]%}"
    fi
    echo -en "($branch$dirty$unpushed)%{$reset_color%}"
}
setopt prompt_subst
PROMPT='%{$fg[yellow]%}(%m)%{$reset_color%}-%c%{$reset_color%}$ '
RPROMPT='$(gitify)'

if ([ "$TERM_PROGRAM" = "iTerm.app" ] || [ "$TERM_PROGRAM" = "Apple_Terminal" ]) && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        local SEARCH=' '
        local REPLACE='%20'
        local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
        printf '\e]0;\a'
        printf '\e]1;%s\a' `basename $PWD`
        printf '\e]7;%s\a' "$PWD_URL"
    }
    autoload -U add-zsh-hook
    add-zsh-hook precmd  update_terminal_cwd
fi
