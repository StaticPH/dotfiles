#! /bin/sh

# Generate bash or zsh completions for rustup and cargo commands
if [ "x$BASH_VERSION" != 'x' ]; then
	mkdir -p ~/.local/share/bash-completion/completions >/dev/null 2>&1
	rustup completions bash > ~/.local/share/bash-completion/completions/rustup # formerly these both appended for some reason
	rustup completions bash cargo > ~/.local/share/bash-completion/completions/cargo
elif [ "x$ZSH_VERSION" != 'x' ]; then
	# TODO: learn the "proper" place for these to go...
	mkdir ~/.zcompletions >/dev/null 2>&1
	rustup completions zsh > ~/.zcompletions/_rustup
	rustup completions zsh cargo > ~/.zcompletions/_cargo
	printf "Add the following line to .zshrc, just prior to 'compinit':\n%s\n" "fpath+=~/.zcompletions"
	printf "Relog or run \"exec zsh\" for the changes to be applied\n"
else
	echo "Current shell is not Bash or Zsh. Why not?"
	return 1
fi
