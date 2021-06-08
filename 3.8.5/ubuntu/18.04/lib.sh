#!/usr/bin/env bash

function config_source() {
  local mirror_server="${MIRROR_SERVER}"
  if [ -n "$mirror_server" ]; then
    echo "deb $mirror_server bionic main restricted universe multiverse" > /etc/apt/sources.list
    echo "deb $mirror_server bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list
    echo "deb $mirror_server bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list
    echo "deb $mirror_server bionic-security main restricted universe multiverse" >> /etc/apt/sources.list
  fi
}


function install_dependencies(){
  apt-get update
  apt-get install -y gcc make build-essential tk-dev libbz2-dev  libgdbm-compat-dev\
                zlib1g-dev libncurses5-dev libgdbm-dev libsqlite3-dev uuid-dev  \
                libnss3-dev libssl-dev libreadline-dev libffi-dev liblzma-dev
}

function build_python(){
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
    -prefix="${DIST_DIR}"
  echo "*static*" >>"/tmp/Python-${PYTHON_VERSION}/Modules/Setup.local"
  make LINKFORSHARED='-Xlinker -export-dynamic' -j "$(nproc)" build_all
  make -j "$(nproc)" altinstall
  popd || exit
}