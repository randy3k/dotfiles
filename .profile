[ -d /usr/local/cuda/bin ] && export PATH=/usr/local/cuda/bin:$PATH
export PATH=/opt/local/shell-script:/opt/local/bin:/opt/local/sbin:$PATH
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

#pyenv setup
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

#rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# homebrew github token
[ -f ~/.config/homebrew ] && source ~/.config/homebrew

# hub alias
eval "$(hub alias -s)"

# miniconda
export PATH="/Users/Randy/miniconda3/bin:$PATH"
