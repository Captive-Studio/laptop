#!/usr/bin/env bash

laptop::function_exists() {
  declare -f -F "$1" >/dev/null
  return $?
}
