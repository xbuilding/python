#!/usr/bin/env bash

function config_source() {
  local mirror_server="$1"
  if [ -n "$mirror_server" ]; then
    zypper mr -da
    zypper ar -fcg "$mirror_server/distribution/leap/\$releasever/repo/oss/" tuna-oss
    zypper ar -fcg "$mirror_server/distribution/leap/\$releasever/repo/non-oss/" tuna-non-oss
    zypper ref
  fi
}

config_source "${MIRROR_SERVER}"