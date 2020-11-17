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

endsWithExe(){
	[[ "${1: -4}" == '.exe' || "${1: -4}" == '.EXE' ]] && echo '0' || echo '1'
}

function addDescription(){
	local psExe="${PSModulePath}../powershell.exe"

	# TODO: There MUST be a better way to do this than repeatedly spawning new powershell processes for each executable. I just dont know what it might be.
	printf "    # $($psExe '(gi C:\Windows\System32\'"\"$1.exe\""').VersionInfo.FileDescription' )" >> "$__DESTDIR/.sys32Aliases"
}

function makeAlias(){
	rm "$__DESTDIR/.sys32Aliases" 2>/dev/null
	touch "$__DESTDIR/.sys32Aliases"

	printf '%*s\n' 79 '#' | tr ' ' '#' >> "$__DESTDIR/.sys32Aliases"
	printf "# All aliases for executables in C:\Windows\System32 are disabled by default.\n" >> "$__DESTDIR/.sys32Aliases"
	printf '%*s\n' 79 '#' | tr ' ' '#' >> "$__DESTDIR/.sys32Aliases"
	# !!!TODO:  Add note containing a list of aliases that are the most likely to be of use

	local store
	declare -i foundASpace=1 # declare is implicitly local, and -i forces integer evaluation

	let local done=0
	let local total="$#"
	for item in $@; do
		printf "\rprogress=${done}/${total}"	# Clear the current line and return to column 0, then indicate the degree of progress
		if [ -n "$store" ]; then # If the last item appears to have been a segment of an executable name
			item="$store $item"
		fi

		if [[ $(endsWithExe "$item") -ne '0' ]]; then # Upon encountering what appears to be an executable containing a space in its name
			store="$item"	# Temporarily store the segment you have
			# printf "\nFound troublesome item fragment. Attempting restoration.\n"
			foundASpace=0
			let done++
			continue
		elif [ $foundASpace -ne 1 ]; then
			# printf "\nFixed to \"$item\"\n"
			store=
			foundASpace=1
		fi


		# Strip the '.exe' extension from the file
		local sansExe="${item%.exe}"
		# Convert any periods in the path to hyphens after removing the extension, because for some reason bash allows alias names to include periods, which I can see being a nuisance.
		local replacedPath="${sansExe//\./\-}"
		# Strip the directory path to the file.
		# If you somehow have a file with a '/' in its name, you can probably blame Microsoft.
		local exeName="${sansExe##*/}"


		printf '# ' >> "$__DESTDIR/.sys32Aliases" # Disable all aliases by default

		# If creating an alias with name=$replacedPath might override something that already exists,
		# prepend the alias with an existance check, and only enable it in the absence of conflict
		[ -n "$(type -t $replacedPath)" ] && printf "[ -z \$(type -t $replacedPath) ] && " >> "$__DESTDIR/.sys32Aliases"
		printf 'alias '"$replacedPath=\"$item\"" >> "$__DESTDIR/.sys32Aliases"
		printf '        Looking for description...'
		addDescription "$exeName"
		let done++
		echo >> "$__DESTDIR/.sys32Aliases"
	done;
}

# Make the cursor visible once again
function fixCursor(){
	tput cnorm
	[ $# -eq 0 ] && exit 1
}

# Call fixCursor if the script receives a Ctrl+C SIGINT
# Of course, there's really nothing that can be done in the event of a SIGKILL or SIGSTOP, so the cursor fixing would have to be done manually in those scenarios.
trap fixCursor INT	

tput civis # Hide the cursor so the user doesn't see it flickering back and forth

# FIXME: use wslpath or cygpath as found to convert path and expand values; replace /c/Windows with $WINDIR
makeAlias $(printf "%s\n" /c/Windows/System32/*.exe)

fixCursor 0 # Unhide the cursor

printf "\nCreated file: $__DESTDIR/.sys32Aliases\n"
