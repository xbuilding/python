#!/usr/bin/env bash

function install_dependencies() {
  zypper install -y tar gzip make gcc glibc-static glibc-devel gcc-c++ \
    curl perl uuid-devel gdbm-devel libbz2-devel \
    libuuid-devel zlib-devel xz-devel \
    sqlite3-devel readline-devel libffi-devel \
    tk-devel curl-devel libnsl-devel libstdc++-devel
}

function build_openssl() {
  local package="/tmp/openssl-$OPENSSL_VERSION.tar.gz"
  curl --request GET -L \
    --url "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" \
    --output "$package"

  tar zxf "$package" -C /tmp/
  pushd "/tmp/openssl-${OPENSSL_VERSION}" || exit
  ./config \
    --prefix="$OPENSSL_HOME" \
    --openssldir="$OPENSSL_HOME"
  make -j "$(nproc)"
  make install -j "$(nproc)"
  popd || exit
}

function build_python() {
  local package="/tmp/Python-$PYTHON_VERSION.tar.gz"
  curl --request GET -L \
    --url "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz" \
    --output "$package"
  tar -zxf "$package" -C /tmp/

  pushd "/tmp/Python-${PYTHON_VERSION}" || exit
  make clean
  ./configure --enable-optimizations \
    --without-doc-strings \
    --without-dtrace \
    --without-c-locale-coercion \
    --without-ensurepip \
    --disable-shared \
    --with-openssl="$OPENSSL_HOME" \
    -prefix="${DIST_DIR}"
  echo "*static*" >>"/tmp/Python-${PYTHON_VERSION}/Modules/Setup.local"
  make LINKFORSHARED='-Xlinker -export-dynamic' -j "$(nproc)" build_all
  make -j "$(nproc)" altinstall
  popd || exit
}
