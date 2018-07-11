# How to install


## Install from package

Download Linux package from: https://www.opendesktop.org/p/1136805/

Then click the downloaded package and continue to installation with package manager.

Or install the downloaded package using terminal:

Ubuntu 14.04

    $ sudo apt install libqt5svg5 qtdeclarative5-qtquick2-plugin qtdeclarative5-window-plugin qtdeclarative5-controls-plugin
    $ sudo dpkg -i /path/to/ocs-url*.deb

Ubuntu 16.04

    $ sudo apt install libqt5svg5 qml-module-qtquick-controls
    $ sudo dpkg -i /path/to/ocs-url*.deb

Fedora 20

    # yum insall qt5-qtbase qt5-qtbase-gui qt5-qtsvg qt5-qtdeclarative qt5-qtquickcontrols
    # rpm -i /path/to/ocs-url*.rpm

Fedora 22

    # dnf insall qt5-qtbase qt5-qtbase-gui qt5-qtsvg qt5-qtdeclarative qt5-qtquickcontrols
    # rpm -i /path/to/ocs-url*.rpm

openSUSE 42.1

    # zypper install libQt5Svg5 libqt5-qtquickcontrols
    # rpm -i /path/to/ocs-url*.rpm

Arch Linux

    # pacman -S qt5-base qt5-svg qt5-declarative qt5-quickcontrols
    # pacman -U /path/to/ocs-url*.pkg.tar.xz


## Install from source

Make git clone, or download the source archive and extract it.

Build and install

    $ cd /path/to/ocs-url
    $ ./scripts/prepare
    $ qmake PREFIX=/usr
    $ make
    $ sudo make install

Uninstall

    $ sudo make uninstall
