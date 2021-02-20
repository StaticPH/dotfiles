#! /bin/sh

# Generate bash or zsh completions for rustup and cargo commands
if [ "$SHELL" == "/bin/bash" ] || [ "$SHELL" == "/usr/bin/bash" ]; then
	mkdir -p ~/.local/share/bash-completion/completions &> /dev/null
	rustup completions bash > ~/.local/share/bash-completion/completions/rustup # formerly these both appended for some reason
	rustup completions bash cargo > ~/.local/share/bash-completion/completions/cargo
elif [ "$SHELL" == "/bin/zsh" ] || [ "$SHELL" == "/usr/bin/zsh" ]; then
	mkdir ~/.zcompletions &> /dev/null
	rustup completions zsh > ~/.zcompletions/_rustup
	rustup completions zsh cargo > ~/.zcompletions/_cargo
	printf "Add the following line to .zshrc, just prior to 'compinit':\n%s\n" "fpath+=~/.zcompletions"
	printf "Relog or run \"exec zsh\" for the changes to be applied\n"
fi
