If unable to save changes made with gconf/dconf and/or gsettings, try including the following in your bashrc/zshrc file:
```bash
## Fix g/dconf and gsettings nonsense preventing saving settings.
# shellcheck disable=2046
export $(dbus-launch)
```
