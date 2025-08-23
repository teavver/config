# prereq

`softwareupdate --install-rosetta`

`xcode-select --install`

https://apple.stackexchange.com/questions/287760/set-the-hostname-computer-name-for-macos

# docs

https://search.nixos.org/packages

https://nix-darwin.github.io/nix-darwin/manual/index.html

https://nix-community.github.io/home-manager/

# install 

`sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)`

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
