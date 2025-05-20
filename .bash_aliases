# -*- shell-script -*-
# shellcheck shell=bash
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.


#---------------------------------------
# Allowing Alias-Expansion-ception!
#---------------------------------------
# From Bash's Info page, section 6.6 Aliases: "If the last character of the alias value is a BLANK,
# then the next command word following the alias is also checked for alias expansion."

# Enable aliases to be sudo'ed
command -v sudo   >/dev/null 2>&1 && alias sudo="sudo "

command -v gksudo >/dev/null 2>&1 && alias gksudo="gksudo "

command -v pkexec >/dev/null 2>&1 && alias pkexec="pkexec "

# This should allow calling exec on an alias
alias exec="exec "

alias nohup="nohup "
command -v winpty >/dev/null 2>&1 && alias winpty="winpty "


#----------------------------------------
# OTHER
#----------------------------------------

alias reloadbash='. ${HOME}/.bashrc'		# Reload bashrc without restarting bash; this may be better off as a function that calls `pushd ~;source "${HOME}/.bashrc"; popd` instead, to ensure tools like direnv can modify the environment.
alias listBuiltins="enable -pa"
alias disable="enable -n"					# More obvious command name for disabling a shell builtin
alias dumpExports="export -p"	# List all the variables being exported to child shells
