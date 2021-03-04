#!/bin/sh
# Install dependencies
sudo pkgutil -i cmake libssh2_dev libssl_dev

# Download latest release
cd /tmp
wget https://github.com/libgit2/libgit2/releases/download/v1.1.0/libgit2-1.1.0.tar.gz
gtar xzf libgit2-1.1.0.tar.gz
cd libgit2-1.1.0

# Patch to use C99 instead of C90
gsed -i.bak 's/90/99/g' src/CMakeLists.txt

# Build
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/csw -DBUILD_CLAR=NO -DBUILD_EXAMPLES=NO
make

# Install
sudo make install
