# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.


# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'


# Default to human readable figures
alias df='df -h'
alias du='du -h'
alias free='free -th'

#---------------------------------------
# Allowing Alias-Expansion-ception!
#---------------------------------------
# From Bash's Info page, section 6.6 Aliases: "If the last character of the alias value is a BLANK, then the next command word following the alias is also checked for alias expansion."
if [ -n "$(type -t sudo)" ]; then
	# Enable aliases to be sudo'ed
	alias sudo="sudo "
	alias udo="sudo " # the 's' key on my laptop keyboard is tempermental
fi

if [ -n "$(type -t gksudo)" ]; then
	alias gksudo="gksudo "
	alias gkudo="gksudo "  # the 's' key on my laptop keyboard is tempermental
fi

alias exec="exec " 			# Should allow calling exec on an alias
alias nohup="nohup "
[ -n "$(type -t winpty)" ] && alias winpty="winpty "

# case "$TERM" in
# xterm*)
	# # The following programs are known to require a Win32 Console
	# # for interactive usage, therefore let's launch them through winpty
	# # when run inside `mintty`.
	# for name in node ipython php php5 psql python2.7
	# do
		# case "$(type -p "$name".exe 2>/dev/null)" in
		# ''|/usr/bin/*) continue;;
		# esac
		# alias $name="winpty $name.exe"
	# done
	# ;;
# esac

#-------------------------------
# Safety (Stupid Proofing®)
#-------------------------------

alias chown='chown --preserve-root' # Attempting to change the ownership of the root directory is probably not a great idea
alias chgrp='chgrp --preserve-root' # The same can be said for group
alias chmod='chmod --preserve-root' # And probably for chmod too; what, are you trying to make your entire machine read-only to all users?
alias chcon='chcon --preserve-root' # And SELinux security context
alias rm='rm --preserve-root --one-file-system' # Try and stop total system annihilation...

#------------------
# Color output
#------------------

alias grep='grep --color=auto'                     # show results in color
[ -n "$(type -t egrep)" ] && \
	alias egrep='egrep --color=auto' ||\
	alias egrep='grep -E --color=auto'

[ -n "$(type -t fgrep)" ] && \
	alias fgrep='fgrep --color=auto' || \
	alias fgrep='grep -F --color=auto'

[ -n "$(type -t dmesg)" ]  && alias dmesg='dmesg --color=auto -T'
alias dir="dir --color=auto -Fh --group-directories-first --hide='*.dll' --hide='*.DLL'"

#---------------
# Find-like
#---------------

alias which='type -a'
# may replace alias "which" with something like(not actually functional):
# function which(){
	# type -a "$@" 2>/dev/null ||\
	# \which "$@" 2>/dev/null ||\
	# hash -tl "$@"
# }

	#Recursively grep through directories, following symlinks, INCLUDING those encountered recursively.
	#Depending on the version of grep available, -r may or may not be the same as -R
	#If they are different, -r will likely only follow symlinks on the command line itself.
alias grepdir="grep -R"

alias findEmptyDirs="find -depth -type d -empty"
alias findManPage="man -w"

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------

# Add colors for filetype, file hide patterns, and human-readable sizes by default on 'ls'
# I typically don't need to see dll files, and some directories have lots.
alias ls="ls --hide='*.dll' --hide='*.DLL' -hF --group-directories-first --color=auto --dereference-command-line-symlink-to-dir"
# alias ls='ls -hF --color=tty'                 # classify files in colour
# to always show year on long listing, use --time-style="long-iso"

alias lsa="ls -A"                    #ls all
alias la="ls -A"

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -Alhv --group-directories-first --no-group -o" #g: don't list owner; F: add classifying character; o: no group info

alias lsdir='ls --recursive'

if [ -n "$(type -t tree)" ]; then
	alias tree="tree -C -uhal -I '.cargo|.gem|.git|.gnupg|.ssh|.subversion|.svn|bower_components|build|emojis|node_mdoules'"    #  Nice alternative to 'recursive ls' ...
	# alias treeOccupied="tree --prune -FC -I '.git|.svn|.ssh|.gnupg|build'"
	alias treeOccupied="tree --prune -F"
fi

# Some shortcuts for different directory listings
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'

#------------------------------------
# Directory Manipulation Aliases
#------------------------------------

alias mkdir='mkdir -pv'
alias frmdir="rm -iR"				#Remove directories, prompting before each file
alias cpdir="cp -r"					#copy directories recursively
alias multicp="cp -t"				#copy multiple things to the directory passed as the first parameter

#----------------------------------------
# Does exactly what the name implies
#----------------------------------------
     #chown aliases: Should try to claim full ownership of the target as $USER
alias take="chown -hR $USER:$USER"
alias gimme="chown -hR $USER:$USER"

alias reloadbash="source ~/.bashrc"		#Reload bashrc without restarting bash

alias listBuiltins="enable -pa"
alias disable="enable -n"				#Shortcut for disabling a shell builtin

if [[ $OSTYPE == 'msys' ]]; then
	# For msys, return the WINDOWS-STYLE absolute path
	alias cwd="pwd -PW"
	alias here="pwd -PW"
else
	# For systems other than msys, just ignore symlinks, as the path is already absolute otherwise.
	alias cwd="pwd -P"
	alias here="pwd -P"
fi

#----------------------
# Terminal related
#----------------------

alias infocmp="infocmp -1"
alias infocmpl="infocmp -1L"

alias termsettings="stty"
alias thisterm="tty"

#------------------
# Link related
#------------------
# Remove all symlinks within a directory ( . )
alias rmlinks="find . -lname '*' -exec rm {} \;"
# alias findLinks="find . -lname '*'" # List links in current directory
alias findLinks="find . -maxdepth 1 -type l -printf '%p -> %l\n'" # List links in current directory
alias pointswhere="readlink"
alias findBrokenLinks='find . -maxdepth 1 -type l ! -exec test -e {} \; -printf "%-15p  ->  %l\n"'

#-------------------------
# Compression related
#-------------------------

if [ -n "$(type -t tar)" ]; then
	alias untar="tar --extract --file"
	alias tarball="tar --create --file --verbose" # --totals
	alias tarzip="tar --create --file --gzip"
fi

#--------------------------
# Diff Related Aliases
#--------------------------

if [ -n "$(type -t colordiff)" ]; then
	#For some reason, i had both -s and --report-identical-files. Removed -s, but will re-add if it turns out to have been portability related.
	alias diff="colordiff --ignore-space-change --report-identical-files --suppress-common-lines"
	alias diffdir="colordiff --ignore-space-change --report-identical-files --suppress-common-lines --recursive"
	alias diffcol="colordiff --ignore-space-change --report-identical-files --suppress-common-lines --side-by-side"
	alias diffcol2="colordiff --ignore-space-change --report-identical-files --suppress-common-lines --side-by-side | grep -n \|"
else
    alias diff="diff --ignore-space-change --report-identical-files --suppress-common-lines --color=auto"
	# [ -n "$(type -t diff3)" ] && alias diff3="diff3 --ignore-space-change --report-identical-files --suppress-common-lines --color=auto"
    alias diffdir="diff --ignore-space-change --report-identical-files --suppress-common-lines --color=auto --recursive" # -b
    alias diffcol="diff --ignore-space-change --report-identical-files --suppress-common-lines --color=auto --side-by-side"
    alias diffcol2="diff --ignore-space-change --report-identical-files --suppress-common-lines --color=auto --side-by-side|grep -n \|"
fi
[ -n "$(type -t diff-so-fancy)" ] && alias fancydiff="diff-so-fancy"
[ -n "$(type -t bcompare)" ] && alias beyondcompare="bcompare"

#--------------------------
# Rust Program Aliases
#--------------------------
# I tried $(ripgrepExtraTypes) with said program echoing output, but bash seemed unable to locate it on load, so I resorted to exporting a new variable
if [ -n "$(type -t rg)" ]; then
	if [ -f "${HOME}/bin/ripgrepExtraTypes" ]; then
		source ~/bin/ripgrepExtraTypes
	fi
	alias rg="rg --hidden --color=auto --max-columns 500 --smart-case --follow $extraRipgrep"
	alias ripgrep="rg"

	alias genRipgrepTypeList="rg --type-list > ~/txts/.ripgrepTypeList && echo 'List saved at ~/txts/.ripgrepTypeList' || echo 'List failed to generate'"
	unset extraRipgrep		# BEGONE no-longer-needed environment variable!
fi
[ -n "$(type -t fd)" ] && alias fd="fd -HaL"
#--------------------------------
# Network Related Aliases
#--------------------------------

alias curl="curl --create-dirs"

[ -n "$(type -t ngrep)" ] && alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"		# Sniff network info.

# alias wget='wget --no-check-certificate'			# Disable sertificate check for wget.

# IP addresses
# [ -n "$(type -t dig)" ] && alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
# alias localip="ipconfig getifaddr en0"
# if [ -n "$(type -t ifconfig)" ]; then
	# alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
	# [ -n "$(type -t pcregrep)" ] && alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'" # Show active network interfaces
# fi

# [ -n "$(type -t dscacheutil)" ] && alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder" # Flush Directory Service cache

#--------------------------------
# Process Management Aliases
#--------------------------------
	# Better 'ps'
alias _ps="ps -a --format 'logname user pid jobc start command'"
alias myps="ps -a --format 'logname user pid jobc start command'"

[ -n "$(type -t pgrep)" ] && alias pgrep="pgrep -afi"
#[ -n "$(type -t pkill)" ] && alias pkill="pkill -fx" # Be careful what you kill
[[ -n "$(type -t pkill)" && -z "$(type -t pk)" ]] && alias pk="pkill"

#---------------------------------
# Development Related Aliases
#---------------------------------

alias jmake="make -j$(nproc)"
alias gccg="gcc -ggdb3"		#compile and create debugging symbols
alias g++g="g++ -ggdb3"
alias gpp="g++"
alias gppg="g++ -ggdb3"

if [ -n "$(type -t gdb)" ]; then
	alias gdb="gdb -q"		#launch gdb without all the versioning and help printouts
	alias gdbHelp="gdb -h"	#print gdb help and exit
fi

[ -n "$(type -t python2)" ] && alias py2="python2"

if [ -n "$(type -t python)" ]; then
	if [[ "$OSTYPE" == 'msys' ]]; then
		alias dumbpy="$PY37/python"
		alias dumpy="$PY37/python"
		alias python37="winpty $PY37/python"	#TODO: Find out a way to disable this while a virtual environment is activated

		alias dumbpy36="$PY36/python"
		alias dumpy36="$PY36/python"
		alias python36="winpty $PY36/python"	#TODO: Find out a way to disable this while a virtual environment is activated

		alias python="winpty $PY37/python"	#TODO: Find out a way to disable this while a virtual environment is activated

		# alias pip="$PY36/Scripts/pip"		# For inexplicable reasons, this alias completely breaks any attempts at bash completion for pip
	else
		[ -n "$(type -t python3.6)" ] && alias python36="python3.6"	#TODO: Find out a way to disable this while a virtual environment is activated
		[ -n "$(type -t python3.7)" ] && alias python37="python3.7"	#TODO: Find out a way to disable this while a virtual environment is activated
		[ -n "$(type -t python3)" ]   && alias python="python3"	#TODO: Find out a way to disable this while a virtual environment is activated
	fi
	alias pip36="$PY36/Scripts/pip"
	alias pip37="$PY37/Scripts/pip"
	[[ -f "$PY36/Scripts/pipenv" ]] && alias pipenv36="$PY36/Scripts/pipenv"
	[[ -f "$PY37/Scripts/pipenv" ]] && alias pipenv37="$PY37/Scripts/pipenv"
	alias py="python "

	alias validjson="python -m json.tool"
	alias printjson="validjson"

	# And for ipython specifically...
	if [ -n "$(type -t ipython3)" ]; then
		[[ $OSTYPE == 'msys' ]] && \
			alias ipython="winpty ipython3" || \
			alias ipython="ipython3"
	elif [ -n "$(type -t ipython)" ] ; then
		[[ $OSTYPE == 'msys' ]] && alias ipython="winpty ipython"
	fi
	[ -n "$(type -t ipython)" ] && alias ipy="ipython"

fi

# TODO:
# if [ "$VIRTUAL_ENV" ]; then
	# #if windows
	# alias python="winpty $VIRTUAL_ENV\Scripts\python"
	# alias py="python"
	# #else
	# #non-winpty
# else
	# #do normal aliases

[ -n "$(type -t sqlite3)" ] && alias sqlite="sqlite3"

#------------------------
# Package Management
#------------------------

[ -n "$(type -t dpkg)" ] && alias purge="dpkg -P"	#dpkg purge is supposed to allow purging of configs when the package itself has already been removed.
[ -n "$(type -t dpkg-query)" ] && alias dpkg-from-package="dpkg-query --listfiles" # Shows files from a specific installed package
[ -n "$(type -t pacman)" ] && alias pacman='pacman --color=auto'
[ -n "$(type -t update-alternatives)" ] && alias alternatives="update-alternatives"
# get dependents with "apt rdepends --no-enhances --no-suggests --no-recommends --no-breaks --no-conflicts"
[ -n "$(type -t pnpm)" ] && alias npm="pnpm"
[ -n "$(type -t pnpx)" ] && alias npx="pnpx"

#---------------------------
# Miscellaneous Aliases
#---------------------------

alias j='jobs -l'
alias who="who -H"
# alias less='less -r'                          # raw control characters
alias less="less --ignore-case --LONG-PROMPT --shift .25 -F --status-column --tilde --" # --use-backslash ?
# alias more="more -d"	# Make more provide useful feedback when an invalid key is pressed.
alias more="less" # insert obligatory "less is more" pun here
alias nano="nano -cA --nowrap --nonewlines -T 4"	# --zap?
#alias lineCount="wc -l"  # Trying to encourage myself to remember the actual command for this one
alias filetype="file" # Would alias as "ftype", but that already exists on Windows

# alias bd=". bd -si"
alias ..="cd .."
alias cls="clear"

alias dec2hex='printf "%x\n" $1'	# print decimal as hex
# alias hexdump='hexdump --color=auto' -x    -C    --format
alias odHex='od -t xz'
alias odx='od -t x2z'

alias lstat='stat -L'	# A poor man's lstat
alias sysInfo="uname"

alias exitstatus="echo $?"            #print the error status for the last command

# alias returnToGuiMode='echo Try pressing alt+f7'     will probably use some environment variable check here
[ -n "$(type -t setxkbmap)" ] && alias fixKeyboard='setxkbmap -model pc105 -layout us -rules evdev -option "lv3:ralt_switch" -option "numpad:microsoft"'
[ -n "$(type -t timedatectl)" ] && alias fixTime="timedatectl --no-ask-password"


alias getGibberish="head -n 1 /dev/random"

alias dumpExports="export -p"	# List all the variables being exported to child shells

alias crippleSelf="exec 2>&-" #I have no idea why you'd ever WANT to do this, but the fact that you CAN kill stdout is cool.