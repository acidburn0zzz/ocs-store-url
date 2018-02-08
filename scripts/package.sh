#!/bin/bash

PKGNAME='ocs-url'

USER='pkgbuilder'

SCRIPT="${0}"

FUNCTION=''
if [ "${1}" ]; then
    FUNCTION="${1}"
fi

PROJDIR="$(cd "$(dirname "${0}")/../" && pwd)"

BUILDDIR="${PROJDIR}/build_${PKGNAME}_${FUNCTION}"

export_srcarchive() {
    filepath="${1}"
    $(cd "${PROJDIR}" && git archive --prefix="${PKGNAME}/" --output="${filepath}" HEAD)
}

transfer_file() {
    filepath="${1}"
    if [ -f "${filepath}" ]; then
        filename="$(basename "${filepath}")"
        logfilepath="${PROJDIR}/transfer.log"
        echo "Uploading ${filename}" >> "${logfilepath}"
        curl -fsSL -T "${filepath}" "https://transfer.sh/${filename}" >> "${logfilepath}"
        echo '' >> "${logfilepath}"
    fi
}

build_ubuntu_deb() {
    cd "${PROJDIR}"
    mkdir -p "${BUILDDIR}"
    export_srcarchive "${BUILDDIR}/${PKGNAME}.tar.gz"
    tar -xzf "${BUILDDIR}/${PKGNAME}.tar.gz" -C "${BUILDDIR}"
    cp -r "${PROJDIR}/pkg/ubuntu/debian" "${BUILDDIR}/${PKGNAME}"
    cd "${BUILDDIR}/${PKGNAME}"
    debuild -uc -us -b
}

build_fedora_rpm() {
    cd "${PROJDIR}"
    mkdir -p "${BUILDDIR}"
    export_srcarchive "${BUILDDIR}/${PKGNAME}.tar.gz"

    mkdir "${BUILDDIR}/SOURCES"
    mkdir "${BUILDDIR}/SPECS"
    mv "${BUILDDIR}/${PKGNAME}.tar.gz" "${BUILDDIR}/SOURCES"
    cp "${PROJDIR}/pkg/fedora/${PKGNAME}.spec" "${BUILDDIR}/SPECS"
    rpmbuild --define "_topdir ${BUILDDIR}" -bb "${BUILDDIR}/SPECS/${PKGNAME}.spec"
}

build_opensuse_rpm() {
    cd "${PROJDIR}"
    mkdir -p "${BUILDDIR}"
    export_srcarchive "${BUILDDIR}/${PKGNAME}.tar.gz"

    mkdir "${BUILDDIR}/SOURCES"
    mkdir "${BUILDDIR}/SPECS"
    mv "${BUILDDIR}/${PKGNAME}.tar.gz" "${BUILDDIR}/SOURCES"
    cp "${PROJDIR}/pkg/opensuse/${PKGNAME}.spec" "${BUILDDIR}/SPECS"
    rpmbuild --define "_topdir ${BUILDDIR}" -bb "${BUILDDIR}/SPECS/${PKGNAME}.spec"
}

build_archlinux_pkg() {
    cd "${PROJDIR}"
    mkdir -p "${BUILDDIR}"
    export_srcarchive "${BUILDDIR}/${PKGNAME}.tar.gz"

    cp "${PROJDIR}/pkg/archlinux/PKGBUILD" "${BUILDDIR}"
    cd "${BUILDDIR}"
    updpkgsums
    makepkg -s
}

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

ci_fedora_rpm() { # docker-image: fedora:20
    yum -y install curl git
    yum -y install make automake gcc gcc-c++ libtool qt5-qtbase-devel qt5-qtsvg-devel qt5-qtdeclarative-devel
    yum -y install rpm-build

    useradd -m ${USER}
    chown -R ${USER}:${USER} "${PROJDIR}"

    su -c "export HOME=/home/${USER} && sh "${SCRIPT}" build_fedora_rpm" ${USER}

    transfer_file "$(find "${PROJDIR}/build_"*${FUNCTION} -type f -name "${PKGNAME}*.rpm")"
}


ci_opensuse_rpm() { # docker-image: opensuse:42.1
    zypper --non-interactive refresh
    zypper --non-interactive install curl git
    zypper --non-interactive install make automake gcc gcc-c++ libtool libqt5-qtbase-devel libqt5-qtsvg-devel libqt5-qtdeclarative-devel
    zypper --non-interactive install rpm-build

    useradd -m ${USER}
    chown -R ${USER}:${USER} "${PROJDIR}"

    su -c "export HOME=/home/${USER} && sh "${SCRIPT}" build_opensuse_rpm" ${USER}

    transfer_file "$(find "${PROJDIR}/build_"*${FUNCTION} -type f -name "${PKGNAME}*.rpm")"
}

ci_archlinux_pkg() { # docker-image: base/archlinux:latest
    pacman -Syu --noconfirm
    pacman -S --noconfirm curl git
    pacman -S --noconfirm base-devel qt5-base qt5-svg qt5-declarative qt5-quickcontrols

    useradd -m ${USER}
    chown -R ${USER}:${USER} "${PROJDIR}"

    su -c "export HOME=/home/${USER} && sh "${SCRIPT}" build_archlinux_pkg" ${USER}

    transfer_file "$(find "${PROJDIR}/build_"*${FUNCTION} -type f -name "${PKGNAME}*.pkg.tar.xz")"
}

${FUNCTION}
