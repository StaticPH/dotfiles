# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# ~/.bashrc: executed by bash(1) for interactive (non-login) shells.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the msys2 mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
# See man bash for more options...  specifically the sections on the builtins set and shopt
#-------------------------------------------------------------
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell
#
# Check that a command found in the hash table exists before trying to execute it. If it doesnt, a normal path search is performed.
shopt -s checkhash
#
# Warn if there are running/stopped jobs when attempting to exit Bash
# shopt -s checkjobs
#
# Attempt to save all lines of a multi-line command in the same history entry. Normally on by default.
shopt -s cmdhist
#
# For any 'foo.exe' during completion, if 'foo' and 'foo.exe' are the same file, strip the '.exe' suffix
[ "$OSTYPE" == 'msys' ] && shopt -s completion_strip_exe
#
# Include filenames beginning with '.' in the results of filename expansion.
# shopt -s dotglob
#
# Expand aliases even while in a non-interactive shell
# shopt -s expand_aliases
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# Don't automatically execute history expansions; expand them on a new line for review first
shopt -s histverify
#
# Don't use ^D to exit on the first try
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make the ** glob pattern match all files, in addition to the default behavior of matching any directories and subdirectories.
# shopt -s globstar
#
# Make glob patterns with no matches expand to an empty string, rather than to themselves.
# shopt -s nullglob
#
# Make glob patterns with no matches (after filename expansion) result in an expansion error.
# shopt -s failglob
#
# Disable completion when the input buffer is empty.  i.e. Hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion
#
# Don't wait for job termination notification
# set -o notify
#
# Use the TARGET of symbolic links when performing commands such as 'cd' which change the current directory
# set -o physical
#
# Aliases can use the programmable completion for the command they alias
shopt -s progcomp_alias >/dev/null 2>&1
#
# If this is set, the shift builtin prints an error message when the shift count exceeds the number of positional parameters.
# shopt -s shift_verbose
#
# Don't search through $PATH for files when using the builtin 'source' command
shopt -u sourcepath
#
# Expand backslash-escape sequences in echo by default
# shopt -s xpg_echo
#


# force_fignore? extglob? direxpand? promptvars? extdebug? checkjobs? checkwinsize? hostcomplete?

# Completion options
#-------------------------------------------------------------
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in your ~/.bash_completion file are sourced last.
# [ -r /etc/bash_completion ] && . /etc/bash_completion
# MAY CAUSE NOTICABLE IMPACT ON SPEED OF LOADING BASH
#
# This should only attempt to source completions if the file exists AND the completions have not already been sourced by the shell.
# [ -r /etc/bash_completion -a "x${BASH_VERSION-}" != x -a "x${PS1-}" != x -a "x${BASH_COMPLETION_VERSINFO-}" = x ] && . /etc/bash_completion

# History Options
#-------------------------------------------------------------
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# export HISTCONTROL=ignorespace:ignoredups		#subsumed by `[ \t]*:&` in HISTIGNORE
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded. Honors the setting of the extglob shell option.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls:which:pwd:clear:cls' # Ignore some other commands as well.
#
HISTIGNORE=$'[ \t]*:&:[fb]g:j:jobs:exit:clear:cls:history:history -a'
HISTIGNORE=$HISTIGNORE':path:la:ll:ls:env:[pc]wd'
HISTIGNORE=$HISTIGNORE':svn status:git status:git log'
export HISTIGNORE

# Enable this for unlimited history file length.
# export HISTFILESIZE=-1

# I want to store command history forever, but having to parse really long history files can slow down bash.
# To avoid that issue, when the history file exceeds 450 lines, dump the contents of the history file into another file that bash wont parse on load.
# Then, truncate the history file.

if [[ $( < "$HISTFILE" wc -l) -ge 450 ]]; then
	echo Saving history to long term storage
	[ ! -d ~/txts ] && mkdir ~/txts
	cat ~/.bash_history >> ~/txts/full.bash_history
	> "$HISTFILE"
fi

##############################################################
#-------------------------------------------------------------
# Source all the things!
#-------------------------------------------------------------
##############################################################

if [ -r "${HOME}/.setup_base_env" ]; then
	source "${HOME}/.setup_base_env"
fi


# if [ ! -n "${SSH_CONNECTION}" ]; then
    # # Disable bracketed paste mode
    # printf "\e[?2004l"
# fi

## If started from sshd, make sure profile is sourced
#if [[ -n "$SSH_CONNECTION" ]] && [[ "$PATH" != *:/usr/bin* ]]; then
#	source /etc/profile
#fi


# Umask
#-------------------------------------------------------------
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions and Aliases
### Some people use different files for functions and/or aliases
#-------------------------------------------------------------
if [ -r ~/.functions ]; then
	. ~/.functions
fi

if [ -r ~/.bash_functions ]; then
	. ~/.bash_functions
fi

if [ -r ~/.aliases ]; then
	. ~/.aliases
fi

if [ -r ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ "$OS" == 'Windows_NT' ]; then
	if [ -r ~/.winAliases -a  -r ~/.sys32Aliases ]; then
		source ~/.winAliases
		source ~/.sys32Aliases
	# else # TODO: Decide how to handle using my generateAll.sh script

	fi
fi


# Machine Specific
### Import functions and aliases that may only be relevant to a specific machine
#-------------------------------------------------------------
if [ -r "${HOME}/.machine_specific" ]; then
	source "${HOME}/.machine_specific"
fi


# Setup Prompt
#-------------------------------------------------------------
if [ -f "${HOME}/.setupPrompt" ]; then
	source "${HOME}/.setupPrompt"
else
	printf "Skipping prompt customization"
fi


##############################################################
#-------------------------------------------------------------
# Delayed variable exports and setup
#-------------------------------------------------------------
##############################################################

# To always echo the command entered, use this, but beware that it can cause issues:
# trap 'echo $BASH_COMMAND' DEBUG
# or you can try and see if this works:
# echo $BASH_COMMAND > /dev/tty
# See https://unix.stackexchange.com/questions/104018/set-dynamic-window-title-based-on-command-input for explanation

[ -v CHERE_INVOKING_VISIBLE_FOR_USER ] && unset CHERE_INVOKING_VISIBLE_FOR_USER # set by my registry tweak that allows me to open the current directory in mintty(msys2) from Windows Explorer.
# shellcheck disable=SC3028
[ "$OSTYPE" == 'msys' ] && [ "$TERM_PROGRAM" == 'mintty' ] && COLORTERM="truecolor"

##############################################################
#-------------------------------------------------------------
# Hooks
# These statements need to come AFTER any modifications to the prompt occur
#-------------------------------------------------------------
##############################################################
if [ -r "${HOME}/.hooks" ]; then
	source "${HOME}/.hooks"
fi



#TODO: move set and shopt stuff to separate file
