# dotfiles
<!-- TODO: DECIDE HOW TO SHOW LINKS TO EXTERNAL TOOLS AND INFORMATION WITHOUT ALSO MAKING THE RAW MARKDOWN FEEL TOO CLUTTERED-->
### Cargo crates:
* cargo-show			—	Should really be a built-in feature.
* cargo-update			—	Should really be a built-in feature.
* cargo-whatfeatures	—	Should really be a built-in feature.
* hyperfine				—	Benchmarking tool.
* ripgrep				—	A `grep`-like tool which is much better for searching recursively.
* fd-find				—	Find files within a path fast, maybe do something with them.
* cargo-cache			—	When `cargo clean` isn't good enough.
* cargo-feature			—	Convenient tool for changing enabled features of installed crates.
* durt					—	Calculate the size of a directory and all of the files within, displaying the results.
* tabulate				—	A tool that helps format data into nice tables.
* bat					—	Like `cat`, but with syntax highlighting and a few other niceties.
* genact				—	Honestly, this one I just keep for the amusement.
* git-delta				—	Powerful diff tool with support for side-by-side view and Git repository diffs <sup>[1]</sup>.
* sccache				—	Basically `ccache` with support for cloud storage and Rust binaries <sup>[1]</sup>.
* ptail					—	`tail -f`, but only show a certain number of lines at a time.
* miniserve				—	Easy and surprisingly capable http server with support for file uploading <sup>[1]</sup>.
* runiq					—	Filter duplicate entries from textual input without inherently sorting the output.
* mdcat					—	Like `cat`, but for markdown.
* desed					—	Debug `sed` commands pseudo-interactively <sup>[2]</sup>.
* interactive-rebase-tool	—	TUI for `git rebase -i`. AKA girt/girt-git <sup>[3]</sup>.
* dprint				—	Code formatter for a handful of languages. One of annoyingly few decent JavaScript formatters that don't require NodeJS to run <sup>[1]</sup>.
* gping					—	Ping command, but with a graph <sup>[1]</sup>.
* git-hist				—	A CLI tool to quickly browse the git history of files on a terminal.
* shellharden			—	A syntax highlighter and a tool to semi-automate the rewriting of scripts to ShellCheck conformance, mainly focused on quoting.

<sub>(1): Standalone binary can also be downloaded with the `program-fetch` utility.</sub><br>
<sub>(2): NOTE: This does not appear to work in Mintty, or at least not with my current setup (but I suspect the former).</sub><br>
<sub>(3): Because of how I have my current Windows machine set up, I am unable to use this by configuring Git's `sequence.editor` to call it automatically for `git rebase -i`; use the `irebase` wrapper script instead.</sub>

[cargo_show]: https://github.com/g-k/cargo-show
[cargo_update]: https://github.com/nabijaczleweli/cargo-update
[cargo_whatfeatures]: https://github.com/museun/whatfeatures
[hyperfine]: https://github.com/sharkdp/hyperfine
[ripgrep]: https://github.com/BurntSushi/ripgrep
[fd_find]: https://github.com/sharkdp/fd
[cargo_cache]: https://github.com/matthiaskrgr/cargo-cache
[cargo_feature]: https://github.com/Riey/cargo-feature
[durt]: https://github.com/cauebs/durt
[tabulate]: https://github.com/mbudde/tabulate
[bat]: https://github.com/sharkdp/bat
[genact]: https://github.com/svenstaro/genact
[delta]: https://github.com/dandavison/delta
[sccache]: https://github.com/mozilla/sccache
[ptail]: https://github.com/orf/ptail
[miniserve]: https://github.com/svenstaro/miniserve
[runiq]: https://github.com/whitfin/runiq
[mdcat]: https://github.com/swsnr/mdcat
[desed]: https://github.com/SoptikHa2/desed
[interactive_rebase]: https://github.com/MitMaro/git-interactive-rebase-tool
[dprint]: https://github.com/dprint/dprint
[gping]: https://github.com/orf/gping
[git_hist]: https://github.com/arkark/git-hist
[shellharden]: https://github.com/anordal/shellharden

[spotify_tui]: https://github.com/Rigellute/spotify-tui
<!-- ?spotifyd / librespot? -->
<!-- mandown -->
<!-- cargo-xwin, cargo-lock -->
<!-- On windows, copycat can be useful for clipboard i/o -->

### Python packages installed via pipx:
* ipython				—	Powerful Python REPL.
* litecli				—	CLI for SQLite databases with auto-completion and syntax highlighting.
* ~~git-filter-repo		—	Quickly rewrite Git repository history (filter-branch replacement).~~ Installed via some package manager in all cases.
* icdiff				—	Show more granular differences between files in a colored 2-column view; supports Git repository diffs with included `git-icdiff` shell script <sup>[1]</sup>.
* sqlitebiter			—	A CLI tool to convert CSV, Excel, HTML, JSON, and more to a SQLite database file

<sub>(1): NOTE: The version of `icdiff` on PyPI has been out of date for a while now. Install manually from the GitHub repository. Coercing `pipx` may require some effort.</sub>

[ipython]: https://ipython.org/
[litecli]: https://github.com/dbcli/litecli
[git-filter-repo]: https://github.com/newren/git-filter-repo
[icdiff]: https://github.com/jeffkaufman/icdiff
[sqlitebiter]: https://github.com/thombashi/sqlitebiter

### Ruby gems:
* lolcat				—	Output text in rainbow colors!
* manpages				—	Adds support for man pages to rubygems.
* rubygems-update		—	Update the `gem` utility itself.
* binman				—	(Optional) Generate man pages from comment headers.
* unibits				—	(Optional) Visualize different Unicode encodings in the terminal.
* uniscribe				—	(Optional) Describes Unicode characters with their name and shows compositions.

[lolcat]: https://github.com/busyloop/lolcat
[manpages]: https://github.com/bitboxer/manpages
[gems-update]: https://rubygems.org/gems/rubygems-update
[binman]: http://github.com/sunaku/binman
[unitbits]: https://github.com/janlelis/unibits
[uniscribe]: https://github.com/janlelis/uniscribe

### Installed as standalone binaries and scripts (~/.local/bin):
* ~~jq					—	Command line JSON processor~~ Installed via some package manager in all cases.
* shellcheck			—	Static analysis tool for shell scripts <sup>[1]</sup>.
* mandelbrot			—	Just because, a modified version of Charles Cooke's 16-color Mandelbrot.
* fzf					—	Fuzzy finder.
* pandoc				—	General markup converter <sup>[1]</sup>.
* imagemagick			—	Command line image processing swiss army knife; see also GraphicsMagick.
* pip-autoremove		—	Remove a package and its unused dependencies.
* mvn					—	Apache Maven build automation tool; typically used for Java projects.
* showimg				—	Displays a number of image formats in Mintty; see https://github.com/mintty/utils
* prettyping			—	A wrapper around the standard `ping` tool, making the output prettier and easier to read <sup>[2]</sup>.
* treef					—	Reads paths from stdin and formats them as a tree, like the tree utility.

<sub>(1): Standalone binary can also be downloaded with the `program-fetch` utility.</sub><br>
<sub>(2): NOTE: Unsurprisingly, does not work with Windows' `ping` command.</sub>

[jq]: https://github.com/stedolan/jq
[shellcheck]: https://github.com/koalaman/shellcheck
[mandel]: https://gist.github.com/ormaaj/3369392
[fzf]: https://github.com/junegunn/fzf
[pandoc]: https://pandoc.org/
[imagemagick]: https://imagemagick.org
[graphicsmagick]: http://www.graphicsmagick.org
[pip_arm]: https://github.com/tresni/pip-autoremove
[maven]: https://maven.apache.org
[showimg]: https://github.com/mintty/utils/blob/master/showimg
[prettyping]: http://denilson.sa.nom.br/prettyping/
[treef]: https://github.com/jacwah/treef

### Fonts
* DejaVu Sans Mono Nerd Font Complete
* (Optional) Noto Emoji Nerd Font Complete
* (Optional) Twemoji (Color)
* (Optional) Apple Color Emoji
* (Optional) Cascadia Code
* (Optional) Hasklig
* (Optional) Roboto Mono

### Other
* JDK 1.8

<!-- Other software of note, not yet categorized appropriately:
nuitka (python), currently installed via system package manager, formerly with pipx
poetry (python)
pipenv (python)
pyinstaller (python)
yolk (python)
py-spy (python)
ydiff (diff tool in python)
direnv (general, possibly the Go variant)
lsix (general/fun)
ntldd (Windows dll/exe tool)
rename (PERL-script version) (general)
showterm (bash-script version) (general)
makefile2graph (makefile dependency and flow visualization)
awklib (general)
adb (android tool)
gimp
spotify-qt
spotifyd and/or librespot
vlc
miktex (provides pdflatex for use with pandoc)
-->

# X11
Make numpad behave the way I always expect it to:
	`setxkbmap -model pc105 -layout us -rules evdev -option "lv3:ralt_switch" -option "numpad:microsoft"`

# Windows-only improvements to Python virtualenv activation
The `patch-python-venv-activate` script is used to patch the default venv activation script<sup>[1][2]</sup>, to implement the following changes:<br>
	-- Allow restoration of existing python aliases(and functions) in MSYS2 (system python, not MSYS2) upon venv deactivation.<br>
	-- Automatically alias python to use winpty and the venv specific python executable (sometimes simply changing the path is insufficient).<br>
	-- Alias `_python` to use the venv specific python executable WITHOUT winpty (unalias upon deactivation).<br>
	-- Automatically alias pip to use the venv specific python executable.<br>
NOTE: Although remembering existing aliases (or wrapper functions) for pip is possible, it is not currently supported through this patch.<br>
NOTE: Use of this patch opens up the possibility of executing malicious code upon deactivating a venv. USE AT YOUR OWN RISK!<br>
NOTE: This script and the patch it applies are intended ONLY for use on Microsoft Windows operating systems, expects the use of a Python install targetting Windows, and assumes winpty and cygpath executables are on the system PATH.<br>

<sub>(1): This can normally be found at "<PATH_TO_SYSTEM_PYTHON_INSTALL>/Lib/venv/scripts/common/activate".</sub><br>
<sub>(2): Though it is recommended to patch the default activation script, which is used as a template when creating new virtual environments, this script can also be applied to the activation script for specific virtual environments on an individual basis, which will be necessary to apply the change to existing virtual environments.</sub>

# WIP:
* Add git and python venv integration to prompts.

# TODO:
* Add svn integration to prompts.
* Improve git integration for prompts.
* Investigate pipipxx, pyvenv, rbenv.
* Rewrite nanorc file for markdown; probably reference my existing one and the version provided by nano itself.
* Finagle with nanorc syntax for nanorc files in an attempt to eliminate highlighting overlap between menus, functions, and options.

# Notes:

<ul>
	<li>
		I've been informed that ansi escape codes, at least for color, may not work on MacOS if using the <code>\e</code> or <code>\033</code> prefix.
		If that is indeed the case, instances of those will likely need to be replaced with <code>\x1B</code>.
		However, as I haven't been using a Mac for anything, and don't particularly expect that to change for the near future, I currently see no real need for me to change anything.
		This note is really just here for posterity.
	</li>
	<li>
		Version 1.2.1 of the interactive-rebase-tool, which used pancurses, seems to be more cooperative on my machine than subsequent versions, which use crossterm. And by "more cooperative", I mean "properly responds to keyboard input, and is just actually usable". I'm fairly confident this is a problem with my setup, though, rather than with the implementation of the tool itself.
	</li>
</ul>



### Help on line ending normalization:
I have not tested, but I suspect that line endings for files may need to be changed depending on the system.

For system-global configurations, a [_gitattributes_][gitattrdocs] file should be at `echo "$(git --exec-path 2>/dev/null)" | sed "s/libexec.*/etc\/gitattributes/"`

[gitattrdocs]: https://git-scm.com/docs/gitattributes
