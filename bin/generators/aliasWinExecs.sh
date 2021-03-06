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

# echo "TODO: Decide on a permananent home for the resulting alias file to live in, so that it can be consistently found in the same place."

makeAlias(){
	rm $__DESTDIR/.winAliases 2>/dev/null
	touch $__DESTDIR/.winAliases
	for item in "$@"; do
#		echo "item=$item"
		local sansPath="${item##*/}"
		if [[ "$sansPath" != "write.exe" ]];then
			# We probably shouldn't assume the length of the path before the executable name (11)
			# echo "alias ${item:11:-4}=\"$item\"" >> $__DESTDIR/.winAliases
			echo "alias ${sansPath%.exe}=\"$item\"" >> $__DESTDIR/.winAliases
		else
			echo "alias wordpad=\"$item\"" >> $__DESTDIR/.winAliases
		fi
	done;
}
exclude="bfsvc|hh|splwow64|winhlp32|explorer|HelpPane|py|pyw|IsUninst"
makeAlias $(printf "%s\n" /c/Windows/*.exe | grep -E --invert-match "$exclude")


# Just a few other miscellaneous aliases for executables scattered about
cat << EOF >> $__DESTDIR/.winAliases
[ -d /c/Windows/System32/WindowsPowerShell/v1.0/ ] && \
	alias powershell="/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
[ -d /c/Windows/System32/WindowsPowerShell/v2.0/ ] && \
	alias powershell2="/c/Windows/System32/WindowsPowerShell/v2.0/powershell.exe" # TODO: Verify that this actually works
EOF

echo "Created file: $__DESTDIR/.winAliases"
unset yn makeAlias exclude __DESTDIR