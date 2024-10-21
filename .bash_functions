# shellcheck shell=bash
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

# BASH ARRAY FUNCNAME
__showColor(){
	if [ $# -ne 1 ]; then
		printf "${FUNCNAME[0]} takes exactly 1 argument\n";
		return 1;
	fi
	printf "\e[48;5;${1}m $1 \033[m"
}

# BASH ARRAY FUNCNAME
function showColorRange(){
	if [ $# -ne 2 ]; then
		printf "Usage: '${FUNCNAME[0]} START_NUM END_NUM'\n"
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

# BASH ARRAY FUNCNAME
echoChar(){
	if [ $# -ne 1 ]; then
		printf "Usage: ${FUNCNAME[0]} UNICODE_NUMBER\n" && return 1
	fi
	printf "\U${1}"
}

function toggle_hist_expansion(){
	case "$-" in
		*H*) set +H;;
		*)   set -H;;
	esac
}

# shellcheck disable=SC2206
function editfunc(){
	### Look for the function definition, and store the results in an array
	local found=( $(shopt -s extdebug; declare -F "$1") )
	### Fail if function definition cannot be found
	if [ "${#found[@]}" -eq 0 ]; then
		printf '\033[31m%s: Unable to find function: "%s"\033[0m\n' "${FUNCNAME[0]}" "$1"
		return 1;
	fi
	### Remove function name from $found
	unset "found[0]";
	### Ensure array indices are current; in this particular case,
	### quoting the variable to prevent expansion results in a single array
	### element, so don't do that.
	found=( ${found[*]} )

	#printf "found=\033[32m%s\033[0m\nlen found=\033[33m%s\033[0m\n" "${found[@]}" "${#found[@]}";
	case "${EDITOR:-nano}" in
		subl*)
			"$EDITOR" "${found[1]}:${found[0]}";;
		*/nano|nano) ;&
		*)
			### Open nano to the line containing the function definition
			"$EDITOR" "+${found[0]}" "${found[1]}"
			;;
	esac
} && complete -A function editfunc;

# Look, I forget things, okay?
# ls_symbols(){
	# printf "╔═════╤═════════════╦═════╤══════════╗\n"
	# printf "║ '*' │ executables ║ '@' │ symlinks ║\n"
	# printf "║ '|' │ FIFOs       ║ '=' │ sockets  ║\n"
	# printf "║ '/' │ directories ║ '>' │ doors    ║\n"
	# printf "╚═════╧═════════════╩═════╧══════════╝\n"
# }

function samplePrompt(){
	echo "${PS1@P}"
}

# BASH ARRAY FUNCNAME
setTextColor(){
	[ $# -eq 1 ] && printf "\e]10;$1\a" || echo "${FUNCNAME[0]} only accepts a single color parameter."
}

# BASH ARRAY FUNCNAME
setBackgroundColor(){
	[ $# -eq 1 ] && printf "\e]11;$1\a" || echo "${FUNCNAME[0]} only accepts a single color parameter."	#seagreen is pretty
}

# BASH ARRAY FUNCNAME
setCursorColor(){
	[ $# -eq 1 ] && printf "\e]12;$1\a" || echo "${FUNCNAME[0]} only accepts a single color parameter."
}

# Send text to the system clipboard; /dev/clipboard may not reliably exist outside MSYS2 :(
sendToClipboard(){
	(echo "$@") >> /dev/clipboard
}

# Clear the system clipboard by explicitly writing an empty string to it; /dev/clipboard may not reliably exist outside MSYS2 :(
alias clearClipboard="sendToClipboard ''"

# BASH ARRAY FUNCNAME
findByName(){
	if [ $# -lt 1 ]; then
		printf "Equivalent to 'find PATH -name PATTERN'\n"
		printf "If only 1 arguement is provided, PATH defaults to the current directory\n"
		printf "Only supports up to two arguments.\n"
		printf "Usage: '${FUNCNAME[0]} [PATH] -name PATTERN'\n"
		return 1
	elif [ $# -eq 1 ]; then
		find "$PWD" -name "$1"
	else
		find "$1" -name "$2"
	fi
}

# BASH ARRAY FUNCNAME
curlup(){
	echo "NOTE: This function is WIP."
	if [ $# -eq 0 ]; then
		echo "${FUNCNAME[0]} is a wrapper around the curl command for uploading local files to a remote url."
		# echo "Usage: $FUNCNAME --file <file> --dest <url> [--non-blocking]"
		echo "Usage: ${FUNCNAME[0]} --dest URL [--file FILE]" #dont bother with the non-blocking case for now
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

# BASH ARRAY FUNCNAME
epochTime(){
	if [ "${1,,}" = "-h" ] || [ "${1,,}" = "--help" ]; then
		printf "Usage: ${FUNCNAME[0]} [-h|--help] [TIME_STRING]\n"
		printf "  A convenience function for converting a human-readable time to the equivalent unix epoch time.\n" | fold -s
		printf "  Without a parameter, converts the current time to unix epoch form.\n"
		return 0
	elif [ "$#" -gt 1 ]; then
		printf "${FUNCNAME[0]} accepts at most 1 argument.\n"
		return 1
	fi

	# date explicitly defaults to "now" if not provided	(or provided empty string)
	date -d "${1:-now}" "+%s"
}

# BASH ARRAY FUNCNAME
fromEpoch(){
	if [ "${1,,}" = "-h" ] || [ "${1,,}" = "--help" ]; then
		printf "Usage: ${FUNCNAME[0]} [-h|--help] [UNIX_EPOCH]\n"
		printf "  A convenience function for converting a unix epoch timestamp to a human-readable format, using the current system time zone.\n" | fold -s
		# printf "  Output format is determined by the values of LC_TIME and TIME_STYLE.\n"	# Determine order of precedence
		# printf "  Time zone rules are indicated by the TZ environment variable, or by the system default rules if TZ is not set.\n"
		return 0
	elif [ "$#" -ne 1 ]; then
		printf "${FUNCNAME[0]} requires exactly 1 argument.\n"
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

strlen(){
	# Sometimes it's just more convenient to have this in the form of a function than a variable.
	echo "${#1}"
	# Alternatively: expr length + "$1"
}

# BASH ARRAY FUNCNAME
function strtail(){
	[ $# -ne 2 ] && printf "Usage: ${FUNCNAME[0]} STRING N\t:\tget last N characters of STRING\n" && return 1
	[ "$2" -gt "${#1}" ] && printf "Error: ${FUNCNAME[0]}: The number of characters to get cannot exceed length of the string.\n" && return 1
	echo "${1: ${#1}-$2}"
}

# BASH ARRAY FUNCNAME
function strhead(){
	[ $# -ne 2 ] && printf "Usage: ${FUNCNAME[0]} STRING N\t:\tget first N characters of STRING\n" && return 1
	[ "$2" -gt "${#1}" ] && printf "Error: ${FUNCNAME[0]}: The number of characters to get cannot exceed length of the string.\n" && return 1
	echo "${1:0:$2}"
}

# BASH ARRAY FUNCNAME
function skipNchars(){
	[ $# -ne 2 ] && printf "Usage: ${FUNCNAME[0]} STRING N\t:\tTrim the first N characters of STRING, and return the rest\n" && return 1
	[ "$2" -gt "${#1}" ] && printf "Error: ${FUNCNAME[0]}: The number of characters to skip cannot exceed length of the string.\n" && return 1
	echo "${1:$2:${#1}}"
}

function excuse(){
	# shellcheck disable=SC2155
	local str=$(curl -s developerexcuses.com | grep -Eo '<a href.*>.*<\/a>')
	local str2="${str:71:${#str}}"
	echo "${str2:0:${#str2}-4}"
}

# shellcheck disable=SC2046
if seemsLikeWSL && ! command -v wslpath &>/dev/null; then
	function wslpath(){
		if [ $# -eq 0 ]; then
			### https://github.com/Microsoft/WSL/issues/2715
			### Once upon a time, wslpath lacked helpful output when called without arguments.
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

if command -v apt >/dev/null 2>&1; then
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

if [ "x$MSYSTEM" != 'x' ] || command -v cmd.exe >/dev/null 2>&1; then
	incmd(){
		echo "$@" | cmd.exe; echo
	}
fi

if command -v durt >/dev/null 2>&1; then
	# durt should really just operate on the current directory if I don't specify one
	function durt(){
		command durt "${@:-$PWD}"
	}
fi

if command -v pip >/dev/null 2>&1; then
	piphelp(){
		# If I want to see the general help, I'll ask for it.
		case $1 in
			help|-h|--help|'')	pip --help; echo ;;
			*)	COLUMNS=$(tput cols) pip "$@" --help | sed -n '/General Options:/q;p' ;;
		esac
	}
fi

if command -v fd >/dev/null 2>&1; then
	if command -v treef >/dev/null 2>&1; then
# BASH ARRAY FUNCNAME
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
					printf "   ${FUNCNAME[0]} [-h|--help] [-g|--git] DIRECTORY\n"
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
	if command -v tabulate >/dev/null 2>&1; then
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
# BASHISM: As of Bash 4, "|&" is shorthand for "2>&1 |"
# BASHISM: delete a function, but NOT a variable of the same name, with "unset -f functionName"
# BASHISM: redirecting with ">|" instead of ">" will force file clobbering, ignoring whether noclobber is enabled(via set)
# BASHISM: "&>fileName" is equivalent to ">fileName 2>&1"
# BASHISM: "&>>fileName" is equivalent to ">>fileName 2>&1"

# BASHISM: "hash -p FILEPATH NAME" can be used to remember individual executables, as if they were included in PATH.
# BASHISM: The caveat to this is that hashed functions ARE NOT FOUND BY "type -a" or tab-completion

# In here-documents, if the redirection operator is ‘<<-’,
# then all leading tab characters are stripped from input lines and the line containing delimiter.
# This allows here-documents within shell scripts to be indented in a natural fashion

# BASHISM: set -u	treats attempts to expand previously unset variables/parameters as errors, and causes non-interactive shells to exit. Use this as part of making bash stricter.
#
# BASHISM: local -	makes it so that shell options changed using the 'set' builtin inside the function are restored to their original values when the function returns; does not effect 'shopt'
# BASHISM: echo $-	to see the current flags applied by the 'set' command
#
# BASHISM: when debugging scripts, try adding this after handling positional parameters:
# BASHISM: local -; set -uxv # strict mode; trace; print shell input as encountered

# ${var1:+"$var1"}		if $var1 is unset or null, yield null; otherwise expand $var1
# ${var1:-defaultValue} if $var1 is unset or null, yield defaultValue; otherwise expand $var1

# xdg-open is your friend
# bash 4+ builtin "coproc" may not have a man/info page; try 'help coproc'

# BASHISM: `complete -W '' COMMAND_NAME` is one of several ways to disallow any argument completion options for COMMAND_NAME.
# Iterate bash array indices like so: `for i in "${!VAR[@]}"; do echo $i; done`
# Iterate associative array keys in Zsh like so: `for k in "${(@k)VAR}"; do print $k; done`
