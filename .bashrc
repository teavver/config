
if command -v tmux >/dev/null; then
    [ -z "$TMUX" ] && (tmux attach || exec tmux new-session)
else
    echo "[!] tmux is not installed"
fi

alias ls="ls --color"
alias ll="ls --color -lh"
alias la="ls --color -a"
export PS1='\u@\h:\[\e[38;5;61m\]\w\[\e[0m\]\$ '
export EDITOR='vim'
export CLICOLOR=1
stty -ixon

export NVM_DIR="$HOME/.nvm"