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
if command -v sudo >/dev/null 2>&1; then
	# Enable aliases to be sudo'ed
	alias sudo="sudo "
	alias udo="sudo " # the 's' key on my laptop keyboard is tempermental
fi

if command -v gksudo >/dev/null 2>&1; then
	alias gksudo="gksudo "
	alias gkudo="gksudo "  # the 's' key on my laptop keyboard is tempermental
fi

alias exec="exec "			# Should allow calling exec on an alias
alias nohup="nohup "
command -v winpty >/dev/null 2>&1 && alias winpty="winpty "

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
if command -v egrep >/dev/null 2>&1; then
	alias egrep='egrep --color=auto'
else
	alias egrep='grep -E --color=auto'
fi

if command -v fgrep >/dev/null 2>&1; then
	alias fgrep='fgrep --color=auto'
else
	alias fgrep='grep -F --color=auto'
fi

command -v dmesg >/dev/null 2>&1 && alias dmesg='dmesg --color=auto -T'
alias dir="dir --color=auto -Fh --group-directories-first --hide='*.dll' --hide='*.DLL'"

if command -v shellcheck >/dev/null 2>&1; then
	alias shellcheck='shellcheck --color=always'
	alias shc='shellcheck'
fi

#---------------
# Find-like
#---------------

alias which='type -a'

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
# in environments other than msys2 with mintty, I may want to consider --hyperlink=auto
alias ls="ls --hide='*.dll' --hide='*.DLL' -hF --group-directories-first --color=auto --dereference-command-line-symlink-to-dir"
# alias ls='ls -hF --color=tty'                 # classify files in colour
# to always show year on long listing, use --time-style="long-iso"

alias lsa="ls -A"                    #ls all
alias la="ls -A"

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -Alhv --group-directories-first --no-group -o" #g: don't list owner; F: add classifying character; o: no group info

alias lsdir='ls --recursive'

if command -v tree >/dev/null 2>&1; then
	alias tree="tree -C -uhal --dirsfirst -I '.cargo|.gem|.git|.gnupg|.ssh|.subversion|.svn|bower_components|build|emojis|node_modules'"    #  Nice alternative to 'recursive ls' ...
	# alias treeOccupied="tree --prune -FC -I '.git|.svn|.ssh|.gnupg|build'"
	alias treeOccupied="tree --prune -F"
else
	# Sorta-kinda-approximate tree
	alias tree='ls -Ah --group-directories-first --dereference-command-line-symlink-to-dir --recursive | grep ":$" | sed -e "s/:$//" -e "s@[^-][^/]*/@--@g" -e "s/^/ /" -e "s/-/|/"'
fi

# Some shortcuts for different directory listings
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'

#------------------------------------
# Directory Manipulation Aliases
#------------------------------------

alias mkdir='mkdir -pv'
alias frmdir="rm -iR"				# Remove directories, prompting before each file
alias cpdir="cp -a"					# Copy directories recursively while preserving all attributes
alias multicp="cp -t"				# Copy multiple things to the directory passed as the first parameter

#----------------------------------------
# Does exactly what the name implies
#----------------------------------------
     #chown aliases: Should try to claim full ownership of the target as $USER
alias take="chown -hR $USER:$USER"
alias gimme="chown -hR $USER:$USER"

alias reloadbash="source ${HOME}/.bashrc"		#Reload bashrc without restarting bash; this may be better off as a function that calls `pushd ~;source "${HOME}/.bashrc"; popd` instead, to ensure tools like direnv can modify the environment.

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

alias hidecursor='tput civis'
alias showcursor='tput cnorm'

#----------------------
# Terminal related
#----------------------

alias infocmp="infocmp -1"
alias infocmpl="infocmp -1L"

# alias termsettings="stty"
# alias thisterm="tty"

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
# Archive related
#-------------------------

# What environment would I be running in that can't reasonably be expected to have tar?
# It's not like I'm going to be setting up Arch from scratch; I like Arch, but not THAT much.
if command -v tar >/dev/null 2>&1; then
	alias untar="tar --extract --file"
	alias tarzip="tar --create --gzip --file" # 1st argument is the resulting tarfile
	alias tarball="tar --create --verbose --file" # 1st argument is the resulting tarfile
	alias untz="tar --extract --gzip --verbose --file"
	alias untxz='tar --extract -v --atime-preserve -I "xz -c -T 0" --totals '
fi

alias tarlist='bsdcpio -itF'

#--------------------------
# Diff Related Aliases
#--------------------------

command -v icdiff >/dev/null 2>&1 && alias icdiff='icdiff --tabsize 4 --cols=$(tput cols)'

if command -v colordiff >/dev/null 2>&1; then
	#For some reason, i had both -s and --report-identical-files. Removed -s, but will re-add if it turns out to have been portability related.
	alias diff="colordiff --ignore-space-change --report-identical-files --suppress-common-lines"
	alias diffdir="colordiff --ignore-space-change --report-identical-files --suppress-common-lines --recursive"
	alias diffcol="colordiff --ignore-space-change --report-identical-files --suppress-common-lines --side-by-side"
	alias diffcol2="colordiff --ignore-space-change --report-identical-files --suppress-common-lines --side-by-side | grep -n \|"
else
	alias diff="diff --ignore-space-change --report-identical-files --suppress-common-lines --color=auto"
	# command -v diff3 >/dev/null 2>&1 && alias diff3="diff3 --ignore-space-change --report-identical-files --suppress-common-lines --color=auto"
	alias diffdir="diff --ignore-space-change --report-identical-files --suppress-common-lines --color=auto --recursive" # -b
	alias diffcol="diff --ignore-space-change --report-identical-files --suppress-common-lines --color=auto --side-by-side"
	alias diffcol2="diff --ignore-space-change --report-identical-files --suppress-common-lines --color=auto --side-by-side|grep -n \|"
fi
# command -v diff-so-fancy >/dev/null 2>&1 && alias fancydiff="diff-so-fancy" # It turns out fancydiff is another program, and I haven't tried it to know if I'd ever want to use it
command -v bcompare >/dev/null 2>&1 && alias beyondcompare="bcompare"

#--------------------------
# Rust Program Aliases
#--------------------------

command -v rg >/dev/null 2>&1 && alias ripgrep="rg"
command -v desed >/dev/null 2>&1 && alias desed="desed --sed-path /usr/bin/sed"

if command -v fd >/dev/null 2>&1; then
	alias fd="fd -HaL"

	# Faster version of findLinks using fd instead of find
	alias findLinksFd="command fd -H --no-ignore --type symlink"

fi

#--------------------------------
# Network Related Aliases
#--------------------------------

alias curl="curl --create-dirs"

command -v ngrep >/dev/null 2>&1 && alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"		# Sniff network info.

# alias wget='wget --no-check-certificate'			# Disable sertificate check for wget.

# IP addresses
# REMOVEME: apparently this 1st one no longer works for free users, may if you're a paying Cisco customer; see https://unix.stackexchange.com/questions/335371/how-does-dig-find-my-wan-ip-adress-what-is-myip-opendns-com-doing
# command -v dig >/dev/null 2>&1 && alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Try this instead
# command -v dig >/dev/null 2>&1 && alias ip="dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com"

# alias localip="ipconfig getifaddr en0"  sometimes en1, or some other interface...
# if command -v ifconfig >/dev/null 2>&1; then
	# alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
	# command -v pcregrep >/dev/null 2>&1 && alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'" # Show active network interfaces
# fi

alias globalip="curl -s http://checkip.dyndns.com/ | sed 's/[^0-9\.]//g'"

# command -v dscacheutil >/dev/null 2>&1 && alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder" # Flush Directory Service cache

[ "$OSTYPE" == 'msys' ] && alias routetbl-show='netstat -r' # To be clear, this is WINDOWS netstat
# [ "$OSTYPE" == 'msys' ] && alias netcon-stats='netstat -es'

#--------------------------------
# Process Management Aliases
#--------------------------------

alias ps='ps -l'
if [ "$OSTYPE" == 'msys' ]; then
	alias _ps="procps -a --format 'logname user pid jobc start command'"
	alias myps="procps -a --format 'logname user pid jobc start command'"
	alias psa='ps -lWa'
else
	alias _ps="ps -a --format 'logname user pid jobc start command'"
	alias myps="ps -a --format 'logname user pid jobc start command'"
	alias psa='ps -la'
fi

command -v pgrep >/dev/null 2>&1 && alias pgrep="pgrep -afi"
#command -v pkill >/dev/null 2>&1 && alias pkill="pkill -fx" # Be careful what you kill
command -v pkill >/dev/null 2>&1 && [ ! command -v pk >/dev/null 2>&1 ] && alias pk="pkill"

#---------------------------------
# Development Related Aliases
#---------------------------------

command -v nproc &>/dev/null && alias jmake="make -j$(nproc)"
alias gccg="gcc -ggdb3"		#compile and create debugging symbols
alias g++g="g++ -ggdb3"
alias gpp="g++"
alias gppg="g++ -ggdb3"

if command -v gdb >/dev/null 2>&1; then
	alias gdb="gdb -q"		#launch gdb without all the versioning and help printouts
	alias gdba="gdb --args" #launch gdb while providing arguments to any target executable for debugging
	alias gdbHelp="gdb -h"	#print gdb help and exit
fi

command -v python2 >/dev/null 2>&1 && alias py2="python2"

if command -v python >/dev/null 2>&1; then
	#TODO: Find out a way to disable these while ANY virtual environment is activated; already found a way that needs to be manually set up for each venv
	if [[ "$OSTYPE" == 'msys' ]]; then
		# Expanding to an empty string when PY38 is null/unset and checking if the result is executable may be marginally more performant than checking
		# "if PY38 is a directory AND it contains an executable file, 'python'" ( [-d "$PY38" && -x "$PY38/python" ] )
		if [ -x "${PY38:+$PY38/python}" ]; then
			alias dumbpy="$PY38/python"
			alias dumpy="$PY38/python"
			alias python38="winpty $PY38/python"
		fi

		if [ -x "${PY37:+$PY37/python}" ]; then
			alias dumbpy="$PY37/python"
			alias dumpy="$PY37/python"
			alias python37="winpty $PY37/python"
		fi

		if [ -x "${PY36:+$PY36/python}" ]; then
			alias dumbpy36="$PY36/python"
			alias dumpy36="$PY36/python"
			alias python36="winpty $PY36/python"
		fi

		alias python="winpty $PY37/python" # FIXME: be smarter about this...which I'll need to be if this is to work on machines with less chaotic setup.

		# alias pip="$PY36/Scripts/pip"		# For inexplicable reasons, this alias completely breaks any attempts at bash completion for pip
	else
		command -v python3.6 >/dev/null 2>&1 && alias python36="python3.6"
		command -v python3.7 >/dev/null 2>&1 && alias python37="python3.7"
		command -v python3.8 >/dev/null 2>&1 && alias python38="python3.8"
		command -v python3 >/dev/null 2>&1   && alias python="python3"
	fi

	[ -x "${PY36:+$PY36/Scripts/pip}" ] && alias pip36="$PY36/Scripts/pip"
	[ -x "${PY37:+$PY37/Scripts/pip}" ] && alias pip37="$PY37/Scripts/pip"
	[ -x "${PY38:+$PY38/Scripts/pip}" ] && alias pip38="$PY38/Scripts/pip"
	[ -x "${PY36:+$PY36/Scripts/pipenv}" ] && alias pipenv36="$PY36/Scripts/pipenv"
	[ -x "${PY37:+$PY37/Scripts/pipenv}" ] && alias pipenv37="$PY37/Scripts/pipenv"
	[ -x "${PY38:+$PY38/Scripts/pipenv}" ] && alias pipenv38="$PY38/Scripts/pipenv"
	alias py="python "

	# And for ipython specifically...
	command -v ipython3 >/dev/null 2>&1 && alias ipython="ipython3"
	command -v ipython >/dev/null 2>&1 && alias ipy="ipython"

	alias webserv="py -m http.server"
fi

command -v sqlite3 >/dev/null 2>&1 && alias sqlite="sqlite3"
command -v sqliterepl >/dev/null 2>&1 && alias sqliterepl="sqliterepl -t fancy_grid -s fruity"

#------------------------
# Package Management
#------------------------

command -v dpkg >/dev/null 2>&1 && alias purge="dpkg -P"	#dpkg purge is supposed to allow purging of configs when the package itself has already been removed.
command -v dpkg-query >/dev/null 2>&1 && alias dpkg-from-package="dpkg-query --listfiles" # Shows files from a specific installed package
command -v pacman >/dev/null 2>&1 && alias pacman='pacman --color=auto'
command -v update-alternatives >/dev/null 2>&1 && alias alternatives="update-alternatives"
# get dependents with "apt rdepends --no-enhances --no-suggests --no-recommends --no-breaks --no-conflicts"
command -v pnpm >/dev/null 2>&1 && alias npm="pnpm"
command -v pnpx >/dev/null 2>&1 && alias npx="pnpx"

#------------------------
# Winpty Wrapping
#------------------------
# shellcheck disable=SC2140
if [ "$OSTYPE" == 'msys' ]; then
# if [ "$TERM_PROGRAM" == 'mintty' ]; then
	for name in sqliterepl node php php5 psql ipython litecli; do
		command -v "$name" >/dev/null 2>&1 && alias "$name"="winpty $name"
	done
	unset name
fi

#---------------------------
# Pager Aliases
#---------------------------

# lessm and less are aliased to the same thing, with the exception that lessm wont exit less automatically if the output fits on the first screen.
alias lessm='command -p less --ignore-case --status-column --LONG-PROMPT --tilde --shift .25 -+F'  # --use-backslash ?  --mouse ?
alias less="less -iJM --tilde --shift .25 -F"

# alias more="more -d"	# Make more provide useful feedback when an invalid key is pressed.
alias more="less" # insert obligatory "less is more" pun here

#---------------------------
# Miscellaneous Aliases
#---------------------------

alias j='jobs -l'
alias who="who -H"
alias file='file -p' # Attempt to preserve file access times from prior to being scanned.
alias filetype="file" # Would alias as "ftype", but that already exists on Windows
# alias dirs="dirs -v" # Display directory stack entries on separate lines, prefixed by their zero-based index in the stack

# alias bd=". bd -si"
alias ..="cd .."
alias cls="clear"

alias dec2hex='printf "%x\n"'	# print decimal as hex
# alias hexdump='hexdump --color=auto' -x    -C    --format
alias odHex='od -t xz'
alias odx='od -t x2z'

alias lstat='stat -L'	# A poor man's lstat
alias sysInfo="uname"

alias exitstatus="echo $?"            #print the error status for the last command

alias termbin="nc termbin.com 9999" # Pipe or file-redirect into this

# alias returnToGuiMode='echo Try pressing alt+f7'     will probably use some environment variable check here
command -v setxkbmap >/dev/null 2>&1 && alias fixKeyboard='setxkbmap -model pc105 -layout us -rules evdev -option "lv3:ralt_switch" -option "numpad:microsoft"'
command -v timedatectl >/dev/null 2>&1 && alias fixTime="timedatectl --no-ask-password"

alias getGibberish="head -n 1 /dev/random"

alias dumpExports="export -p"	# List all the variables being exported to child shells

alias crippleSelf="exec 2>&-" #I have no idea why you'd ever WANT to do this, but the fact that you CAN kill stdout is cool.
