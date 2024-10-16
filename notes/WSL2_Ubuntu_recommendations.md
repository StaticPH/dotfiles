# General packages not installed by default:
* binfmt-support
	> This package provides an 'update-binfmts' script with which package
	>  maintainers can register interpreters to be used with this module without
	>  having to worry about writing their own init.d scripts, and which sysadmins
	>  can use for a slightly higher-level interface to this module.
* tree
* rename
	> Supports renaming files using Sed-replacement-like Perl expressions
* xdg-utils
* gdb
* ltrace
* strace
* libtree
	> `ldd`, but as a tree, and explaining why shared libraries are or are not found
* net-tools 
* colormake

* icdiff
	> Just more human-friendly than regular `git-diff` output.
	> Ideally, this would be installed through something like `pipx` (which itself would ideally be installed from a MUCH more recent release than is available from the Jammy repositories)
	> or https://github.com/astral-sh/uv
	>  https://github.com/astral-sh/uv/issues/3560
	>  https://github.com/astral-sh/uv/issues/2248



# Help fix some annoying console spam and missing icons from many GUI apps
* adwaita-icon-theme + (adwaita-icon-theme-full || (humanity-icon-theme + oxygen-cursor-theme))
* gsettings-desktop-schemas
* gtk-update-icon-cache
* dconf-gsettings-backend
* desktop-file-utils
* libgtk-3-bin
* mesa-utils
	> (depends on `mesa-utils-bin`)
* va-driver-all
	> Video acceleration driver meta-package
* x11-common
* ?x11-xkb-utils?
* x11proto-dev
	> (dependency for other x11-related *-dev packages)
* xclip
* ?xdg-dbus-proxy?
	> (`flatpak` dependency)

# SEE ALSO: ./notes/WSL2_gtk_tweaking.md
# SEE OTHER NOTES FILES

Side note: There's a long-standing bug with WSLg apps that we should definitely state very clearly in our own documentation;
the issue with apps being invisible and/or non-responsive after the computer returns from sleep/hibernate
