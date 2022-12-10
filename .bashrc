#
# ~/.bashrc
#

[ -z "$TMUX"  ] && { tmux attach || exec tmux new-session;}

alias ls="ls --color"
alias ll="ls --color -lh"
alias la="ls --color -a"
export BASH_SILENCE_DEPRECATION_WARNING=1
export PS1='\u@\h:\[\e[01;32m\]\w\[\e[0m\]\$ '
export EDITOR='vim'
export CLICOLOR=1
stty -ixon
