#!/usr/bin/env bash

__LAPTOP_CLEANUP_TOOLS=("brew" "docker" "gem" "npm" "pod" "xcrun" "zi")

__program_cleanup_detect() {
  local filtered_commands=$(filter_command_exists "${__LAPTOP_CLEANUP_TOOLS[@]}")
  echo "The following tools were found and will be cleaned :"
  echo ""
  # Iterate over the tools and check for their existence
  for tool in ${filtered_commands}; do
    echo "  ✓ $tool"
  done
  echo ""
}

__program_cleanup_run() {
  local filtered_commands=$(filter_command_exists "${__LAPTOP_CLEANUP_TOOLS[@]}")
  local initial_available_space=$(disk_available_space)

  # Cleanup by command
  for tool in $filtered_commands; do
    case "$tool" in
      brew)
        _laptop_step_start "- Cleanup brew"
        _laptop_step_eval "brew cleanup --prune=all"
        ;;
      docker)
        _laptop_step_start "- Prune docker images"
        _laptop_step_eval "docker image prune -a --force"
        ;;
      gem)
        _laptop_step_start "- Cleanup gem"
        _laptop_step_eval "gem cleanup"
        ;;
      npm)
        _laptop_step_start "- Clean npm cache"
        _laptop_step_eval "npm cache clean --force"
        ;;
      pod)
        _laptop_step_start "- Clean pod cache"
        _laptop_step_eval "pod cache clean --all"
        ;;
      xcrun)
        _laptop_step_start "- Clean XCode simulators"
        _laptop_step_eval "xcrun simctl delete unavailable"
        ;;
      zi)
        _laptop_step_start "- Cleanup zi"
        _laptop_step_eval "env zsh --login -i -c \"zi delete --clean --quiet --yes; zi cclear\""
        ;;
      *)
        echo "Unknown tool: $tool"
        ;;
    esac
  done

  # Cleanup by directory
  ensure_directory_empty "$HOME/Library/Developer/Xcode/DerivedData"
  ensure_directory_empty "$HOME/.gradle/caches"

  new_available_space=$(disk_available_space)
  __program_cleanup_result $((new_available_space - initial_available_space))
}

__program_cleanup_result() {
	b=${1:-0}
	d=''
	s=1
	S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
	while ((b > 1024)); do
		d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
		b=$((b / 1024))
		((s++))
	done
	einfo "$b$d ${S[$s]} of space was cleaned up"
}

__program_cleanup() {
  laptop::logo
  __program_cleanup_detect
  if confirm "Continue? (Y/n)"; then
    __program_cleanup_run

    einfo "🎉 Cleanup successful"
  else
    eerror "🛑 Cleanup aborted"
    exit 1
  fi
}
