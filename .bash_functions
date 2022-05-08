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
# shellcheck disable=SC2059

function getexitcode {
	# if [ $? -eq 0 ]; then
		# echo -n
	# else
		# echo -n "{err:$?}"
	# fi
	local err=$?; [ $err -ne 0 ] && printf "{err:$err}"
}

# Better PATH printout
path(){
	echo "$PATH" | tr -s ":" "\n"
	# Or the more verbose equivalent:
	# local old=$IFS
	# IFS=:
	# printf "%s\n" $PATH
	# IFS=$old
}

manpath(){
	if [ $# -eq 0 ]; then
		env manpath | tr -s ":" "\n"
	else
		env manpath "$@"
	fi
}

# shellcheck disable=SC2034
function pause() {
	local dummy
#	read -s -r -p "Press any key to continue..." -n 1 dummy
	printf "Press any key to continue..." >&2 && read -s -r -n 1 dummy
}

fullWidthLine(){
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "${1:--}"
}

# shellcheck disable=SC2120
fullWidthLineUnicode(){
	yes "${1:--}" | head "-${COLUMNS:-$(tput cols)}" | paste -s -d ''
}

# shellcheck disable=SC2119
spacer(){
	fullWidthLineUnicode
	printf "%s\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" ' ' " " ' ' " "
	fullWidthLineUnicode
}

function locateFunc(){
	(shopt -s extdebug; declare -F "$1";)
} && complete -A function locateFunc;

# Look, I forget things, okay?
# ls_symbols(){
	# printf "╔═════╤═════════════╦═════╤══════════╗\n"
	# printf "║ '*' │ executables ║ '@' │ symlinks ║\n"
	# printf "║ '|' │ FIFOs       ║ '=' │ sockets  ║\n"
	# printf "║ '/' │ directories ║ '>' │ doors    ║\n"
	# printf "╚═════╧═════════════╩═════╧══════════╝\n"
# }

__showColor(){
	if [ $# -ne 1 ]; then
		# shellcheck disable=SC2128
		printf "$FUNCNAME takes exactly 1 argument\n";
		return 1;
	fi
	printf "\e[48;5;${1}m $1 \033[m"
}

function showColorRange(){
	if [ $# -ne 2 ]; then
		# shellcheck disable=SC2128
		printf "Usage: '$FUNCNAME START_NUM END_NUM'\n"
		printf "\tSTART_NUM AND END_NUM must be integers in the range of [0,256).\n"
		return 1
	fi
	#for i in `seq 0 5`; do printf "\e[48;5;${i}m   ";done;printf "\033[m\n"
	#for n in `seq 0 20`; do \(for i in `seq 0 256`; do printf "\e[48;5;${i}m   \033[m";done;);done;
	# for i in `seq $1 $2`;
	local i;
	for ((i=$1; i <= $2; i++)); do
		printf "\e[48;5;${i}m $i "
	done
	printf "\e[0m\n"
}

# shellcheck disable=SC2128
echoChar (){
	if [ $# -ne 1 ]; then
		printf "Usage: $FUNCNAME UNICODE_NUMBER\n" && return 1
	fi
	printf "\U${1}"
}

samplePrompt(){
	echo "${PS1@P}"
}

setTitle(){
	[ $# -ge 1 ] && printf "\e]2;$*\a"
	#printf '\[\033]0;$@\007\]' #set maximized title
	#printf '\[\033]1;$@\007\]' #set minimized title
}

# shellcheck disable=SC2128
setTextColor(){
	[ $# -eq 1 ] && printf "\e]10;$1\a" || echo "$FUNCNAME only accepts a single color parameter."
}

# shellcheck disable=SC2128
setBackgroundColor(){
	[ $# -eq 1 ] && printf "\e]11;$1\a" || echo "$FUNCNAME only accepts a single color parameter."	#seagreen is pretty
}

# shellcheck disable=SC2128
setCursorColor(){
	[ $# -eq 1 ] && printf "\e]12;$1\a" || echo "$FUNCNAME only accepts a single color parameter."
}

function moveCursorTo(){
	# This function name is something of a misnomer; it's actually more of an "insert at"
	[ $# -lt 2 ] && return 1

	local line="$1" col="$2"    # $1 is Line; $2 is Column
	shift 2            # Remove the arguments for line and column positions
	local text="$*"    # The text inserted is comprised of any remaining arguments

	printf "$(tput sc)\033[${line};${col}H${text}$(tput rc)"
}

useAltScreenBuf(){
	printf "\e[?1049h"
}

useMainScreenBuf(){
	printf "\e[?1049l"
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

# Send text to the system clipboard
sendToClipboard(){
	(echo "$@") >> /dev/clipboard
}

# Clear the system clipboard by explicitly writing an empty string to it
alias clearClipboard="sendToClipboard ''"

# Count the number of files in a directory
function filecount() {
	find "${1-.}" -type f | wc -l
}

# shellcheck disable=SC2128
findByName(){
	if [ $# -lt 1 ]; then
		printf "Equivalent to 'find PATH -name PATTERN'\n"
		printf "If only 1 arguement is provided, PATH defaults to the current directory\n"
		printf "Only supports up to two arguments.\n"
		printf "Usage: '$FUNCNAME [PATH] -name PATTERN'\n"
		return 1
	elif [ $# -eq 1 ]; then
		find "$PWD" -name "$1"
	else
		find "$1" -name "$2"
	fi
}

# shellcheck disable=SC2128
curlup(){
	echo "NOTE: This function is WIP."
	if [ $# -eq 0 ]; then
		echo "$FUNCNAME is a wrapper around the curl command for uploading local files to a remote url."
		# echo "Usage: $FUNCNAME --file <file> --dest <url> [--non-blocking]"
		echo "Usage: $FUNCNAME --dest URL [--file FILE]" #dont bother with the non-blocking case for now
		#might eventually decide to ditch the --dest and --file in favor of just requiring the parameters in a specific order
		return
	fi

	#something to get options
	#for now, erroneously assume that i know what i want when i use this command

	if [ $# -eq 2 ]; then	# if only a url was provided, read from stdin instead of a file
		curl --upload-file - "$2"
	else
		curl --upload-file "$4" "$2"
	fi
}

# shellcheck disable=SC2128
epochTime(){
	if [ "${1,,}" == "-h" ] || [ "${1,,}" == "--help" ]; then
		printf "Usage: $FUNCNAME [-h|--help] [TIME_STRING]\n"
		printf "  A convenience function for converting a human-readable time to the equivalent unix epoch time.\n" | fold -s
		printf "  Without a parameter, converts the current time to unix epoch form.\n"
		return 0
	elif [ "$#" -gt 1 ]; then
		printf "$FUNCNAME accepts at most 1 argument.\n"
		return 1
	fi

	# date explicitly defaults to "now" if not provided	(or provided empty string)
	date -d "${1:-now}" "+%s"
}

# shellcheck disable=SC2128
fromEpoch(){
	if [ "${1,,}" == "-h" ] || [ "${1,,}" == "--help" ]; then
		printf "Usage: $FUNCNAME [-h|--help] [UNIX_EPOCH]\n"
		printf "  A convenience function for converting a unix epoch timestamp to a human-readable format, using the current system time zone.\n" | fold -s
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

# shellcheck disable=SC2128
function strtail(){
	[ $# -ne 2 ] && printf "Usage: $FUNCNAME STRING N\t:\tget last N characters of STRING\n" && return 1
	[ "$2" -gt "${#1}" ] && printf "Error: $FUNCNAME: The number of characters to get cannot exceed length of the string.\n" && return 1
	echo "${1: ${#1}-$2}"
}

# shellcheck disable=SC2128
function strhead(){
	[ $# -ne 2 ] && printf "Usage: $FUNCNAME STRING N\t:\tget first N characters of STRING\n" && return 1
	[ "$2" -gt "${#1}" ] && printf "Error: $FUNCNAME: The number of characters to get cannot exceed length of the string.\n" && return 1
	echo "${1:0:$2}"
}

# shellcheck disable=SC2128
function skipNchars(){
	[ $# -ne 2 ] && printf "Usage: $FUNCNAME STRING N\t:\tTrim the first N characters of STRING, and return the rest\n" && return 1
	[ "$2" -gt "${#1}" ] && printf "Error: $FUNCNAME: The number of characters to skip cannot exceed length of the string.\n" && return 1
	echo "${1:$2:${#1}}"
}

remove-blank-lines(){
	sed '/^\s*$/d'
}

mancat(){
	man --nj --nh "$@" | unexpand --first-only --tabs=4 | tr -s ' '
}

function excuse(){
	# shellcheck disable=SC2155
	local str=$(curl -s developerexcuses.com | grep -Eo '<a href.*>.*<\/a>')
	local str2="${str:71:${#str}}"
	echo "${str2:0:${#str2}-4}"
}

# shellcheck disable=SC2046
if [ $(seemsLikeWSL) ]; then
	function wslpath(){
		if [ $# -eq 0 ]; then
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
	listinstalled(){
		apt list --installed | grep -o ".*/" | tr -d '/' | column
	}

	lessinstalled(){
		apt list --installed | grep -o ".*/" | grep -ve "^lib" -e "^python3-" -e "^perl-" -e "^xserver-" -e "^x11-" -e"^gedit-" -e "^python2-" | tr -d "/" | column
	}
fi

if [ -e "/etc/environment" ]; then
	getbasepath(){
		grep -o "=.*" /etc/environment | tr -d "="
	}
fi

if [ "$OSTYPE" == 'msys' ]; then
	incmd(){
		echo "$@" | cmd; echo
	}
fi

if [ -n "$(type -t durt)" ]; then
	# durt should really just operate on the current directory if I don't specify one
	function durt(){
		command durt "${@:-$PWD}"
	}
fi

if [ -n "$(type -t pip)" ]; then
	piphelp(){
		# If I want to see the general help, I'll ask for it.
		case $1 in
			help|-h|--help|'')	pip --help; echo ;;
			*)	COLUMNS=$(tput cols) pip "$@" --help | sed -n '/General Options:/q;p' ;;
		esac
	}
fi

if command -v fd >/dev/null 2>&1; then
	if [ -n "$(type -t treef)" ]; then
		fdtree(){
			# You CAN simply pipe the current version of fd into tree (version >= 1.8.0), but both that and this function seem to have some quirks...
			# If the locally available version of fd doesn't default to the Unix path separator in MSYS,
			# insert the following command into the command pipeline before piping into treef:   command -p tr '\\' '/'

			# set -x
			__fdtree_has_temp_colors='0'
			command -p test ! "$LS_COLORS" && __fdtree_has_temp_colors=1 &&  eval "$(dircolors)" #export LS_COLORS="$(dircolors | sed -Ee 2d -e "s/.*'(.+)'.*/\1/")"
			# LS_COLORS="$(dircolors | sed -Ee 2d -e "s/.*'(.+)'.*/\1/")"
			# __fdtree_LS_COLORS="$(dircolors | sed -Ee 2d -e "s/.*'(.+)'.*/\1/")"
			case "$1" in
				--help | -h)
					printf "Wrapper around fd and treef.\n"
					printf "Lists all files in a directory in the form of a tree using the fd command and the treef tree-formatter.\n"
					printf "   $FUNCNAME [-h|--help] [-g|--git] DIRECTORY\n"
					printf "      -h|--help     Shows this help text.\n"
					printf "      -g|--git      Include the contents of any .git directories"
					;;
				--git | -g)
					shift
					# LS_COLORS="$__fdtree_LS_COLORS" command fd -HL "$@" | treef
					command fd -HL --no-ignore-vcs "$@" | treef
					;;
				*)
					#shift
					# LS_COLORS="$__fdtree_LS_COLORS" command fd -HL "$@" | command -p grep --invert-match --ignore-case '\.git' | treef
					# command fd -HL --no-ignore "$@" | command -p grep --invert-match --ignore-case '\.git' | LS_COLORS="$(dircolors | sed -Ee 2d -e "s/.*'(.+)'.*/\1/")" | treef
					if [ -e "$1" ]; then
						# Naively assume no pattern was intended
						command fd -HL --no-ignore '' "$@" | command -p grep --invert-match --ignore-case '\.git' | treef
					else
						command fd -HL --no-ignore "$@" | command -p grep --invert-match --ignore-case '\.git' | treef
					fi
					# I cant seem to get treef to colorize unless LS_COLORS is explicitly set by the shell prior to calling fdtree :(
					;;
			esac
			test __fdtree_has_temp_colors != '0' && export -n LS_COLORS && unset LS_COLORS
			unset __fdtree_has_temp_colors
			# set +x
		}
	fi
fi

rl-cfg-dump(){
	if [ -n "$(type -t tabulate)" ]; then
		# big sad: tabulate v1.1.1 does not seem to support ANSI escape codes in its input; it just displays them as plain text.
		# So this method, which looks nicer overall, wont use --byte-subst='\033[37;40m<%X>\033[m' for iconv, which matched the
		# coloring that is otherwise used on the hex value of potentially troublesome characters
		printf "%s\n" "$(bind -pv)" "$(bind -sX| sort -bu)" | \
			sed -Ee '/self-insert$/!s/(^.*?)(\s*)(: )(.*)(\s*)/\4 \3\1/' -e 's/(^# )(.*?\w)(\s*)(\(.*?\))(\s*)/\2 : \4/' | \
			iconv -t "utf-8" --byte-subst='<%X>' | tabulate -c 0 -d ':'
	else
		printf "%s\n" "$(bind -pv)" "$(bind -sX| sort -bu)" | \
		sed -Ee '/self-insert$/!s/(^.*?)(\s*)(: )(.*)(\s*)/\4 \3\1/' -e 's/(^# )(.*?\w)(\s*)(\(.*?\))(\s*)/\2 : \4/'
	fi
}

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

# `complete -W '' COMMAND_NAME` is one of several ways to disallow any argument completion options for COMMAND_NAME.
