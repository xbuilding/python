#!/usr/bin/env bash

source ../../../common/utils.sh
source ./envs

OS_NAME=$(get_os_name "$(pwd)")
CURRENT=$(pwd)
PYTHON_VERSION=$(get_current_python_version)


function build_python() {
  local os_version="$1"
  local full_path="$CURRENT/$os_version"
  local full_name=""
  local branch=""
  local temp_dir=""
  local output_name=""
  output_name=$(get_output_name "$CURRENT" "$os_version")
  temp_dir="$(pwd)/$OS_NAME-$os_version-$(date +%s)"
  mkdir -p "$temp_dir"
  branch=$(basename "$CURRENT")
  full_name="$OS_NAME/$branch:$os_version"
  echo "start build $output_name for $full_name"
  docker run  --rm \
              -e MIRROR_SERVER="${MIRROR_SERVER}" \
              -e PYTHON_VERSION="$PYTHON_VERSION" \
              -e DIST_DIR="/dist" \
              -e OUTPUT_NAME="$output_name" \
              -e OUTPUT_DIR="/output" \
              -w /workspace \
              -v "$temp_dir:/output" \
              -v "$full_path:/workspace/:ro" \
              -v "$CURRENT/config-source.sh:/scripts/config-source.sh:ro" \
              -v "$CURRENT/build-python-in-container.sh:/scripts/build-python-in-container.sh:ro" \
              "$full_name" \
              bash /scripts/build-python-in-container.sh && \
    mv "$temp_dir/$output_name" "$(get_output_dir)" 
  rm -rf "$temp_dir"
}

function build_all() {
  build_python "15.1"
  build_python "15.2"
  build_python "15.3"
  ls -lh "$(get_output_dir)"
}

build_all
