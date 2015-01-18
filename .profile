export PATH=/usr/local/cuda/bin:/opt/local/bin:/opt/local/sbin:$PATH

# FSL Setup
FSLDIR=/opt/local/fsl
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH
. ${FSLDIR}/etc/fslconf/fsl.sh

#pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

#rbenv setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# for neovim
export VIMRUNTIME=/usr/local/opt/vim/share/vim/vim74/

# homebrew github token
source ~/.gittoken
