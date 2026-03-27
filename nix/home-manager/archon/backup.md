nix-collect-garbage

sudo nix-collect-garbage --delete-older-than 2d

eval $(ssh-agent)

ssh-add /home/teaver/.ssh/id_ed25519

sudo --preserve-env=SSH_AUTH_SOCK btrbk --progress run