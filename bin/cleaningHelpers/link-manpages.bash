#! /bin/bash 
# -vfx

# Create symbolic links in $destination/ for external git manpages. 

dbg=0
destination="/opt/adtlManPages"

# function __slice(){
	# [[ $# -ne 2 ]] && return 1
	# str=$1
	# let maxslice=$(echo $str | wc -m )-1
	# len=$2
	# [[ $len -gt $maxslice ]] && return 1
	# echo "${str: len}"
# }
# function strtail(){
        # [[ $# -ne 2 ]] && return 1
        # ret=$(__slice $1 -$2)
        # [[ ret == 1 ]] && return 1
        # echo "$ret" && return 0
# }
# function strhead(){
        # [[ $# -ne 2 ]] && return 1
        # ret=$(__slice $1 $2)
        # [[ ret == 1 ]] && return 1
        # echo "$ret" && return 0
# }

function strtail(){
	[[ $# -ne 2 ]] && return 1
	str=$1
	let maxslice=$(echo $str | wc -m )-1
	len=$2
	[[ $len -gt $maxslice ]] && return 1
	echo "${str: -len}"
}

startloc="$(pwd)"
function search() {
	local src=
	local tfolder=
	# echo "#args = $#"
	if [[ "$#" == 1 ]]; then
		pushd $1 >/dev/null 2>&1
		src="$(pwd)"
		popd >/dev/null 2>&1
		[[ "$dbg" != 0 ]] && echo "src = $src"

		tfolder="$(echo $src| sed 's/.*\///')"
		[[ "$dbg" != 0 ]] && echo "FOLDER IS: $tfolder"

		[[ -d "$destination/$tfolder/$tfolder" ]] || mkdir -p "$destination/$tfolder/"

		for file in $(ls "$src"); do
			if [[ $(type -t $file) == '' ]]; then #not sure what should happen when this is false, but let's cross that bridge when we come to it
				[[ "$dbg" != 0 ]] && echo "$src/$file" to "$destination/$tfolder/$file"
				winln -s "$src/$file" "$destination/$tfolder/"
			fi
		done
		return
	fi

	for file in $(ls $*); do
		# echo tail="$file"
		# echo tail="$(strtail $file 1)"
		if [[ "$(strtail $file 1)" == ":" ]]; then
			src=
			[[ "$dbg" != 0 ]] && echo "src should be empty		src=\"$src\""

			src="$(echo $file| sed 's/\://')"
			[[ "$dbg" != 0 ]] && echo "srcB=$src"

			[[ -d "$src" ]] && src="$(echo $src | sed 's/\.\///')"
			[[ "$dbg" != 0 ]] && echo "srcC=$src"

			pushd "$src" >/dev/null 2>&1
			src="$(pwd)"
			popd >/dev/null 2>&1
			[[ "$dbg" != 0 ]] && echo "src is $src"

			tfolder="$(echo $src| sed 's/.*\///')"
			[[ "$dbg" != 0 ]] && echo "FOLDER IS: $tfolder"

			[[ -d "$destination/$tfolder/$tfolder" ]] || mkdir -p "$destination/$tfolder/"

		elif [[ $(type -t $file) == '' ]]; then
			[[ "$dbg" != 0 ]] && echo "$src/$file" to "$destination/$tfolder/$file"
			winln -s "$src/$file" "$destination/$tfolder/"
		fi
	done
}

# https://github.com/gitster/git-manpages
# search ./git-manpages/*
search "/d/Program Files (x86)/Git/mingw32/share/man/git-manpages/*"

