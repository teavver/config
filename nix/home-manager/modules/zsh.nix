{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
      ];
    };

    shellAliases = {
      t = "thunar";
      oldsw = "home-manager switch -b backup";
      s = "home-manager switch --flake ~/.config/home-manager -b backup";
      sw = "s";
      u = "paru -Syu --noconfirm --skipreview && sudo pacman -Syu --noconfirm";
      clip = "xclip -selection clipboard";
      python = "python3";
      conf = "vim ~/.config/home-manager/home.nix";
      zed = "editor zeditor";
      code = "editor code";
      copy = "xclip -selection clipboard";
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
          if command -v smug &> /dev/null && [ -f ~/.config/smug/main.yml ]; then
            smug start main -a
          else
            tmux new-session -A -s 1
          fi
        fi
      fi

      # fzf key bindings for Ctrl-R history search
      if command -v fzf &> /dev/null; then
        source <(fzf --zsh)
      fi

      forgejo-setup() {
        local repo_name=$(basename $(git remote get-url origin) .git)
        local user=$(git remote get-url origin | sed -n 's|.*github.com[:/]\([^/]*\)/.*|\1|p')
        local forgejo_url="ssh://forgejo@t520-nixos:2222/''${user}/''${repo_name}.git"
        local origin_url=$(git remote get-url origin)
        if ! git remote | grep -qx forgejo; then
          git remote add forgejo "$forgejo_url"
        else
          git remote set-url forgejo "$forgejo_url"
        fi
        git remote set-url --push origin "$origin_url"
        git remote set-url --add --push origin "$forgejo_url"
        echo "forgejo enabled for ''${repo_name}"
      }

      x-paste() {
        local clip
        clip=$(xsel --clipboard --output 2>/dev/null || echo -n "")
        LBUFFER="$LBUFFER$clip"
      }
      zle -N x-paste
      bindkey '^V' x-paste

      x-cut-line() {
        echo -n "$BUFFER" | clipcopy
        BUFFER=""
        CURSOR=0
      }
      zle -N x-cut-line
      bindkey '^U' x-cut-line

      bindkey '^Z' undo
      bindkey '^Y' redo

      bindkey '^F' forward-word
      ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-word)

      bindkey '^H' backward-kill-word
      bindkey '^[[A' history-beginning-search-backward
      bindkey '^K' history-beginning-search-backward
      bindkey '^[[B' history-beginning-search-forward
      bindkey '^J' history-beginning-search-forward

      if command -v zoxide &> /dev/null; then
        eval "$(zoxide init zsh)"
        alias cd='z'
      fi

      editor() {
        local cmd="$1"
        shift
        if [ $# -eq 0 ]; then
          command "$cmd" .
        else
          command "$cmd" "$@"
        fi
      }

      zenmode() {
        local config="$HOME/.config/ghostty/config"
        if grep -q 'window-padding-x = 220' "$config"; then
          sed -i 's/window-padding-x = 220/window-padding-x = 0/' "$config"
        else
          sed -i 's/window-padding-x = 0/window-padding-x = 220/' "$config"
        fi
        pkill -USR2 ghostty
      }

      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' list-colors ""

      unsetopt BEEP
      PROMPT='%F{green}%n@%m%f:%F{cyan}%3~%f $(git_prompt_info)%(?:%F{green}> :%F{red}> )%f'
    '';
  };
}
