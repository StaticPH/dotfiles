# dotfiles

I have not tested, but I suspect that line endings for files may need to be changed depending on the system.

# Help on line ending normalization:
https://git-scm.com/docs/gitattributes/2.9.4
__gitattributes__ file should be at `echo "$(git --exec-path 2>/dev/null)" | sed "s/libexec.*/etc\/gitattributes/"`

# TODO:
* Add git and svn integration to prompts