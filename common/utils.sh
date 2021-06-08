#!/usr/bin/env bash

function _get_base_dir() {
  local base_dir=""
  base_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  base_dir=$(dirname "$base_dir")
  echo "$base_dir"
}

function _get_cache_dir() {
  local version="$1"
  local script_dir=""
  local cache_dir=""
  script_dir=$(_get_script_dir)
  cache_dir=$(dirname "$script_dir")
  cache_dir="$cache_dir/$version/.cache"
  if [ ! -d "$cache_dir" ]; then
    mkdir "$cache_dir"
  fi
  echo "$cache_dir"
}

function get_os_name() {
  local script_dir=""
  local base_dir=""
  local current="$1" 
  local length=""
  local name=""

  base_dir="$(_get_base_dir)/$(get_current_python_version)"
  script_dir=$(cd "$(dirname "${BASH_SOURCE[-1]}")" &>/dev/null && pwd)
  length="${#base_dir}"
  length=$((length + 1))
  name="${script_dir:${length}}"
  name="${name%/*}"
  
  echo "$name"
}

function count_char_in_str() {
  local str="$1"
  local c="$2"
  local dots="${str//[^$c]/}"
  local dot_count="${#dots}"
  echo "$dot_count"
}

function get_current_python_version() {
  local script_dir=""
  local base_dir=""
  local version=""
  base_dir=$(_get_base_dir)
  script_dir=$(cd "$(dirname "${BASH_SOURCE[-1]}")" &>/dev/null && pwd)
  version="${script_dir:$((${#base_dir} + 1))}"
  version="${version%/*}"
  version="${version%/*}"
  echo "$version"
}

function get_output_name() {
  local current="$1"
  local extra="$2"
  local target=""
  target="python-$(get_current_python_version)-$(get_os_name "$current").${extra}_$(arch).tar.gz"
  echo "$target"
}

function get_output_dir() {
  local target_dir=""
  target_dir="$(_get_base_dir)/bins/"
  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
  fi
  echo "$target_dir"
}
