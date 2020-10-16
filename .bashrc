# interactive shell only
[[ ! $- == *i* ]] && return

[[ -f ~/.bashrc.d/init.bashrc ]] && . ~/.bashrc.d/init.bashrc
