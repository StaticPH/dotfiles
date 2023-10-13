This fix is mostly relevant to Ubuntu and its derivatives, and [**requires sudo version 1.9.6 or newer**][min_sudo_version].<br>
Additionally, `sudo` must have been configured with the `--enable-admin-flag` option.

To prevent `sudo` from ever creating a `.sudo\_as\_admin\_successful` file anywhere, create `/etc/sudoers.d/hide_admin_successful_file` and write to it:
```
Defaults !admin_flag
```

As a single command: `printf 'Defaults !admin_flag\n' | sudo tee /etc/sudoers.d/hide_admin_successful_file > /dev/null`

In all likelihood, if `~/.sudo_as_admin_successful` is being created, it is also probably being checked for in `/etc/bash.bashrc`.<br>
Remove or comment out the check to prevent being pestered by sudo hints at the start of every session.

[min_sudo_version]: https://github.com/sudo-project/sudo/releases/tag/SUDO_1_9_6

