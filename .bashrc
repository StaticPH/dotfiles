# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# ~/.bashrc: executed by bash(1) for interactive shells.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the msys2 mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
# See man bash for more options...  also info set
#-------------------------------------------------------------
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Include filenames beginning with '.' in the results of filename expansion.
# shopt -s dotglob
#
# Attempt to save all lines of a multi-line command in the same history entry. On by default.
# shopt -s cmdhist
#
# Expand backslash-escape sequences in echo by default
# shopt -s xpg_echo
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# shopt -s completion_strip_exe
# Disable completion when the input buffer is empty.  i.e. Hitting tab 
# and waiting a long time for bash to expand all of $PATH. 
shopt -s no_empty_cmd_completion

# Aliases can use the programmable completion for the command they alias
shopt -s progcomp_alias >/dev/null 2>&1 

# Check that a command found in the hash table exists before trying to execute it. If it doesnt, a normal path search is performed.
shopt -s checkhash

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
# Any completions you add in ~/.bash_completion are sourced last.
# [ -r /etc/bash_completion ] && . /etc/bash_completion
# MAY CAUSE NOTICABLE IMPACT ON SPEED OF LOADING BASH

# History Options
#-------------------------------------------------------------
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls:which:pwd:clear:cls' # Ignore some other commands as well
#
HISTIGNORE=$'[ \t]*:&:[fb]g:exit:clear:cls:history:history -a'
HISTIGNORE=$HISTIGNORE':npp:explorer:pacDump:path:ls_symbols:la:ls:env'
HISTIGNORE=$HISTIGNORE':svn status:git status:git log'
#:privateIron:extensionsPrivateIron:privateBatch'
export HISTIGNORE
# export HISTFILESIZE=-1 # Enable this for unlimited history file length

# I want to store command history forever, but having to parse really long history files can slow down bash.
# To avoid that issue, when the history file exceeds 450 lines, dump the contents of the history file into another file that bash wont parse on load.
# Then, truncate the history file.

if [[ $( < $HISTFILE wc -l) -ge 450 ]]; then
	echo Saving history to long term storage
	[ ! -d ~/txts ] && mkdir ~/txts
	cat ~/.bash_history >> ~/txts/full.bash_history
	> $HISTFILE
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


# Aliases
### Some people use a different file for aliases
#-------------------------------------------------------------
if [ -r "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi


# Umask
#-------------------------------------------------------------
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
### Some people use a different file for functions
#-------------------------------------------------------------
if [ -r "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

if [ "$OS" == 'Windows_NT' ]; then
	if [ -r ~/.winAliases &&  -r ~/.sys32Aliases ]; then
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

[ -v CHERE_INVOKING_VISIBLE_FOR_USER ] && unset CHERE_INVOKING_VISIBLE_FOR_USER # set by my registry tweak that allows me to open the current directory in msys2 from Windows Explorer.


##############################################################
#-------------------------------------------------------------
# Hooks
# These statements need to come AFTER any modifications to the prompt occur
#-------------------------------------------------------------
##############################################################
if [ -r "${HOME}/.bash_hooks" ]; then
	source "${HOME}/.bash_hooks"
fi
