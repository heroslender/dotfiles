#!/usr/bin/bash

# first whatever the system has (required for completion, etc.)
if [ -e /etc/bashrc ]; then
    source /etc/bashrc
fi

source "$HOME/.shell.d/path.sh"
source "$HOME/.shell.d/history.bash"
source "$HOME/.shell.d/pager.sh"
source "$HOME/.shell.d/settings.bash"
source "$HOME/.shell.d/prompt.sh"
source "$HOME/.shell.d/editor.sh"
source "$HOME/.shell.d/colors.bash"
source "$HOME/.shell.d/dircolors.sh"
source "$HOME/.shell.d/completion.bash"
source "$HOME/.shell.d/git-completion.bash"
source "$HOME/.shell.d/termcap-colors.sh"
source "$HOME/.shell.d/aliases.sh"
source "$HOME/.shell.d/envx.bash"
# Setup some settings for usage with wsl
# e.g. support for vcxsrv
source "$HOME/.shell.d/wsl.sh"

# sensitive configurations
test -r ~/.bash_private && source ~/.bash_private

test "$(command -v screenfetch)" && screenfetch
