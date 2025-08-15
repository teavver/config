# docs

https://search.nixos.org/packages

https://nix-darwin.github.io/nix-darwin/manual/index.html

https://nix-community.github.io/home-manager/

# install 

`sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)`
`https://github.com/nix-darwin/nix-darwin?tab=readme-ov-file#step-1-creating-flakenix`

# rebuild

## nix-darwin
```
sudo darwin-rebuild switch --flake /etc/nix-darwin#prism
```
## home-manager
```
home-manager switch
```

# todo

secrets