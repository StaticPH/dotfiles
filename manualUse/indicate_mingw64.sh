# CUSTOM
# Force the tiny icon in the upper left corner of the window border decorations to match the icon associated with MSYS2 MinGW64 using the OSC I sequence
# Unfortunately, this doesn't always seem to apply to the taskbar icon, an annoyance which likely has something to do with Windows AppIDs
printf "\e]I;/mingw64.ico\a"

# TODO: prepend MinGW64 to the window title?
# MAYBE: distinct color scheme/window theme?
# Unlikely: modify prompt string to indicate presence of environment variables indicating MinGW64
