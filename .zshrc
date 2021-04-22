# aliases
[[ -e ~/.aliases ]] && emulate sh -c 'source ~/.aliases'

export GPG_TTY=$(tty)

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
if [[ -d /usr/local/share/zsh-syntax-highlighting ]]; then
    export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# history-substring-search
if [[ -d /usr/local/share/zsh-history-substring-search ]]; then
    source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
    export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=
fi

# # zsh-completions
if [[ -d  /usr/local/share/zsh-completions ]]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
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

# pyenv completion
if [[ -f /usr/local/opt/pyenv/completions/pyenv.zsh ]]; then
    source /usr/local/opt/pyenv/completions/pyenv.zsh
fi

# rbenv completion
if [[ -f /usr/local/opt/rbenv/completions/rbenv.zsh ]]; then
    source /usr/local/opt/rbenv/completions/rbenv.zsh
fi

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

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
figify() {
    [[ "$PWD" =~ "(/Volumn)?/google/src/cloud/.*"  ]] || return

    local st
    local cl
    local client
    local dirty
    local unpushedt

    st=$(hg st 2>/dev/null)
    client=`echo $PWD | sed "s|.*$USER/\([^/]*\).*|\1|"`
    cl=$(hg exportedcl)
    if [[ "$st" != "" ]]; then
        dirty="*"
    elif [[ "$cl" != "" ]] && [[ $(hg ll -r .) =~ "will update" ]]; then
        unpushed="true"
    fi
    [[ "$cl" = "" ]] || cl="%{$fg[yellow]%}[http://cl/$cl]"

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
        printf "%s" "$(gitify)$(figify)" > "/tmp/zsh_prompt_$$"
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

# g specific
if [ $(hostname) =~ "randylai-macbookpro.*" ]; then
    PROMPT='%{$fg[yellow]%}(=)%{$reset_color%}-%c%{$reset_color%}$ '
fi
