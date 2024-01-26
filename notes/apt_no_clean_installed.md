To prevent Apt from erasing retrieved package files for _currently installed_ packages when using `apt autoclean`,
create `/etc/apt/apt.conf.d/99z_no_autoclean_installed` and write to it
```
APT::Clean-Installed "off";
```

As a single command: `printf 'APT::%s;\n' 'Clean-Installed "off"' | sudo tee /etc/apt/apt.conf.d/99z_no_autoclean_installed`
