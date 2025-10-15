
if status is-interactive

    cd $HOME

    if type -q tmux
        if not set -q TMUX
            tmux new-session -A -s 1
        end
    end

    # alias
    function code
        command code .
    end

    function ls
        command ls -G $argv
    end

    function rebuild
        command sudo darwin-rebuild switch --flake /etc/nix-darwin#prism $argv
    end

    function rmq
        command docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:4-management
    end

    function accept_suggestion
        commandline -f accept-autosuggestion
    end

    # misc
    abbr --add cd z

    # Keybindings
    bind \t complete
    bind \cE accept_suggestion
    bind \ck up-or-search
    bind \cj down-or-search

    zoxide init fish | source


end
