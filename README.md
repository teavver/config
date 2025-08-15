# install 

`sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)`
`https://github.com/nix-darwin/nix-darwin?tab=readme-ov-file#step-1-creating-flakenix`

# rebuild

```
sudo darwin-rebuild switch --flake /etc/nix-darwin#prism
```

# todo

secrets, home-manager?