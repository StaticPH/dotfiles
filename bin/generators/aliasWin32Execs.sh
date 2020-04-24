#! /bin/bash

__DESTDIR="${1:-$HOME}" # equivalent to [ -n "$1" ]] && __DESTDIR="$1" || __DESTDIR="$HOME"

function yn(){
	local PS3="$1"
	[ "${PS3:=Enter 1 for Yes, or 2 for No: }" ] # assign PS3 to a default if nothing is passed as an alternative
	local yn
	select yn in Yes No; do
		[[ $yn == 'Yes' ]] && return 0
		[[ $yn == 'No' ]] && return 1
    done
}

if [[ ! -d "$__DESTDIR" ]]; then
	if [ $(yn "$__DESTDIR does not exist. Do you want to create it?") ]; then
		mkdir -p "$__DESTDIR" || (echo "Unable to make directory at $__DESTDIR" && exit 1)
	else
		echo "$(basename $0): Exiting..." || exit 0
	fi
fi

stripexe(){
	echo "${1:0:-4}"
}

endsWithExe(){
    [[ "${1: -4}" == '.exe' || "${1: -4}" == '.EXE' ]] && echo '0' || echo '1'
}

# This requires that 'shopt -s expand_aliases' be set for the environment (global scope)
# alternatively, the powershell alias could be converted into a function, 
# OR 
# the function brackets could be changed from curly brackets to parentheses, 
# effectively turning the function body into a subshell, 
# so 'shopt -s expand_aliases' could then be set within it, but remain unchanged at the global scope
makeAlias(){
	rm $__DESTDIR/.sys32Aliases 2>/dev/null
	touch $__DESTDIR/.sys32Aliases
	local win32="/c/Windows/System32"
	alias powershell="$win32/WindowsPowerShell/v1.0/powershell.exe"

	printf '%*s\n' 79 '#' | tr ' ' '#' >> $__DESTDIR/.sys32Aliases
	printf "# All aliases for executables in C:\Windows\System32 are disabled by default.\n" >> $__DESTDIR/.sys32Aliases
	printf '%*s\n' 79 '#' | tr ' ' '#' >> $__DESTDIR/.sys32Aliases
	# !!!TODO:  Add note containing a list of aliases that are the most likely to be of use

	local store
	declare -i foundASpace=1 # declare is implicitly local, and -i forces integer evaluation
	for item in $@; do
		if [ -n "$store" ]; then # if the last item appears to have been a segment of an executable name
			item="$store $item"
		fi

        if [[ $(endsWithExe "$item") -ne '0' ]]; then # Upon encountering what appears to be an executable containing a space in its name
            store="$item"	# temporarily store the segment you have
			echo "Found troublesome item fragment. Attempting restoration."
            foundASpace=0
            continue
        elif [ $foundASpace -ne 1 ]; then
            echo "Fixed to \"$item\""
            store=
			foundASpace=1
		fi


		local stripped=$(stripexe $item)
		printf '# ' >> $__DESTDIR/.sys32Aliases # Disable all aliases by default

		# If creating an alias with name=$stripped might override something that already exists,
		# prepend the alias with an existance check, and only enable it in the absence of conflict
		[ -n "$(type -t $stripped)" ] && printf "[ -z \$(type -t $stripped) ] && " >> $__DESTDIR/.sys32Aliases
		printf 'alias '"$(stripexe $item)=\"$win32/$item\"" >> $__DESTDIR/.sys32Aliases
		# TODO: There MUST be a better way to do this than repeatedly spawning new powershell processes for each executable. I just dont know what it might be.
		printf "    # $(powershell '(gi C:\Windows\System32\'"\"$item\""').VersionInfo.FileDescription' )\n" >> $__DESTDIR/.sys32Aliases
	done;
}
#makeAlias $(la /c/Windows/System32/ | rg exe | sed "s/\*//")
makeAlias $(ls -A /c/Windows/System32/ | rg '\.exe$' | tr -d '*')
#makeAlias $(ls -A /c/Windows/System32/ | grep -e '\.exe$' | tr -d '*')
# makeAlias "/c/Windows/System32/Pre-boot Manager.exe"

echo "Created file: $__DESTDIR/.sys32Aliases"

unset yn stripexe endsWithExe makeAlias __DESTDIR