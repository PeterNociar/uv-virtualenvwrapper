# Shell functions to act as a virtualenvwrapper replacement for uv
#
# Author: Jan Lebert
# License: MIT
# Project home page: https:://github.com/sitic/uv-virtualenvwrapper
#
# Usage:
#   source uv-virtualenvwrapper.sh
#
#   mkvirtualenv [uv_venv_args...] <name>
#   workon <name>
#   rmvirtualenv <name>
#   lsvirtualenv
#

export WORKON_HOME="${WORKON_HOME:-$HOME/.virtualenvs}"

# Windows use 'Scripts' instead of 'bin'
VIRTUALENVWRAPPER_ENV_BIN_DIR="bin"
if [ "${OS:-}" = "Windows_NT" ] && ([ "${MSYSTEM:-}" = "MINGW32" ] || [ "${MSYSTEM:-}" = "MINGW64" ])
then
    # Only assign this for msys, cygwin uses 'bin'
    VIRTUALENVWRAPPER_ENV_BIN_DIR="Scripts"
fi

_mkdir_workon_home() {
  mkdir -p "$WORKON_HOME"
}

workon() {
  if [ $# -eq 0 ]; then
    lsvirtualenv
    return 0
  fi

  local venv_name="$1"
  local venv_path="$WORKON_HOME/$venv_name"

  if [ ! -d "$venv_path" ]; then
    echo "Virtualenv '$venv_name' not found in $WORKON_HOME" >&2
    return 1
  fi

  source "$venv_path/$VIRTUALENVWRAPPER_ENV_BIN_DIR/activate" || return 1

  # cd to project dir if .project file exists (virtualenvwrapper compatible)
  local project_file="$venv_path/.project"
  if [ -f "$project_file" ]; then
    local project_dir
    IFS= read -r project_dir < "$project_file"
    if [ -d "$project_dir" ]; then
      cd "$project_dir"
    elif [ -n "$project_dir" ]; then
      echo "Project directory '$project_dir' from $project_file not found" >&2
    fi
  fi
}

mkvirtualenv() {
  if [ $# -eq 0 ]; then
    echo "Usage: mkvirtualenv [uv_venv_args...] <name>" >&2
    return 1
  fi

  _mkdir_workon_home

  local venv_name uv_args
  if [ -n "$ZSH_VERSION" ]; then
    venv_name="${@[-1]}"
    uv_args=("${@[1,-2]}")
  else
    venv_name="${@: -1}"
    uv_args=("${@:1:$#-1}")
  fi
  local venv_path="$WORKON_HOME/$venv_name"

  if [ -d "$venv_path" ]; then
    echo "Virtualenv '$venv_name' already exists" >&2
    return 1
  fi
  
  uv venv "${uv_args[@]}" --seed "$venv_path" && workon "$venv_name"
}

rmvirtualenv() {
  if [ $# -eq 0 ]; then
    echo "Usage: rmvirtualenv <name>" >&2
    return 1
  fi

  local venv_name="$1"
  local venv_path="$WORKON_HOME/$venv_name"

  if [ ! -d "$venv_path" ]; then
    echo "Virtualenv '$venv_name' not found" >&2
    return 1
  fi

  rm -rf "$venv_path" && echo "Removed virtualenv '$venv_name'"
}

lsvirtualenv() {
  find "$WORKON_HOME" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null
}

# Setup tab completion
__uvvirtualenvwrapper_setup() {
  if [ -n "${BASH:-}" ]; then
    _virtualenvs() {
      local cur="${COMP_WORDS[COMP_CWORD]}"
      COMPREPLY=($(compgen -W "$(lsvirtualenv)" -- "${cur}"))
    }
    complete -o default -F _virtualenvs workon rmvirtualenv

  elif [ -n "${ZSH_VERSION:-}" ]; then
    _virtualenvs() {
      local -a venvs
      venvs=($(lsvirtualenv))
      _describe 'virtualenvs' venvs
    }
    compdef _virtualenvs workon rmvirtualenv
  fi
}
__uvvirtualenvwrapper_setup