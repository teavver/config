
if command -v tmux &> /dev/null && [[ -z "$TMUX" ]]; then
  tmux new-session -A -s 1
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt prompt_subst
PROMPT='%n@%m:%F{cyan}%~%f%F{243}${vcs_info_msg_0_}%f$ '

export EDITOR='vim'
export CLICOLOR=1
export TERM=screen-256color
unset zle_bracketed_paste

alias code="code ."
bindkey '^K' up-line-or-history
bindkey '^J' down-line-or-history

export FZF_DEFAULT_OPTS='--tmux --layout=reverse'
export FZF_COMPLETION_TRIGGER='ff'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow,hidden'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.13/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source <(fzf --zsh)
