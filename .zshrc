# alias
[[ -e ~/.aliases ]] && emulate sh -c 'source ~/.aliases'



unsetopt CASE_GLOB          # case insensitive
unsetopt nomatch            # prevent zsh to print an error when no match can be found
setopt ignoreeof            # ignore EOF ('^D') (i.e. don't log out on it)
disable r                   # disable redo command r
stty -ixon -ixoff           # enable i-search

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
bindkey -e                # emacs mode
bindkey "^[[3~" delete-char
autoload -U select-word-style
select-word-style bash
bindkey "^d"  bash-ctrl-d

# bash like ctrl d
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
zle -N bash-ctrl-d

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

# syntax highlight
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions
# source /Users/Randy/.zsh-autosuggestions/autosuggestions.zsh
# zle-line-init() {
#     zle autosuggest-start
# }
# zle -N zle-line-init
# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
# bindkey '^T' autosuggest-toggle

# history-substring-search
source /usr/local/opt/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=

# conda-zsh-completion
fpath=(/Users/Randy/.zsh-conda-completion  $fpath)
zstyle ':completion::complete:*' use-cache 1

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
zstyle ':completion:*:hub:*' user-commands ${${(k)commands[(I)git-*]}#git-}
zstyle ':completion:*:git:*' user-commands ${${(k)commands[(I)git-*]}#git-}

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
gitify()
{
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

if [[ $TERM_PROGRAM = "Apple_Terminal" ]]; then
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

elif [[ "$TERM_PROGRAM" = "iTerm.app" ]]; then
    function iterm2_print_user_vars {
        printf '\e]1;%s\a' `basename $PWD`
    }
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi
