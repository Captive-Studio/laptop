#!/usr/bin/env zsh

source "$LAPTOP_HOME/src/env.sh"
LAPTOP_PROFILE_CURRENT_DIR=$(laptop::profile_dir)

# Migrate
rm -rf "$XDG_DATA_HOME/zsh/00_init.sh"
if [  -f "$XDG_DATA_HOME/zsh/01_custom.sh" ];then
  mv "$XDG_DATA_HOME/zsh/01_custom.sh" "$XDG_DATA_HOME/zsh/personal.sh"
fi

# Ensure ZSH Configuration
if [ ! -f "$HOME/.zshrc.local" ];then
  laptop::ensure_file_template "$LAPTOP_PROFILE_CURRENT_DIR/resource/zshrc.local" "$HOME/.zshrc.local"
fi
laptop::ensure_file_template "$LAPTOP_PROFILE_CURRENT_DIR/resource/zshrc.d/global.sh" "$XDG_DATA_HOME/zsh/global.sh"
laptop::ensure_file_template "$LAPTOP_PROFILE_CURRENT_DIR/resource/zshrc.d/organization.sh" "$XDG_DATA_HOME/zsh/organization.sh"
if [ ! -f "$XDG_DATA_HOME/zsh/personal.sh" ];then
  laptop::ensure_file_template "$LAPTOP_PROFILE_CURRENT_DIR/resource/zshrc.d/personal.sh" "$XDG_DATA_HOME/zsh/personal.sh"
fi
if [ ! -f "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}" ];then
  laptop::ensure_file_template "$LAPTOP_PROFILE_CURRENT_DIR/resource/p10k.zsh" "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}"
fi
