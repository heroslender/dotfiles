#!/bin/sh
set -e

test -d "$HOME/.shell.d" || ln -sf "$PWD/.shell.d" "$HOME/.shell.d"
ln -sf "$PWD/.dircolors" "$HOME/.dircolors"

ln -sf "$PWD/.bashrc" "$HOME/.bashrc"