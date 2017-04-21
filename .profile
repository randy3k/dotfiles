if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

[ -d /usr/local/cuda/bin ] && export PATH=/usr/local/cuda/bin:$PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
[ -d /usr/local/opt/go/libexec/bin ] && export PATH=$PATH:/usr/local/opt/go/libexec/bin
# FSL Setup
FSLDIR=/opt/local/fsl
if [ -d "$FSLDIR" ]; then
    PATH=${FSLDIR}/bin:${PATH}
    export FSLDIR PATH
    . ${FSLDIR}/etc/fslconf/fsl.sh
fi

# EDITOR
export HOMEBREW_EDITOR='subl -w'
export JULIA_EDITOR='subl -w'
export GIT_EDITOR='nvim'
export EDITOR='nvim'

# homebrew github token
[ -f ~/.config/homebrew ] && . ~/.config/homebrew

# hub alias
eval "$(hub alias -s)"

# miniconda
export PATH="/Users/Randy/miniconda3/bin:$PATH"
