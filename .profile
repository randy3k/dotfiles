if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
[ -d "$HOME/Library/Haskell/bin" ] && export PATH="$HOME/Library/Haskell/bin:$PATH"
[ -d /usr/local/cuda/bin ] && export PATH="/usr/local/cuda/bin:$PATH"
[ -d /usr/local/opt/go/libexec/bin ] && export PATH="/usr/local/opt/go/libexec/bin:$PATH"
# [ -d /usr/local/opt/llvm/bin ] && export PATH="/usr/local/opt/llvm/bin:$PATH"

# FSL Setup
FSLDIR=/opt/local/fsl
if [ -d "$FSLDIR" ]; then
    PATH=${FSLDIR}/bin:${PATH}
    export FSLDIR PATH
    . ${FSLDIR}/etc/fslconf/fsl.sh
fi

# EDITOR
export HOMEBREW_EDITOR='subl -n'
export JULIA_EDITOR='subl -n'
export GIT_EDITOR='nvim'
# export EDITOR='nvim'

# homebrew github token
[ -f ~/.config/homebrew ] && . ~/.config/homebrew

# hub alias
eval "$(hub alias -s)"

# homebrew python
# export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# GPG
export GPG_TTY=$(tty)

# miniconda
export PATH="/Users/Randy/miniconda3/bin:$PATH"

# alias subl for ssh client
if ([[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]) && [[ -n `command -v rmate` ]]; then
    alias subl=$(command -v rmate)
    export RMATE_PORT=52658
fi
