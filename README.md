# uv-virtualenvwrapper

A lightweight replacement for [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io) when using [uv](https://github.com/astral-sh/uv).


## Why uv-virtualenvwrapper?

[uv](https://github.com/astral-sh/uv) is a fantastic, high-performance tool for managing Python packages and virtual environments. However, it currently lacks a built-in way to easily manage multiple named environments in a centralized location (see [feature request](https://github.com/astral-sh/uv/issues/1495)).


`uv-virtualenvwrapper` fills this gap by providing a simple bash/zsh script with tab completion, mirroring the core functionality of virtualenvwrapper specifically for use with uv. It allows for quick creation, activation, removal, and listing of named Python virtual environments. Virtual environments are stored centrally in `~/.virtualenvs` by default and can be activated with `workon <name>`. Pre/postactivate hooks from virtualenvwrapper are not supported.

## Installation

### Method 1: Direct Download

1. **Download the script:**
   Download [uv-virtualenvwrapper.sh](https://github.com/sitic/uv-virtualenvwrapper/blob/main/uv-virtualenvwrapper.sh).
2. **Add to shell config:**
    Add
   ```bash
   source /path/to/uv-virtualenvwrapper.sh
   ```
   to your shell configuration file (`~/.bashrc` or `~/.zshrc`).

### Method 2: Install with `uv`
1. **Install [uv-virtualenvwrapper](https://pypi.org/project/uv-virtualenvwrapper/)**:
    ```bash
    uv tool install uv-virtualenvwrapper
    ```
2. **Add to shell config:**
    Add
   ```bash
   source $(which uv-virtualenvwrapper.sh)
   ```
   to your shell configuration file (`~/.bashrc` or `~/.zshrc`).

## Usage

| Command                       | Description                                                                                |
| :---------------------------- | :----------------------------------------------------------------------------------------- |
| `mkvirtualenv [options] <name>` | Creates a new virtual environment named `<name>` and activates it. All options are passed to `uv venv --seed`. |
| `workon [name]`               | Activates the virtual environment named `<name>`. If no name is given, lists available environments. If `$WORKON_HOME/<name>/.project` contains a valid directory path, `cd`s into it and sets `UV_PROJECT_ENVIRONMENT` so `uv sync`/`uv run`/`uv add` use this virtualenv instead of the project's `.venv` (cleared on `deactivate`; a user-set value is left alone). |
| `rmvirtualenv <name>`          | Removes the virtual environment named `<name>`.                                             |
| `lsvirtualenv`                 | Lists all available virtual environments.                                                 |
| `deactivate`                  | Deactivates the current virtual environment. (Standard `venv` command)                      |

Virtual environments are stored in `WORKON_HOME` (default: `~/.virtualenvs`).

Example:
```bash
$ mkvirtualenv myenv
$ uv pip install requests
$ deactivate

[...]

$ workon myenv
$ uv pip list
```

## License
[MIT License](LICENSE.md)

## Links
* [GitHub repository](https://github.com/sitic/uv-virtualenvwrapper)
* [PyPI package](https://pypi.org/project/uv-virtualenvwrapper/)