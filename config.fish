
if status is-interactive

    cd $HOME

    if type -q tmux
        if not set -q TMUX
            tmux new-session -A -s 1
        end
    end

    function code
        command code .
    end
    function ls
        command ls -G $argv
    end

    function rebuild
        command sudo darwin-rebuild switch --flake /etc/nix-darwin#prism $argv
    end

    function accept_suggestion
        commandline -f accept-autosuggestion
    end

    # Keybindings
    bind \t complete
    bind \cE accept_suggestion
    bind \ck up-or-search
    bind \cj down-or-search

end
