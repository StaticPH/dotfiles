To make GTK windows use the usual window decorations, instead of just having the "close" button, use the following command:
`gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'`
<sub>Alternatively, try `gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'`</sub>
You may need to prefix with `sudo`.
