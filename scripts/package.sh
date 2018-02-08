#!/bin/bash

PKGNAME='ocs-url'

USER='pkgbuilder'

SCRIPT="${0}"

PROJDIR="$(cd "$(dirname "${0}")/../" && pwd)"

BUILDDIR="${PROJDIR}/build_${PKGNAME}"

ci_ubuntu_deb() { # docker-image: ubuntu:14.04
    apt update -qq
    apt -y install curl git
    apt -y install build-essential qt5-default libqt5svg5-dev qtdeclarative5-dev
    apt -y install devscripts debhelper fakeroot

    useradd -m ${USER}
    chown -R ${USER}:${USER} "${PROJDIR}"

    su -c "export HOME=/home/${USER} && sh "${SCRIPT}" build_ubuntu_deb" ${USER}

    transfer_file "$(find "${BUILDDIR}" -type f -name "${PKGNAME}*.deb")"
}

build_ubuntu_deb() {
    mkdir -p "${BUILDDIR}"
    export_srcarchive "${BUILDDIR}/${PKGNAME}.tar.gz"
    tar -xzf "${BUILDDIR}/${PKGNAME}.tar.gz" -C "${BUILDDIR}"
    cp -r "${PROJDIR}/pkg/ubuntu/debian" "${BUILDDIR}/${PKGNAME}"
    cd "${BUILDDIR}/${PKGNAME}"
    debuild -uc -us -b
}

ci_fedora_rpm() { # docker-image: fedora:20
    yum -y install curl git
    yum -y install make automake gcc gcc-c++ libtool qt5-qtbase-devel qt5-qtsvg-devel qt5-qtdeclarative-devel
    yum -y install rpm-build

    useradd -m ${USER}
    chown -R ${USER}:${USER} "${PROJDIR}"

    su -c "export HOME=/home/${USER} && sh "${SCRIPT}" build_fedora_rpm" ${USER}

    transfer_file "$(find "${BUILDDIR}" -type f -name "${PKGNAME}*.rpm")"
}

build_fedora_rpm() {
    mkdir -p "${BUILDDIR}"
    mkdir "${BUILDDIR}/SOURCES"
    mkdir "${BUILDDIR}/SPECS"
    export_srcarchive "${BUILDDIR}/SOURCES/${PKGNAME}.tar.gz"
    cp "${PROJDIR}/pkg/fedora/${PKGNAME}.spec" "${BUILDDIR}/SPECS"
    rpmbuild --define "_topdir ${BUILDDIR}" -bb "${BUILDDIR}/SPECS/${PKGNAME}.spec"
}

ci_opensuse_rpm() { # docker-image: opensuse:42.1
    zypper --non-interactive refresh
    zypper --non-interactive install curl git
    zypper --non-interactive install make automake gcc gcc-c++ libtool libqt5-qtbase-devel libqt5-qtsvg-devel libqt5-qtdeclarative-devel
    zypper --non-interactive install rpm-build

    useradd -m ${USER}
    chown -R ${USER}:${USER} "${PROJDIR}"

    su -c "export HOME=/home/${USER} && sh "${SCRIPT}" build_opensuse_rpm" ${USER}

    transfer_file "$(find "${BUILDDIR}" -type f -name "${PKGNAME}*.rpm")"
}

build_opensuse_rpm() {
    mkdir -p "${BUILDDIR}"
    mkdir "${BUILDDIR}/SOURCES"
    mkdir "${BUILDDIR}/SPECS"
    export_srcarchive "${BUILDDIR}/SOURCES/${PKGNAME}.tar.gz"
    cp "${PROJDIR}/pkg/opensuse/${PKGNAME}.spec" "${BUILDDIR}/SPECS"
    rpmbuild --define "_topdir ${BUILDDIR}" -bb "${BUILDDIR}/SPECS/${PKGNAME}.spec"
}

ci_archlinux_pkg() { # docker-image: base/archlinux:latest
    pacman -Syu --noconfirm
    pacman -S --noconfirm curl git
    pacman -S --noconfirm base-devel qt5-base qt5-svg qt5-declarative qt5-quickcontrols

    useradd -m ${USER}
    chown -R ${USER}:${USER} "${PROJDIR}"

    su -c "export HOME=/home/${USER} && sh "${SCRIPT}" build_archlinux_pkg" ${USER}

    transfer_file "$(find "${BUILDDIR}" -type f -name "${PKGNAME}*.pkg.tar.xz")"
}

build_archlinux_pkg() {
    mkdir -p "${BUILDDIR}"
    export_srcarchive "${BUILDDIR}/${PKGNAME}.tar.gz"
    cp "${PROJDIR}/pkg/archlinux/PKGBUILD" "${BUILDDIR}"
    cd "${BUILDDIR}"
    updpkgsums
    makepkg -s
}

export_srcarchive() {
    if [ "${1}" ]; then
        $(cd "${PROJDIR}" && git archive --prefix="${PKGNAME}/" --output="${1}" HEAD)
    fi
}

transfer_file() {
    if [ -f "${1}" ]; then
        filename="$(basename "${1}")"
        transferlog="${PROJDIR}/transfer.log"
        echo "Uploading ${filename}" >> "${transferlog}"
        curl -fsSL -T "${1}" "https://transfer.sh/${filename}" >> "${transferlog}"
        echo '' >> "${transferlog}"
    fi
}

if [ "${1}" ]; then
    ${1}
fi
