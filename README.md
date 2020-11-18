# dotfiles

I have not tested, but I suspect that line endings for files may need to be changed depending on the system.

### Help on line ending normalization:
https://git-scm.com/docs/gitattributes/2.9.4<br>
_gitattributes_ file should be at `echo "$(git --exec-path 2>/dev/null)" | sed "s/libexec.*/etc\/gitattributes/"`

### Cargo crates:
* cargo-show			—	Should really be a built-in feature
* cargo-update			—	Should really be a built-in feature
* cargo-whatfeatures	—	Should really be a built-in feature
* hyperfine				—	Benchmarking tool
* ripgrep				—	grep-like tool which is much better for searching recursively
* fd-find				—	Find files within a path fast, maybe do something with them
* cargo-cache			—	When cargo clean isn't good enough
* cargo-feature			—	Convenient tool for changing enabled features of installed crates
* durt					—	Calculate the size of a directory and all of the files within, displaying the results
* tabulate				—	A tool that helps format data into nice tables
* bat					—	cat, but with syntax highlighting and a few other niceties
* genact				—	Honestly, this one I just keep for the amusement
* git-delta				—	Powerful diff tool with support for side-by-side view and git repository diffs

	Note: Does not appear to work in mintty, or at least not with my current setup (but I suspect the former)
* desed					—	Debug sed commands pseudo-interactively

### Python packages installed via pipx:
* ipython				—	Powerful Python REPL
* litecli				—	CLI for SQLite databases with auto-completion and syntax highlighting

	Note: The version of icdiff on PyPI has been out of date for a while now. Install manually from the GitHub repository. Coercing pipx may require some effort.
* icdiff				—	Show more granular differences between files in a colored 2-column view; supports git repository diffs with included git-icdiff shell script

### Ruby gems:
* lolcat				—	Output text in rainbow colors!
* manpages				—	Adds support for man pages to rubygems
* rubygems-update		—	Update gem itself
* binman				—	(Optional) Generate man pages from comment headers

### Installed as standalone binaries and scripts:
* jq					—	Command line JSON processor
* shellcheck			—	Static analysis tool for shell scripts
* mandelbrot			—	Just because, a modified version of Charles Cooke's 16-color Mandelbrot https://gist.github.com/ormaaj/3369392
* fzf					—	Fuzzy finder
* pandoc				—	General markup converter
* imagemagick			—	Command line image processing swiss army knife; see also GraphicsMagick
* pip-autoremove		—	Remove a package and its unused dependencies
* mvn					—	Apache Maven build automation tool; typically used for Java projects

	Note: Unsuprisingly, does not work with Windows' ping command
* prettyping			—	A wrapper around the standard ping tool, making the output prettier and easier to read

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

# WIP:
* Add git and python venv integration to prompts

# TODO:
* Add svn integration to prompts
* Improve git integration for prompts
* Investigate pipipxx, pyvenv, rbenv
