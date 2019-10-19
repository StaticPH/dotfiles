#! ~/bin/bash

generalInstall="asciidoc bash-completion bzip2 ca-certificates colordiff colormake-git coreutils curl diffutils \
				dtc findutils flex gawk gcc gdb git grep gzip inetutils make man-pages-posix nano ncurses \
				openssh openssl-devel pkg-config pkgfile procps-ng psmisc ruby sed sqlite sqlite-compress \
				sqlite-extensions sqlite-icu tar time tree ttyrec tzcode unrar util-linux wget xz"
# libcrypt-devel?

###########################
# Pacman package manager
###########################
if [ -n $(type -t pacman) ]; then
	pacman -Syu
	alias pinstall="pacman -S --needed --color=auto"
	if [[ $OSTYPE == 'msys' ]]; then
		pinstall pacman-mirrors mingw-w64-x86_64-go mingw-w64-x86_64-ntldd-git winln winpty openbsd-netcat 
		#mingw-w64-i686-octopi-git r941.6df0f8a-1 mingw-w64-x86_64-termcap termbox

	else
		# TODO: packages specific to other systems
		# synaptic maybe?
	fi
	# Install these in general
	pinstall "$generalInstall"
fi	

########################
# apt package manager
########################
	# TODO: stuff installed through apt or other system package managers
	apt-get install "bsdmainutils cpp direnv dpkg fakeroot git-doc git-man install-info lsof ltrace manpages manpages-dev mlocate net-tools netbase netcat-openbsd pslist strace xz-utils"
	#MAYBE: file ftp man-db patchutils
	
####################
# curl/wget based
####################
	# TODO: stuff installed through curl or wget, like rustup 

##############
# VCS based
##############
	# TODO: Things that need to be gotten from git and installed another way

##############
# Ruby gems
##############
gem install lolcat

#################
# Pip packages
#################
	# TODO: stuff installed through pip

#####################
# Node.js packages
#####################
	# TODO: stuff installed through npm/pnpm/yarn/bower/whatever-else

################
# Go packages
################
	# TODO: stuff installed through go

#########################
# Rust crates/packages
#########################
	# TODO: stuff installed through cargo
	
	
	
#TODO: intelligently try to install ripgrep through the system package manager, and only install it via cargo as a fallback