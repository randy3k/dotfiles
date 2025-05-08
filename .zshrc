# aliases
[[ -e ~/.aliases ]] && emulate sh -c 'source ~/.aliases'
[[ -e ~/.aliases_local ]] && emulate sh -c 'source ~/.aliases_local'

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
bindkey "\e[1;9C" forward-word
bindkey "\e[1;9D" backward-word
bindkey "\e[1;3C" forward-word
bindkey "\e[1;3D" backward-word
bindkey "\e[3~" delete-char
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
if [[ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# history-substring-search
if [[ -f ~/.zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source ~/.zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
    export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=
elif [[ -f $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
    export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=
fi

# # zsh-completions
if [[ -d  $HOMEBREW_PREFIX/share/zsh-completions ]]; then
    fpath=($HOMEBREW_PREFIX/share/zsh-completions $fpath)
fi

# conda-zsh-completion
if [[ -d  $HOME/.zsh-conda-completion ]]; then
    fpath=($HOME/.zsh-conda-completion  $fpath)
fi
zstyle ':completion::complete:*' use-cache 1

# compsys initialization
autoload -U compinit
compinit
# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

if [[ "$(uname)" == "Darwin" ]]; then
    _users=($(dscl . list /Users | grep -v '^_'))
else
    _users=($(cut -d: -f1 /etc/passwd))
fi
zstyle ':completion:*' users $_users
# retrieve exixsting hosts
zstyle -s ':completion:*:hosts' hosts _ssh_config
if [[ -r ~/.ssh/config ]]; then
    _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/^Host[=\t ]*//p' | grep '^[a-zA-Z]'))
    _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/^[\t ]*HostName[=\t ]*//p'))
fi
zstyle ':completion:*' hosts $_ssh_config

# piper
if [[ -f /etc/bash_completion.d/g4d ]]; then
  . /etc/bash_completion.d/p4
  . /etc/bash_completion.d/g4d
fi

# hgd completion
[ -f /etc/bash_completion.d/hgd ] && source /etc/bash_completion.d/hgd

# jjd completion
[ -f /etc/bash_completion.d/jjd ] && source /etc/bash_completion.d/jjd

# prompt
gitify() {
    local st
    local branch
    local dirty
    local unpushed

    st=$(git status -b --porcelain 2>/dev/null)
    [[ $? -eq 0 ]] || return

    branch=$(git symbolic-ref HEAD --short 2> /dev/null || (git branch | sed -n 's/\* (*\([^)]*\))*/\1/p'))
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
citcify() {
    [[ "$PWD" =~ "(/Volumes)?/google/src/cloud/$USER/.*"  ]] || return

    local jj_st
    local jj_st_code
    local fig_st
    local fig_st_code
    local client
    local dirty
    local unpushed

    client=$(echo $PWD | sed "s|\(/Volumes\)*/google/src/cloud/$USER/\([^/]*\).*|\2|")

    jj_st=$(jj st -R /google/src/cloud/$USER/$client --quiet 2>/dev/null)
    jj_st_code=$?
    fig_st=$(hg --cwd /google/src/cloud/$USER/$client st 2>/dev/null)
    fig_st_code=$?
    [[ $jj_st_code -eq 0 || $fig_st_code -eq 0 ]] || return

    if [[ $jj_st_code -eq 0 ]]; then
        if [[ ! $(echo "$jj_st" | head -n 1) =~ "The working copy has no changes." ]]; then
            dirty="*"
        elif [[ $(echo "$jj_st" | sed -n "s,^Parent.*cl/[0-9]*\(\*\).*,\1,p") == "*" ]]; then
            unpushed="true"
        fi
    else
        if [[ "$fig_st" != "" ]]; then
            dirty="*"
        elif [[ $(hg --cwd /google/src/cloud/$USER/$client ll -r . 2>/dev/null) =~ "will update" ]]; then
            unpushed="true"
        fi
    fi

    if [[ $dirty == "*" ]]; then
        echo -en " %{$fg[red]%}"
    elif [[ $unpushed = "true" ]]; then
        echo -en " %{$fg[yellow]%}"
    else
        echo -en " %{$fg[green]%}"
    fi
    echo -en "($client$dirty)$cl%{$reset_color%}"
}

setopt prompt_subst
PROMPT='%{$fg[yellow]%}(%m)%{$reset_color%}-%c%{$reset_color%}$ '
RPROMPT=''

# https://www.anishathalye.com/2015/02/07/an-asynchronous-shell-prompt/
ASYNC_PROC=0
RPROMPT_OLDPWD=''
function update_rprompt() {
    function async() {
        printf "%s" "$(gitify)$(citcify)" > "/tmp/zsh_prompt_$$"
        kill -s USR1 $$
    }
    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi
    if [[ $RPROMPT_OLDPWD != $PWD ]]; then
        RPROMPT=''
    fi
    RPROMPT_OLDPWD=$PWD
    async &!
    ASYNC_PROC=$!
}
autoload -U add-zsh-hook
add-zsh-hook precmd update_rprompt

function TRAPUSR1() {
    if [[ $LASTWIDGET != "bash-ctrl-d" ]]; then
        RPROMPT="$(cat /tmp/zsh_prompt_$$)"
        ASYNC_PROC=0
        zle && zle reset-prompt
    fi
}

if [ "$TERM" = "xterm-256color" ] && [ -z "$INSIDE_EMACS" ]; then
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

# local zshrc
[[ -e ~/.zshrc_local ]] && emulate sh -c 'source ~/.zshrc_local'
