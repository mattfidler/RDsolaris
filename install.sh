#! /bin/bash

sourced=0
if [ -n "$ZSH_EVAL_CONTEXT" ]; then
    case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "$KSH_VERSION" ]; then
    [ "$(cd $(dirname -- $0) && pwd -P)/$(basename -- $0)" != "$(cd $(dirname -- ${.sh.file}) && pwd -P)/$(basename -- ${.sh.file})" ] && sourced=1
elif [ -n "$BASH_VERSION" ]; then
    (return 0 2>/dev/null) && sourced=1
else
    # All other shells: examine $0 for known shell binary filenames
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|dash) sourced=1;; esac
fi

function install_r_opencsw() {
    echo "== INSTALLING R ==================================="
    sudo pkgutil -y -i libreadline7
    sudo pkgutil -y -i curl
    sudo pkgutil -t https://files.r-hub.io/opencsw -y -i r_base
}

function install_sysreqs() {
    (
	set -e
	tools=$(cat sys.txt)
	sudo pkgutil -y -i $tools
    )
}

function install_tex() {
    sudo pkgutil -y -i \
	 texlive_base \
	 texlive_binaries \
	 texlive_common \
	 texlive_fonts_extra \
	 texlive_fonts_recommended \
	 texlive_latex_base \
	 texlive_latex_base_binaries \
	 texlive_latex_extra \
	 texlive_latex_extra_binaries \
	 texlive_latex_recommended
}

function install_udunits() {
    export lastPWD=`pwd`
    cd /tmp
    wget https://artifacts.unidata.ucar.edu/repository/downloads-udunits/udunits-2.1.24.tar.gz
    gunzip udunits-2.1.24.tar.gz
    tar xvf udunits-2.1.24.tar
    export oldPATH=${PATH}
    export PATH=/opt/developerstudio12.6/bin:/usr/sbin:/usr/bin:/usr/ccs/bin/
    cd udunits-2.1.24
    ./configure CC="cc -xc99 -D_XPG6" --prefix=/usr
    make
    make install
    cd ..
    rm -rf udunits-2.1.24
    rm udunits-2.1.24.tar
    export PATH=${oldPATH}
    cd $lastPWD
}

function install_libgit2() {
    # https://gist.github.com/jeroen/4f13ff48596b449283ca98af7b95601d
    sh libgit-solaris.sh
}

function install_r_hub_client() {
    curl -O -C - https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.2/swarm-client-2.2-jar-with-dependencies.jar
}

function install_bint() {
    export lastPWD=`pwd`
    rm -rf /bint
    mkdir /bint
    cd /bint
    ln -s /opt/csw/bin/gmake make
    export PATH="/bint:${PATH}"
    cd $lastPWD
}

function main() {
    install_bint
    #install_r_opencsw
    install_sysreqs
    install_tex
    install_udunits
    install_libgit2
}

if [ "$sourced" = "0" ]; then
    set -e
    main
fi
