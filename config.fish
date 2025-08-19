
if status is-interactive
    if type -q tmux
        if not set -q TMUX
            tmux new-session -A -s 1
        end
    end

    # ---
    function code
        command code .
    end
    function ls
        command gls --color=auto $argv
    end
    function rebuild
        command sudo darwin-rebuild switch --flake /etc/nix-darwin#prism $argv
    end
    # ---

    # Keybindings
    bind \t accept-autosuggestion
    bind \ck up-or-search
    bind \cj down-or-search

end
