#! /bin/bash

## put single quotes around opening EOF string to prevent variable expansion within a heredoc

function baseMachineSpecific(){
cat << 'EOF' > "${HOME}/.machine_specific"
# NOTE: CURRENTLY THE BASE CONTENTS OF THIS FILE ARE ONLY RELEVANT ON WINDOWS.
#       THIS WILL LIKELY CHANGE IN THE FUTURE.

##############################################################
#-------------------------------------------------------------
# Things that need will likely need help from winpty on Windows
#-------------------------------------------------------------
##############################################################

# NOTE: There ARE situations in which using winpty actually causes problems.
# TODO: Figure out the rules for these situations, and disable these aliases under those situations
if [ -n "$(type -t winpty)" ]; then
	[ -n "$(type -t sqliterepl)" ] && alias sqliterepl="winpty ${HOME}/bin/sqliterepl -t fancy_grid -s fruity"
	[ -n "$(type -t node)" ] && alias node="winpty node"
	[ -n "$(type -t php)" ] && alias php="winpty php"
	[ -n "$(type -t php5)" ] && alias php5="winpty php5"
	[ -n "$(type -t psql)" ] && alias psql="winpty psql"
fi

##############################################################
#-------------------------------------------------------------
# Other things only relevant to Windows
#-------------------------------------------------------------
##############################################################
if [ "$OS" == 'Windows_NT' ]; then
	# alias npp=" PATH TO notepad++ EXECUTABLE"	#quick and easy, open a file in notepad++

	# alias dllchk="/mingw64/bin/ntldd.exe"
	# also try dep-search and ldd

	# function __pyreadline(){
	##	local getIt="pip install git+https://github.com/rlbr/pyreadline@redisplay"
	##	local get2="read -s -r -p 'Press any key to close...' -n 1"
	##    local get3="for i in \`seq 0 256\`;do echo -en \"\e[48;5;\"$i\"m\n\033[m\";sleep 0.001;done"
	##	local fff="echo HELLO!!"
	##	local aaa="start"
	##	`PATH TO bash` "-s $aaa"
	##	`PATH TO bash` -s $fff $get3 $getIt $get2 $get3
		# local prog="--progress-bar=pretty"
		# local repo="https://github.com/rlbr/pyreadline/archive/redisplay.zip"
		# pip install $repo $prog
		# `PATH TO pip` install $repo -Ut `PATH TO "site-packages"` $prog
	# }
fi
##############################################################
#-------------------------------------------------------------
# Things I don't know where to put
#-------------------------------------------------------------
##############################################################
if [[ "$OSTYPE" == 'msys' ]]; then
	## Not all terminals seem to need this, and I haven't figured out how to tell which do other than just trial and error.
	# echo -e '\[\033]0;'$PWD'\007\]'	#Set the terminal window title to the current directory
	:
fi

EOF
}

function baseMachineEnv(){
cat << 'EOF' > "${HOME}/.setup_machine_env"
#! /bin/bash

# ~/.setup_machine_env
# Load sensitive and machine-specific environment settings,
# including modifications to the base environment settings,
# like further path additions


##############################################################
#-------------------------------------------------------------
# Environment Variables
#-------------------------------------------------------------
##############################################################

## expected format for BROWSER `executable [--flags...] %s`
# export BROWSER=

[ -d "${HOME}/.cargo" ] && export CARGO_HOME="${HOME}/.cargo" RUSTUP_HOME="${HOME}/.cargo"

[ -d "${HOME}/venvs" ] && export WORKON_HOME="${HOME}/venvs"
[ -v WORKON_HOME ] && export VIRTUALENVWRAPPER_HOOK_DIR=$WORKON_HOME
## WARNING!!! sourcing a virtualenv will not behave properly when there is a pre-existing alias for `python`, particularly if it uses winpty
# export MSYS_HOME="" # e.g "/c/msys2", THIS IS EFFECTIVELY SETTING YOUR ROOT DIRECTORY LOCATION; defined to enable use of virtualenvwrapper.sh with native Windows Python installation according to https://virtualenvwrapper.readthedocs.io/en/latest/install.html
# export VIRTUALENVWRAPPER_PYTHON=""	# Path to python executable to use for venvwrapper
# export VIRTUALENVWRAPPER_SCRIPT=""	# Path to virtualenvwrapper.sh ; e.g. "YOUR_PYTHON_INSTALL/Scripts/virtualenvwrapper.sh"
## If using virtualenvwrapper_lazy, also add
# source (PATH TO virtualenvwrapper_lazy.sh)

# If pipx is installed and available on the PATH, configure where it installs packages and binaries
#-------------------------------------------------------------
if [ "$(type -t pipx)" ]; then
	export PIPX_BIN_DIR="${HOME}/.local/bin"	#default path explicitly enforced as ~/.local/bin
#	export PIPX_HOME=""	#Override default path of ~/.local/pipx, because my HOME is already cluttered enough as is.
fi

# export JAVA_HOME="PATH TO JDK FOLDER"
# export ANDROID_HOME="" # Path to your Android SDK directory, e.g. "$HOME/Android/Sdk/"

# This value must be set for Go to work. Not that I know what it should be set to... maybe `go env` will help with that
# export GOPATH="" # e.g. "${HOME}/go"
## By default, Go expects to be installed at /usr/local/go (or C:\Go on Windows, assuming C: is the system drive)
## If it has been installed elsewhere, set GOROOT to that location. DO NOT SET OTHERWISE
# export GOROOT=""

# If node.js is installed, configure the history file for the default Node REPL
#-------------------------------------------------------------
if [ "$(type -t node)" ]; then
	# Enable persistent REPL history for `node`.
	export NODE_REPL_HISTORY=~/.node_history;
	# Allow 32^3 entries; the default is 1000.
	export NODE_REPL_HISTORY_SIZE='32768';
fi

# TODO: variables for npm, pnpm, php

##############################################################
#-------------------------------------------------------------
# Additions to PATH
#-------------------------------------------------------------
##############################################################

## Append the path to the directory containing custom git commands to your PATH
# ex:  [ -d "/opt/extraGitCmds" ] && PATH="$PATH:/opt/extraGitCmds"

## If necessary, append the path to your Python's Scripts directory
# ex:  PATH="$PATH:/Projects/Python/envgroups/ipython/Scripts"

# Conditionally add the user's Cargo bin directory to the path
[ -v CARGO_HOME ] && pathadd --append "$CARGO_HOME/bin"

for __ruby_pathadd_ver in 2.{7,6}.0; do
	if [ -d "${HOME}/.gem/ruby/$__ruby_pathadd_ver/bin" ];then
		pathadd --append "${HOME}/.gem/ruby/$__ruby_pathadd_ver/bin"
	fi
done
unset __ruby_pathadd_ver

# Conditionally add other assorted tools to the path
if [ -v ANDROID_HOME ]; then
	pathadd --append "$ANDROID_HOME/tools"
	pathadd --append "$ANDROID_HOME/platform-tools"
fi
[ -v JAVA_HOME ] && pathadd --append "$JAVA_HOME/bin"
[ -v GOPATH ] && pathadd --append "${GOPATH}/bin"

##############################################################
#-------------------------------------------------------------
# Additions to MANPATH
#-------------------------------------------------------------
##############################################################
## MANPATH="ADDITIONAL PATH:$MANPATH
EOF
}

[ -e "${HOME}/.setup_machine_env" ] || baseMachineEnv
[ -e "${HOME}/.machine_specific" ] || baseMachineSpecific

unset baseMachineEnv baseMachineSpecific
exit 0
