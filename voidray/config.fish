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

    # temp
    alias kconf="vim ~/.config/kitty/kitty.conf"
    alias fconf="vim ~/.config/fish/config.fish"
    alias iconf="vim ~/.config/i3/config"

    function rmq
        command docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:4-management
    end

    # misc
    abbr --add cd z

    # Keybindings
    bind \cH backward-kill-word
    bind \ck up-or-search
    bind \cj down-or-search

    zoxide init fish | source

    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


end