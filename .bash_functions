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
	echo $PATH | tr -s ":" "\n"
	# Or the more verbose equivalent:
	# local old=$IFS
	# IFS=:
	# printf "%s\n" $PATH
	# IFS=$old
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

fullWidthLineUnicode(){
	[ -n "$1" ] && \
		local char="$1" || \
		local char="-"
	yes "$char" | head "-${COLUMNS:-$(tput cols)}" | paste -s -d ''
}

function locateFunc(){
	(shopt -s extdebug; declare -F "$1";)
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
	echo -en "\e[48;5;${1}m $1 \033[m"
}
function showColorRange(){
	if [ $# -ne 2 ]; then
		printf "Usage: 'showColorRange START_NUM END_NUM'\n\tSTART_NUM AND END_NUM must be an integer greater than or equal to 0, and less than 256." && return 1
	fi
	#for i in `seq 0 5`; do \echo -en "\e[48;5;"$i"m   ";done;echo -e "\033[m"
	#for n in `seq 0 20`; do \(for i in `seq 0 256`; do \echo -en "\e[48;5;"$i"m   \033[m";done;);done;
	# for i in `seq $1 $2`;
	local i;
	for ((i=$1; i <= $2; i++)); do
		printf "\e[48;5;${i}m $i "
	done
	printf "\e[0m\n"
}

function echoChar (){
	if [ $# -ne 1 ]; then
		printf "Usage: echoChar UNICODE_NUMBER\n" && return 1
	fi
	#echo -e '\\U\'$1\''
	printf "\U${1}"
}

function samplePrompt(){
	echo "${PS1@P}"
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
	# This function name is something of a misnomer; it's actually more of an "insert at"
	[ $# -lt 2 ] && return 1

	local line="$1" col="$2"    # $1 is Line; $2 is Column
	shift 2            # Remove the arguments for line and column positions
	local text="$*"    # The text inserted is comprised of any remaining arguments

	printf "$(tput sc)\033[${line};${col}H${text}$(tput rc)"
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
	#INSTEAD OF: check="$(type -a $1)" >/dev/null 2>&1
	#USE: check="$(type -a $1)" &>/dev/null

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

function epochTime(){
	if [[ "${1,,}" == "-h" || "${1,,}" == "--help" ]]; then
		printf "Usage: $FUNCNAME [-h|--help] [TIME STRING]\n"
		printf "  A convenience function for converting a human-readable time to the equivalent unixepoch time.\n" | fold -s
		printf "  Without a parameter, converts the current time to unixepoch form.\n"
		return 0
	elif [ "$#" -gt 1 ]; then
		printf "$FUNCNAME accepts at most 1 argument.\n"
		return 1
	fi

	[ -n "$1" ] && \
		local now="$1" || \
		local now="now" # This could have just been left blank, but this has the same outcome and is clearer
	date -d "$now" "+%s"
}

function fromEpoch(){
	if [[ "${1,,}" == "-h" || "${1,,}" == "--help" ]]; then
		printf "Usage: $FUNCNAME [-h|--help] [UNIXEPOCH]\n"
		printf "  A convenience function for converting a unixepoch timestamp to a human-readable format, using the current system time zone.\n" | fold -s
		# printf "  Output format is determined by the values of LC_TIME and TIME_STYLE.\n"	# Determine order of precedence
		# printf "  Time zone rules are indicated by the TZ environment variable, or by the system default rules if TZ is not set.\n"
		return 0
	elif [ "$#" -ne 1 ]; then
		printf "$FUNCNAME requires exactly 1 argument.\n"
		return 1
	fi

	date -d "@$1"
}

# function quotify(){
	# echo ${$*@Q};
# }

# function escapify(){
	# echo ${*@E}
# }

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

function excuse(){
	local str=$(curl -s developerexcuses.com | egrep -o '<a href.*>.*<\/a>') 
	local str2="${str:71:${#str}}"
	echo "${str2:0:${#str2}-4}"
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

if [ -n "$(type -t apt)" ]; then
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

if [[ "$OSTYPE" == 'msys' ]]; then
	function incmd(){
		echo "$@" | cmd; echo
	}
fi


# if [ -n "$(type -t durt)" ]; then
	# function durtDir(){
		# [ -n "$1" ] && \
			# local fd="$1" || \
			# local fd="."
		# pushd $fd
		# for d in $(*); do
			# command durt $d
		# done
		# [ -t $fd } && command durt $fd
		# popd
	# }
# fi


# reminder, $@ is an array of arguments, while $* is a single string containing all the arguments.
# $# is the number of arguments after the program call
# redirect to stdin with >&0
# redirect to stdout with >&1
# redirect to stderr with >&2
# "^" is equivalent to "2>", at least for the Fish shell
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

# set -u	treats attempts to expand previously unset variables/parameters as errors, and causes non-interactive shells to exit. Use this as part of making bash stricter.
#
# local -	makes it so that shell options changed using the 'set' builtin inside the function are restored to their original values when the function returns; does not effect 'shopt'
# echo $-	to see the current flags applied by the 'set' command
#
# when debugging scripts, try adding this after handling positional parameters:
# local -; set -uxv # strict mode; trace; print shell input as encountered

# ${var1:+"$var1"}		if $var1 is unset or null, yield null; otherwise expand $var1
# ${var1:-defaultValue} if $var1 is unset or null, yield defaultValue; otherwise expand $var1

# xdg-open is your friend
# bash 4+ builtin "coproc" may not have a man/info page; try 'help coproc'
