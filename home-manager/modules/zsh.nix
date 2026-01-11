{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
      ];
    };
    
    shellAliases = {
      python = "python3";
      sw = "home-manager switch -b backup";
      conf = "vim ~/.config/home-manager/home.nix";
    };
    
    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
    
    initContent = ''
      if command -v tmux &> /dev/null; then
        if [ -z "$TMUX" ]; then
          cd $HOME
          tmux new-session -A -s 1
        fi
      fi
      
      cd $HOME
      
      # fzf key bindings for Ctrl-R history search
      if command -v fzf &> /dev/null; then
        source <(fzf --zsh)
      fi
      
      x-paste() {
        local clip
        clip=$(xsel --clipboard --output 2>/dev/null || echo -n "")
        LBUFFER="$LBUFFER$clip"
      }
      zle -N x-paste
      bindkey '^V' x-paste
      
      bindkey '^H' backward-kill-word
      bindkey '^[[A' history-beginning-search-backward
      bindkey '^K' history-beginning-search-backward
      bindkey '^[[B' history-beginning-search-forward
      bindkey '^J' history-beginning-search-forward
      
      if command -v zoxide &> /dev/null; then
        eval "$(zoxide init zsh)"
        alias cd='z'
      fi
      
      code() {
        if [ $# -eq 0 ]; then
          command code .
        else
          command code "$1"
        fi
      }
      
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' list-colors ""
      
      unsetopt BEEP
      PROMPT='%F{green}%n@%m%f:%F{cyan}%3~%f $(git_prompt_info)%(?:%F{green}> :%F{red}> )%f'
    '';
  };
}
