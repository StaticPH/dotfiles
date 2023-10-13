WSL2 is capable of accessing and using the Windows host's browser, but it doesn't do so by default.
One easy way to trick it into doing so, is with a properly named shell script in your `PATH`.

This example, for Google Chrome, is a single-lined file named `google-chrome`:
```sh
#! /usr/bin/env -S "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" --profile-directory="Default"

```
Where the Windows path to the chrome executable is `C:\Program Files\Google\Chrome\Application\chrome.exe`,
and "Default" is the name of the browser profile to use.

With such a script in the `PATH`, and it's executable bit set,
anything relying on `xdg-open` should be able to find it and interact as though it were a WSL2 native browser executable.

As a one-liner, with the resultant wrapper script residing in `~/.local/bin/` (assuming that directory is already on your `PATH`):
```sh
echo '#! /usr/bin/env -S "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" --profile-directory="Default" > ~/.local/bin/google-chrome && chmod +x ~/.local/bin/google-chrome
```
