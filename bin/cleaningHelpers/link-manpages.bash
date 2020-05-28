#! /bin/bash
# -vfx

#TODO: CLEANUP THIS MESS

[ "$OSTYPE" == 'msys' -a -z "$(type -t winln)" ] && echo "Please install winln"; exit 1

if [ "$OSTYPE" == 'msys' ]; then
	function lnk(){
		command winln $@
	}
else
	function lnk(){
		command ln $@
	}
fi
}

# Create symbolic links in $destination/ for external git manpages.
function __lnkManuals(){
	local dbg=0
	local destination="/opt/adtlManPages"

	# function __slice(){
		# [[ $# -ne 2 ]] && return 1
		# local str=$1
		# let maxslice=$(echo $str | wc -m )-1
		# local len=$2
		# [[ $len -gt $maxslice ]] && return 1
		# echo "${str: len}"
	# }
	# function strtail(){
			# [[ $# -ne 2 ]] && return 1
			# local ret=$(__slice $1 -$2)
			# [[ ret == 1 ]] && return 1
			# echo "$ret" && return 0
	# }
	# function strhead(){
			# [[ $# -ne 2 ]] && return 1
			# local ret=$(__slice $1 $2)
			# [[ ret == 1 ]] && return 1
			# echo "$ret" && return 0
	# }

	function strtail(){
		[[ "$#" -ne 2 ]] && return 1
		local str="$1"
		let maxslice=$(echo $str | wc -m )-1
		local len="$2"
		[[ "$len" -gt "$maxslice" ]] && echo "slice cannot exceed length of string" && return 1
		echo "${str: -len}"
	}

	local startloc="$(pwd)"
	function search() {
		local src
		local tfolder
		# echo "#args = $#"
		if [[ "$#" == 1 ]]; then
			pushd "$1" >/dev/null 2>&1
			src="$(pwd)"
			popd >/dev/null 2>&1
			[[ "$dbg" != 0 ]] && echo "src = $src"

			tfolder="$(echo $src | sed 's/.*\///')"
			[[ "$dbg" != 0 ]] && echo "FOLDER IS: $tfolder"

			[[ -d "$destination/$tfolder/$tfolder" ]] || mkdir -p "$destination/$tfolder/"

			for file in $(ls "$src"); do
				if [ -z "$(type -t $file)" ]; then #not sure what should happen when this is false, but let's cross that bridge when we come to it
					[[ "$dbg" != 0 ]] && echo "$src/$file" to "$destination/$tfolder/$file"
					lnk -s "$src/$file" "$destination/$tfolder/"
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

			elif [ -z "$(type -t $file)" ]; then
				[[ "$dbg" != 0 ]] && echo "$src/$file" to "$destination/$tfolder/$file"
				lnk -s "$src/$file" "$destination/$tfolder/"
			fi
		done
	}

	# https://github.com/gitster/git-manpages
	# search ./git-manpages/*
	search "/d/Program Files (x86)/Git/mingw32/share/man/git-manpages/*"
}

__lnkManuals
unset __lnkManuals lnk