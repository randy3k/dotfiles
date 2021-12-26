# # miniconda

export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/sbin:$PATH
# [ -d /usr/local/Caskroom/miniconda ] && export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
[ -d "$HOME/Library/Haskell/bin" ] && export PATH="$HOME/Library/Haskell/bin:$PATH"
[ -d /usr/local/cuda/bin ] && export PATH="/usr/local/cuda/bin:$PATH"
[ -d /usr/local/opt/go/libexec/bin ] && export PATH="/usr/local/opt/go/libexec/bin:$PATH"
[ -d $HOME/go/bin ] && export PATH="$HOME/go/bin:$PATH"
# [ -d /usr/local/opt/llvm/bin ] && export PATH="/usr/local/opt/llvm/bin:$PATH"
# note: .local/bin should be added at last
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"


# EDITOR
export HOMEBREW_EDITOR='subl -n'
export JULIA_EDITOR='subl -n'
export GIT_EDITOR='nvim'
# export EDITOR='nvim'

# homebrew github token
[ -f ~/.config/secrets ] && . ~/.config/secrets

# hub alias
eval "$(hub alias -s)"

# GPG
if [ -t 1 ] ; then
    if [[ -z "$SSH_AUTH_SOCK" ]] && [[ -n `command -v gpgconf` ]]; then
        export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    fi
    export GPG_TTY=$(tty)
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]] ;then
        export PINENTRY_USER_DATA="USE_CURSES=1"
    fi
fi

# alias subl for ssh client
if ([[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]) && [[ -n `command -v rmate` ]]; then
    alias subl=$(command -v rmate)
    export RMATE_PORT=52658
fi

# ## Xcode
# help python to find the C headers
# export MACOSX_DEPLOYMENT_TARGET=10.9
# export CPATH=`xcrun --show-sdk-path`/usr/include
