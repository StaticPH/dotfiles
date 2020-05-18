#!/bin/bash

## put single quotes around opening EOF string to prevent variable expansion within a heredoc

function baseMachineSpecific(){
cat << 'EOF' > ${HOME}/.machine_specific
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
cat << 'EOF' > ${HOME}/.setup_machine_env
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

[ -d "${HOME}/.cargo" ] && export CARGO_HOME="${HOME}/.cargo"
[ -d "${HOME}/.cargo" ] && export RUSTUP_HOME="${HOME}/.cargo"

[ -d "${HOME}/venvs" ] && export WORKON_HOME="${HOME}/venvs"
[ -v WORKON_HOME ] && export VIRTUALENVWRAPPER_HOOK_DIR=$WORKON_HOME
## WARNING!!! sourcing a virtualenv will not behave properly when there is a pre-existing alias for `python`, particularly if it uses winpty
# export MSYS_HOME="" # e.g "/c/msys2", THIS IS EFFECTIVELY SETTING YOUR ROOT DIRECTORY LOCATION; defined to enable use of virtualenvwrapper.sh with native Windows Python installation according to https://virtualenvwrapper.readthedocs.io/en/latest/install.html
# export VIRTUALENVWRAPPER_PYTHON=""	# Path to python executable to use for venvwrapper
# export VIRTUALENVWRAPPER_SCRIPT=""	# Path to virtualenvwrapper.sh ; e.g. "YOUR_PYTHON_INSTALL/Scripts/virtualenvwrapper.sh"
## If using virtualenvwrapper_lazy, also add
# source (PATH TO virtualenvwrapper_lazy.sh)

# export JAVA_HOME="PATH TO JDK FOLDER" 
# export ANDROID_HOME="" # Path to your Android SDK directory, e.g. "$HOME/Android/Sdk/"

# This value must be set for Go to work. Not that I know what it should be set to... maybe `go env` will help with that
# export GOPATH="" # e.g. "${HOME}/go" 
## By default, Go expects to be installed at /usr/local/go (or C:\Go on Windows)
## If it has been installed elsewhere, set GOROOT to that location. DO NOT SET OTHERWISE
# export GOROOT=""

# TODO: variables for npm, pnpm, php

##############################################################
#-------------------------------------------------------------
# Additions to PATH
#-------------------------------------------------------------
##############################################################

## Append the path to the directory containing custom git commands to your PATH


## If necessary, append the path to your Python's Scripts directory


# Conditionally add the user's Cargo bin directory to the path
[ -v CARGO_HOME ] && PATH="$PATH:$CARGO_HOME/bin"

# Conditionally add bins for MULTIPLE versions of ruby 
if [ -d ~/.gem/ruby/*/bin ]; then
	function rubyBins(){
		local rubyBinGlob=(~/.gem/ruby/*/bin)
		echo $(printf ":%s" "${rubyBinGlob[@]}")
	}
	PATH="${PATH}$(rubyBins)"
fi

# Conditionally add Android tools to the path
[ -v ANDROID_HOME ] && PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

# Conditionally add Go tools to the path
[ -v GOPATH ] && PATH="$PATH:${GOPATH}/bin"


##############################################################
#-------------------------------------------------------------
# Additions to MANPATH
#-------------------------------------------------------------
##############################################################
## MANPATH="ADDITIONAL PATH:$MANPATH
EOF
}

[ ! -e ${HOME}/.setup_machine_env ] && baseMachineEnv
[ ! -e ${HOME}/.machine_specific ] && baseMachineSpecific

unset baseMachineEnv baseMachineSpecific
exit 0