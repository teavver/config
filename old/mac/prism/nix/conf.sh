#!/bin/bash

set iex

DEST=~/config/mac/prism/nix/

sudo cp ./flake.nix "$DEST"
sudo cp ./flake.lock "$DEST"
sudo cp ./conf.sh "$DEST"
echo "OK"
