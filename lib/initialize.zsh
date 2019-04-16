#!/usr/bin/env zsh

# ----------
# ZPM Plugin
# ----------

_ZPM_Plugins=()
_ZPM_Plugins_3rdparty=()

function _ZPM-load-plugin() {

  local Plugin_path=$(_ZPM-get-plugin-path $1)
  local Plugin_name=$(_ZPM-get-plugin-basename $1)

  if [[ ! -d $Plugin_path ]]; then
    _ZPM-install-plugin $1
  fi

  _ZPM-log "Add to FPATH ${Plugin_path}" 
  FPATH="$FPATH:${Plugin_path}"

  if [[ -d ${Plugin_path}/bin ]]; then
    PATH="$PATH:${Plugin_path}/bin"
  fi

  if [[ -f ${Plugin_path}/${Plugin_name}.plugin.zsh ]]; then
    source ${Plugin_path}/${Plugin_name}.plugin.zsh
  elif [[ -f ${Plugin_path}/zsh-${Plugin_name}.plugin.zsh ]]; then
    source ${Plugin_path}/zsh-${Plugin_name}.plugin.zsh
  elif [[ -f ${Plugin_path}/${Plugin_name}.zsh ]]; then
    source ${Plugin_path}/${Plugin_name}.zsh
  fi
}

function _ZPM-initialize-plugin() {
  _ZPM_Plugins+=($1)
  
  _ZPM_Plugins_3rdparty+=($1)

  _ZPM-load-plugin $1
}

function _ZPM-init() {
  compinit
  precmd_functions=(${precmd_functions#_ZPM-init})
}
precmd_functions+=(_ZPM-init)
