To prevent Apt from automatically installing recommended or suggested packages, create `/etc/apt/apt.conf.d/99z_auto_no_recommends` and write to it
```
APT::Install-Recommends "false";
APT::Install-Suggests "0";
```

As a single command: `printf 'APT::%s;\n' 'Install-Recommends "false"' 'Install-Suggests "0"' | sudo tee /etc/apt/apt.conf.d/99z_auto_no_recommends`
