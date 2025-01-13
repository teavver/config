
if command -v tmux >/dev/null; then
    [ -z "$TMUX" ] && (tmux attach || exec tmux new-session)
else
    echo "[!] tmux is not installed"
fi

alias ls="ls --color"
alias ll="ls --color -lh"
alias la="ls --color -a"
export PS1='\u@\h:$(git rev-parse --abbrev-ref HEAD 2>/dev/null | sed "s/^/(/;s/$/)/")\[\e[36m\]\w\[\e[0m\]\$ '
export EDITOR='vim'
export CLICOLOR=1
stty -ixon

export PATH="$PATH:$HOME/.rvm/bin"
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"

export PATH="/opt/homebrew/bin:$PATH"
