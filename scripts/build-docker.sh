#!/bin/bash

PKGNAME='ocs-url'

PKGUSER='pkgbuilder'

BUILDTYPE=''
if [ "${1}" ]; then
    BUILDTYPE="${1}"
fi

PROJDIR="$(cd "$(dirname "${0}")/../" && pwd)"

BUILDSCRIPT="${PROJDIR}/scripts/build.sh"

TRANSFERLOG="${PROJDIR}/transfer.log"

transfer_file() {
    filepath="${1}"
    if [ -f "${filepath}" ]; then
        filename="$(basename "${filepath}")"
        echo "Uploading ${filename}" >> "${TRANSFERLOG}"
        curl -fsSL -T "${filepath}" "https://transfer.sh/${filename}" >> "${TRANSFERLOG}"
        echo '' >> "${TRANSFERLOG}"
    fi
}

build_ubuntu() {
    # docker-image: ubuntu:14.04

    apt update -qq
    apt -y install curl git
    apt -y install build-essential qt5-default libqt5svg5-dev qtdeclarative5-dev
    apt -y install devscripts debhelper fakeroot

    useradd -m ${PKGUSER}
    chown -R ${PKGUSER}:${PKGUSER} "${PROJDIR}"

    su -c "export HOME=/home/${PKGUSER} && sh "${BUILDSCRIPT}" ${BUILDTYPE}" ${PKGUSER}

    transfer_file "$(find "${PROJDIR}/build_"*${BUILDTYPE} -type f -name "${PKGNAME}*.deb")"
}

build_fedora() {
    # docker-image: fedora:20

    yum -y install curl git
    yum -y install make automake gcc gcc-c++ libtool qt5-qtbase-devel qt5-qtsvg-devel qt5-qtdeclarative-devel
    yum -y install rpm-build

    useradd -m ${PKGUSER}
    chown -R ${PKGUSER}:${PKGUSER} "${PROJDIR}"

    su -c "export HOME=/home/${PKGUSER} && sh "${BUILDSCRIPT}" ${BUILDTYPE}" ${PKGUSER}

    transfer_file "$(find "${PROJDIR}/build_"*${BUILDTYPE} -type f -name "${PKGNAME}*.rpm")"
}

build_opensuse() {
    # docker-image: opensuse:42.1

    zypper --non-interactive refresh
    zypper --non-interactive install curl git
    zypper --non-interactive install make automake gcc gcc-c++ libtool libqt5-qtbase-devel libqt5-qtsvg-devel libqt5-qtdeclarative-devel
    zypper --non-interactive install rpm-build

    useradd -m ${PKGUSER}
    chown -R ${PKGUSER}:${PKGUSER} "${PROJDIR}"

    su -c "export HOME=/home/${PKGUSER} && sh "${BUILDSCRIPT}" ${BUILDTYPE}" ${PKGUSER}

    transfer_file "$(find "${PROJDIR}/build_"*${BUILDTYPE} -type f -name "${PKGNAME}*.rpm")"
}

build_archlinux() {
    # docker-image: base/archlinux:latest

    pacman -Syu --noconfirm
    pacman -S --noconfirm curl git
    pacman -S --noconfirm base-devel qt5-base qt5-svg qt5-declarative qt5-quickcontrols

    useradd -m ${PKGUSER}
    chown -R ${PKGUSER}:${PKGUSER} "${PROJDIR}"

    su -c "export HOME=/home/${PKGUSER} && sh "${BUILDSCRIPT}" ${BUILDTYPE}" ${PKGUSER}

    transfer_file "$(find "${PROJDIR}/build_"*${BUILDTYPE} -type f -name "${PKGNAME}*.pkg.tar.xz")"
}

build_appimage() {
    echo 'Not implemented yet'
}

build_snap() {
    echo 'Not implemented yet'
}

build_flatpak() {
    echo 'Not implemented yet'
}

if [ "${BUILDTYPE}" = 'ubuntu' ]; then
    build_ubuntu
elif [ "${BUILDTYPE}" = 'fedora' ]; then
    build_fedora
elif [ "${BUILDTYPE}" = 'opensuse' ]; then
    build_opensuse
elif [ "${BUILDTYPE}" = 'archlinux' ]; then
    build_archlinux
elif [ "${BUILDTYPE}" = 'appimage' ]; then
    build_appimage
elif [ "${BUILDTYPE}" = 'snap' ]; then
    build_snap
elif [ "${BUILDTYPE}" = 'flatpak' ]; then
    build_flatpak
else
    echo "sh $(basename "${0}") [ubuntu|fedora|archlinux|appimage|snap|flatpak]"
    exit 1
fi
