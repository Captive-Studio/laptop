#!/usr/bin/env bash

ensure_package__asdf() {
  local asdf_dir="${ASDF_DIR:-$HOME/.asdf}"
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "asdf"
  else
    if [ ! -d "$asdf_dir" ];then
      _laptop_step_start "- Ensure asdf installed (via git)"
      _laptop_step_eval "git clone https://github.com/asdf-vm/asdf.git $asdf_dir --branch v0.14.0"
      source "$asdf_dir/asdf.sh"
    else
      _laptop_step_ok
    fi
  fi
}
