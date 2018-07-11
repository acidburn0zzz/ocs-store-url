# OCS-URL specification

OCS-URL is a custom URL that represent the installation method of items served on OpenCollaborationServices (OCS).


## URL structure

    [scheme]://[command]?[query string]

For example:

    ocs://install?url=http%3A%2F%2Fexample.com%2Ficons.tar.gz&type=icons


## Scheme

Scheme | Description
-------|------------
ocs | ocs scheme
ocss | ocs scheme for secure protocol

"ocss" scheme is the same of the ocs scheme for now,
it's a reserved name for secure protocol in the future.


## Command

Command | Description
--------|------------
download | Download the file from specified URL to the installation destination of specified install-type.
install | Make file downloading and trigger installation process.


## Query string

OCS-URL's query string is an option of command.

*All query string values should be urlencoded.*

Parameter | Required | Default | Description
----------|----------|---------|------------
url | Yes | - | File URL
type | - | downloads | Install-type
filename | - | File name from URL | Alternative file name

"filename" option is useful if the file URL does not represent a file name.

### Install-type

Available install-type:

Install-type | Installation destination
-------------|------------------
bin | $HOME/.local/bin
downloads | $HOME/Downloads
documents | $HOME/Documents
pictures | $HOME/Pictures
music | $HOME/Music
videos | $HOME/Videos
wallpapers | $XDG_DATA_HOME/wallpapers
fonts | $HOME/.fonts
cursors | $HOME/.icons
icons | $XDG_DATA_HOME/icons
emoticons | $XDG_DATA_HOME/emoticons
themes | $HOME/.themes
emerald_themes | $HOME/.emerald/themes
enlightenment_themes | $HOME/.e/e/themes
enlightenment_backgrounds | $HOME/.e/e/backgrounds
fluxbox_styles | $HOME/.fluxbox/styles
pekwm_themes | $HOME/.pekwm/themes
icewm_themes | $HOME/.icewm/themes
plasma_plasmoids | $XDG_DATA_HOME/plasma/plasmoids
plasma_look_and_feel | $XDG_DATA_HOME/plasma/look-and-feel
plasma_desktopthemes | $XDG_DATA_HOME/plasma/desktoptheme
kwin_effects | $XDG_DATA_HOME/kwin/effects
kwin_scripts | $XDG_DATA_HOME/kwin/scripts
kwin_tabbox | $XDG_DATA_HOME/kwin/tabbox
aurorae_themes | $XDG_DATA_HOME/aurorae/themes
dekorator_themes | $XDG_DATA_HOME/deKorator/themes
qtcurve | $XDG_DATA_HOME/QtCurve
color_schemes | $XDG_DATA_HOME/color-schemes
gnome_shell_extensions | $XDG_DATA_HOME/gnome-shell/extensions
cinnamon_applets | $XDG_DATA_HOME/cinnamon/applets
cinnamon_desklets | $XDG_DATA_HOME/cinnamon/desklets
cinnamon_extensions | $XDG_DATA_HOME/cinnamon/extensions
nautilus_scripts | $XDG_DATA_HOME/nautilus/scripts
amarok_scripts | $KDEHOME/share/apps/amarok/scripts
yakuake_skins | $KDEHOME/share/apps/yakuake/skins
cairo_clock_themes | $HOME/.cairo-clock/themes
books | $APP_DATA/books
comics | $APP_DATA/comics

$APP_DATA is not environment variable, it's internal variable in the program and expressed to $XDG_DATA_HOME/{application ID or name}.

Available alias name of the install-type:

Alias | Install-type
------|-------------
gnome_shell_themes | themes
cinnamon_themes | themes
gtk2_themes | themes
gtk3_themes | themes
metacity_themes | themes
xfwm4_themes | themes
openbox_themes | themes
kvantum_themes | themes
compiz_themes | emerald_themes
beryl_themes | emerald_themes
plasma4_plasmoids | plasma_plasmoids
plasma5_plasmoids | plasma_plasmoids
plasma5_look_and_feel | plasma_look_and_feel
plasma5_desktopthemes | plasma_desktopthemes
plasma_color_schemes | color_schemes
