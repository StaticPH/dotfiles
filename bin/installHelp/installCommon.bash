#! /bin/bash

generalInstall="asciidoc bash-completion bzip2 ca-certificates colordiff colormake-git coreutils curl diffutils \
				dtc findutils flex gawk gcc gdb git grep gzip inetutils info make man-pages-posix nano ncurses \
				openssh openssl-devel pkg-config pkgfile procps-ng psmisc ruby sed sqlite sqlite-compress \
				sqlite-extensions sqlite-icu tar time tree ttyrec tzcode unrar util-linux wget xz"
# libcrypt-devel?

###########################
# Pacman package manager
###########################
if [ -n "$(type -t pacman)" ]; then
	pacman -Syu
	alias pinstall="pacman -S --needed --color=auto"
	# Install these in general
	pinstall "$generalInstall"

	if [ "$OSTYPE" == 'msys' ]; then
		# I remember having a specific reason for wanting openbsd-netcat instead of gnu-netcat, but I don't know what it was.
		pinstall pacman-mirrors mingw-w64-x86_64-go mingw-w64-x86_64-ntldd-git winln winpty openbsd-netcat
		#mingw-w64-i686-octopi-git r941.6df0f8a-1 mingw-w64-x86_64-termcap termbox

	else
		# TODO: packages specific to other systems
		# synaptic maybe?
		pinstall mlocate
	fi
fi

########################
# apt package manager
########################
# TODO: stuff installed through apt or other system package managers
if [ -n "$(type -t apt-get)" ]; then
	if [ -z "$(type -t pacman)" ]; then
		# Only try installing the packages in generalInstall with apt if they definitely were not already installed through pacman in this script.
		apt-get install "$generalInstall"
	fi
	apt-get install "bsdmainutils cpp direnv dpkg fakeroot git-doc git-man install-info lshw lsof ltrace manpages manpages-dev mlocate net-tools netbase netcat-openbsd pslist strace xz-utils"
	#MAYBE: file ftp man-db patchutils htop pciutils time command-not-found im-config lshw-gui
	# On Arch Linux, man-db is responsible for implementing man, and man-pages provides the manpages themselves, according to their oh-so-wonderful wiki
fi

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
gem install --conservative --minimal-deps lolcat manpages rubygems-update
## Optional
# gem install --conservative --minimal-deps binman

#################
# Pip packages
#################
	# TODO: stuff installed through pip
	# TODO: stuff installed through pipx

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
	# GET RUSTUP
	if [ -n "$(type -t rustup)" ]; then
		rustup update
	else #rustup is not available; fix that
		# VERIFY THE AVAILABILITY OF Visual Studio 2019 or the Visual C++ Build Tools 2019

		# Force these values to their supposed default
		# Needed when running msys2 from any drive other than the system drive, because if these are not set,
		# things will install on the system drive, rather than the msys2 user home directory
		[ -v CARGO_HOME ] || CARGO_HOME="${HOME}/.cargo"
		[ -v RUSTUP_HOME ] || RUSTUP_HOME="${HOME}/.cargo"

		# Whichever default toolchain is usually good enough
		# Both msys2 and WSL should be able to install rustup in the same manner as one would on a Unix OS
		if grep -q Microsoft /proc/version || [ "$OSTYPE" == 'msys' ] || [ "$OS" != 'Windows_NT' ]; then
			curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
		elif [ "$OS" == 'Windows_NT' ]; then
			echo "Please visit https://www.rust-lang.org/tools/install to download and run the normal installer for your platform."
			read -s -r -p "Once you have completed the install process, press Enter to continue..."
		fi
	fi
	# rustup toolchain install stable-gnu
	cargo install cargo-show cargo-update cargo-whatfeatures hyperfine cargo-cache cargo-feature fd-find durt tabulate bat ripgrep git-delta
	echo "See 'rustup completion --help' for instructions on generating/updating shell completion for rustup and cargo"


#TODO: intelligently try to install ripgrep and other crates through the system package manager, and only install it via cargo as a fallback?
