# Some example functions:
#
# a) function settitle
# settitle ()
# {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
# }
#

#########################################################
#########################################################
# ALL FUNCTIONS CONTAINED HEREIN SHOULD EITHER BE 
# OS-AGNOSTIC, OR WRAPPED IN AN OS CHECK 
#########################################################
#########################################################


function getexitcode {
    # if [ $? -eq 0 ]; then
        # echo -n
    # else
        # echo -n "{err:$?}"
    # fi
	local err=$?; [ $err -ne 0 ] && printf "{err:$err}"
}

# Better PATH printout
function path(){
    old=$IFS
    IFS=:
    printf "%s\n" $PATH
    IFS=$old
}

pause() {
	local dummy
	read -s -r -p "Press any key to continue..." -n 1 dummy
}

fullWidthLine(){
	[ -n "$1" ] && \
		local char="$1" || \
		local char="-"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "$char"
}

# Look, I forget things, okay?
# function ls_symbols(){
	# printf "╔═════╤═════════════╦═════╤══════════╗\n"
	# printf "║ '*' │ executables ║ '@' │ symlinks ║\n"
	# printf "║ '|' │ FIFOs       ║ '=' │ sockets  ║\n"
	# printf "║ '/' │ directories ║ '>' │ doors    ║\n"
	# printf "╚═════╧═════════════╩═════╧══════════╝\n"
# }

function __showColor(){
	if [ $# -ne 1 ]; then
		printf "__showColor takes exactly 1 argument"; return 1;
	fi
	echo -en "\e[48;5;"$1"m $i \033[m"
}
function showColorRange(){
	if [ $# -ne 2 ]; then
		printf "Usage: 'showColorRange START_NUM END_NUM'" && return 1
	fi
	#for i in `seq 0 5`; do \echo -en "\e[48;5;"$i"m   ";done;echo -e "\033[m"
	#for n in `seq 0 20`; do \(for i in `seq 0 256`; do \echo -en "\e[48;5;"$i"m   \033[m";done;);done;
	for i in `seq $1 $2`;
	do
		echo -en "\e[48;5;"$i"m $i "
	done
	echo -e "\033[m"
}

function echoChar (){
	if [ $# -ne 1 ]; then
		printf "Usage: echoChar UNICODE_NUMBER\n" && return 1
	fi
	#echo -e '\\U\'$1\''
	echo -e '\U'$1
}

setTitle(){
	[[ $# -ge 1 ]] && echo -e "\e]2;$@\a"
	#echo -e '\[\033]0;$@\007\]' #set maximized title
	#echo -e '\[\033]1;$@\007\]' #set minimized title
}
setTextColor(){
	[[ $# -eq 1 ]] && echo -e "\e]10;$1\a" || echo "$0 only accepts a single color parameter."
}
setBackgroundColor(){
	[[ $# -eq 1 ]] && echo -e "\e]11;$1\a" || echo "$0 only accepts a single color parameter."	#seagreen is pretty
}
setCursorColor(){
	[[ $# -eq 1 ]] && echo -e "\e]12;$1\a" || echo "$0 only accepts a single color parameter."
}
function moveCursorTo(){
	[[ $# -eq 2 || $# -eq 3 ]] || return -1
	line=$1;	col=$2;	text=$3
	echo -ne "$(tput sc)"
	echo -ne '\033['$1';'$2'H'$3
	echo -ne "$(tput rc)"
}

#Check if root user has root privelege. Remember that for bash, 0 is true
isRoot(){
	if [ "$UID" -ne 0 ] ; then
		# echo "You need to be root to run this script!"
		return 1
	else
		# echo "You are root."
		return 0
	fi
}

#Check that an executable with the given name exists on the PATH.
# function programExists(){
	#INSTEAD OF: check=$(type -a $1) >/dev/null 2>&1 
	#USE: check=$(type -a $1) &>/dev/null

	# if [ -n "$check" ]; then
		# # echo "$1 exists"
		# return 0
	# else
		# # echo "$1 was not found"
		# return 1
	# fi
# }

# Send text to the system clipboard
function sendToClipboard(){
	(echo $@) >> /dev/clipboard
}
# Clear the system clipboard by explicitly writing an empty string to it
alias clearClipboard="sendToClipboard ''"

# Count the number of files in a directory
function filecount() {
	find "${1-.}" -type f | wc -l
}


function findByName(){
	if [ $# -lt 1 ]; then
		printf "Equivalent to 'find PATH -name PATTERN'\n"
		printf "If only 1 arguement is provided, PATH defaults to the current directory\n"
		printf "Only supports up to two arguments.\n"
		printf "Usage: '$0 [PATH] -name PATTERN'\n"
        return 1
     elif [ $# -eq 1 ]; then
		find $(pwd) -name $1
	else
		find $1 -name $2
	fi
}

function curlup(){
	echo "NOTE: This function is WIP."
	if [[ $# == 0 ]]; then
		echo "curlup is a wrapper around the curl command for uploading local files to a remote url."
		# echo "Usage: curlup --file <file> --dest <url> [--non-blocking]"
		echo "Usage: curlup --dest URL [--file FILE]" #dont bother with the non-blocking case for now
		#might eventually decide to ditch the --dest and --file in favor of just requiring the parameters in a specific order
		return
	fi
	
	#something to get options
	#for now, erroneously assume that i know what i want when i use this command		
	
	if [[ $# == 2 ]]; then	# if only a url was provided, read from stdin instead of a file
		curl --upload-file - $2
	else
		curl --upload-file $4 $2
	fi
}

function strlen(){
	echo "${#1}"
	# Alternatively: expr length + "$1"
}
function strtail(){
	[[ $# -ne 2 ]] && printf "Usage: strtail STRING N\t:\tget last N characters of STRING\n" && return 1
	[[ "$2" -gt "${#1}" ]] && printf "Error: strtail: The number of characters to get cannot exceed length of the string.\n" && return 1
	echo "${1: ${#1}-$2}"
}
function strhead(){
	[[ $# -ne 2 ]] && printf "Usage: strhead STRING N\t:\tget first N characters of STRING\n" && return 1
	[[ "$2" -gt "${#1}" ]] && printf "Error: strhead: The number of characters to get cannot exceed length of the string.\n" && return 1
	echo "${1:0:$2}"
}

function skipNchars(){
	[[ $# -ne 2 ]] && printf "Usage: skipNchars STRING N\t:\tTrim the first N characters of STRING, and return the rest\n" && return 1
	[[ "$2" -gt "${#1}" ]] && printf "Error: skipNchars: The number of characters to skip cannot exceed length of the string.\n" && return 1
	echo "${1:$2:${#1}}"
}


if [ $(seemsLikeWSL) ]; then
	function wslpath(){
		if [ "$#" = "0" ]; then
			### https://github.com/Microsoft/WSL/issues/2715
cat << '__EOF__'
Usage: wslpath [-a] [-u|-w|-m] path
	-a    output absolute path
	-u    translate from a Windows path to a WSL path (default)
	-w    translate from a WSL path to a Windows path
	-m    translate from a WSL path to a mixed Windows path using slashes
__EOF__
		   return 0
		fi
	/bin/wslpath "$@"
	}
fi

if [ -n $(type -t apt) ]; then
	function listinstalled(){
		apt list --installed | grep -o ".*/" | tr -d '/' | column
	}

	function lessinstalled(){
		apt list --installed | grep -o ".*/" | grep -ve "^lib" -e "^python3-" -e "^perl-" -e "^xserver-" -e "^x11-" -e"^gedit-" -e "^python2-" | tr -d "/" | column
	}
fi

if [ -e "/etc/environment" ]; then
	function getbasepath(){
		cat /etc/environment | grep -o "=.*" | tr -d "="
	}
fi



# reminder, $@ is an array of arguments, while $* is a single string containing all the arguments.
# $# is the number of arguments after the program call
# "|&" is shorthand for "2>&1 |"
# delete a function, but NOT a variable of the same name, with "unset -f functionName"
# redirecting with ">|" instead of ">" will force file clobbering, ignoring whether noclobber is enabled(via set)
# "&>fileName" is equivalent to ">fileName 2>&1"
# "&>>fileName" is equivalent to ">>fileName 2>&1"

# "hash -p FILEPATH NAME" can be used to remember individual executables, as if they were included in PATH.
# The caveat to this is that hashed functions ARE NOT FOUND BY "type -a" or tab-completion

# In here-documents, if the redirection operator is ‘<<-’, 
# then all leading tab characters are stripped from input lines and the line containing delimiter. 
# This allows here-documents within shell scripts to be indented in a natural fashion

