#!/bin/sh
set -e

ln -sf "$PWD/shell.d" "$HOME/.shell.d"
ln -sf "$PWD/dircolors" "$HOME/.dircolors"

ln -sf "$PWD/bashrc" "$HOME/.bashrc"