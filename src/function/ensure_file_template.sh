#!/usr/bin/env bash

laptop::ensure_file_template() {
  local template="$1"
  local target="$2"

  laptop::step_start "- Ensure file '$target'"
  laptop::step_eval "\
  mkdir -p $(quote "$(dirname "$target")") && \
  cp -f $(quote "$template") $(quote "$target") \
  "
}
