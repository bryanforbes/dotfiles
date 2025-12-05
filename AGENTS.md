# AGENTS.md

## Project Overview

This is a personal dotfiles repository for macOS and Linux systems. It provides a comprehensive development environment setup including ZSH configuration, Neovim setup, Homebrew packages, tmux configuration, and various utility scripts. The repository uses symlinks to deploy configuration files to the appropriate locations in the user's home directory and `.config` folder.

**Key Technologies:**
- **Shell:** ZSH (shell configuration and scripting)
- **Editor:** Neovim with Lazy.nvim plugin manager
- **Package Manager:** Homebrew (macOS/Linux)
- **Terminal Multiplexer:** tmux with TPM (Tmux Plugin Manager)
- **Languages:** Lua (Neovim/Hammerspoon config), Bash/ZSH (scripts)
- **Version Managers:** mise (multi-language version manager)
- **macOS Automation:** Hammerspoon (Lua-based)

**Architecture:**
- `home/` - Files symlinked to `~/.{filename}` (gitconfig, zshrc, etc.)
- `config/` - Directories symlinked to `~/.config/{dirname}` (nvim, tmux, etc.)
- `bin/` - Utility scripts added to PATH
- `zsh/` - ZSH functions and common configuration
- `hammerspoon/` - macOS window management and automation (Darwin only)
- `osx/` - macOS-specific configuration (nginx, dnsmasq)
- `kinesis/` - Kinesis keyboard layouts

## Installation

**Full installation from scratch:**
```bash
curl -L https://raw.githubusercontent.com/bryanforbes/dotfiles/master/install.sh | bash
```

**Manual installation (if repository already cloned):**
```bash
# The install script will:
# 1. Install Homebrew if not present
# 2. Clone this repository to ~/.dotfiles
# 3. Install ZSH via Homebrew
# 4. Change default shell to ZSH
# 5. Run the dotfiles setup command

# After initial installation, run:
dotfiles
```

## Setup Commands

The primary command for managing the dotfiles environment is `dotfiles`, which is located in `bin/dotfiles` and added to PATH.

**Update entire environment:**
```bash
dotfiles
```

**Update specific components:**
```bash
dotfiles bat      # Rebuild bat theme/filetype cache
dotfiles brew     # Update Homebrew packages
dotfiles mise     # Update mise packages
dotfiles home     # Update symlinks and terminfo
dotfiles node     # Update global npm packages
dotfiles python   # Update Python packages
dotfiles tmux     # Update tmux plugins
dotfiles vim      # Update Neovim plugins
dotfiles zsh      # Update ZSH plugins
```

**View help:**
```bash
dotfiles --help
```

## Documentation Lookups

When researching libraries or tools:
- Use context7 (`mcp__context7__resolve-library-id` and `mcp__context7__get-library-docs`) for:
  - Neovim plugins (lazy.nvim, LSP, treesitter, etc.)
  - Zsh and Zsh plugins (zsh-completions, zsh-autosuggestions, etc.)
  - Homebrew packages
  - Node/Python/Lua libraries used in this project
- Use `web_search` and `read_web_page` for:
  - External tool documentation not in context7
  - Up-to-date API references or recent changes

## Development Workflow

### ZSH Configuration Architecture

The ZSH configuration is split across multiple files with a specific load order:

1. **`home/zshenv`** (always loaded first)
   - Sets `GLOBAL_RCS=off` to prevent system-wide configs from interfering
   - Conditionally sources `zprofile` for non-login command shells at SHLVL 1
   - Purpose: Minimal setup, must be fast

2. **`home/zprofile`** (loaded for login shells OR non-login command shells at SHLVL 1)
   - Defines XDG Base Directory paths and core environment variables
   - Sets up PATH, language settings, and cache directories
   - Purpose: Session environment setup

3. **`home/zshrc`** (loaded for interactive shells)
   - Loads completions, plugins, aliases, keybindings
   - Autoloads functions from `$DOTFILES/zsh/functions` and `$ZDATADIR/functions`
   - Purpose: Interactive shell features

### Environment Variables

Core environment variables defined in `home/zprofile`:
- `DOTFILES` - Points to `~/.dotfiles`
- `HOMEBREW_BASE` - Homebrew installation path (varies by system/arch)
- `XDG_CONFIG_HOME` - Configuration directory (default `~/.config`)
- `XDG_CACHE_HOME` - Cache directory (default `~/.cache`)
- `XDG_DATA_HOME` - User data directory (default `~/.local/share`)
- `XDG_STATE_HOME` - State directory (default `~/.local/state`)
- `HOMEBREW_PYTHON_VERSION` - Python version to use (e.g., "3.13")

### Key Directories

- **ZSH Plugins:** `~/.cache/zsh/plugins/{org}/{plugin}`
- **ZSH Functions:** `~/.local/share/zsh/functions`
- **ZSH Completions:** `~/.cache/zsh/completions`
- **Neovim State:** `~/.local/state/nvim/{swap,backup,undo}`
- **Tmux Plugins:** Defined by `TMUX_PLUGIN_MANAGER_PATH`

### Symlink Management

The `dotfiles home` command handles symlinking:
1. Removes broken symlinks from `~/.*` and `~/.config/*`
2. Links files from `home/` to `~/.{filename}`
3. Links directories from `config/` to `~/.config/{dirname}`
4. Links `hammerspoon/` to `~/.hammerspoon` (macOS only)
5. Creates necessary cache/data directories
6. Fixes terminfo database for proper terminal behavior

### Homebrew Package Management

Packages are defined in `Brewfile` using Homebrew Bundle format:
- Core utilities: git, gh, bat, fzf, ripgrep, tmux
- Development tools: neovim, node, python, poetry, mise
- macOS-specific: casks for GUI apps (Ghostty, Hammerspoon, Raycast, etc.)

**Add new packages:**
1. Edit `Brewfile` to add `brew 'package-name'` or `cask 'app-name'`
2. Run `dotfiles brew` to install

**Note:** The environment variable `HOMEBREW_PYTHON_VERSION` (in `home/zprofile`) controls which Python version to install.

## Testing Instructions

**No formal test suite exists.** Testing is primarily manual validation:

1. **Test dotfiles setup:**
   ```bash
   # Run dotfiles update and check for errors
   dotfiles
   
   # Verify symlinks are correct
   ls -la ~/.[a-z]* | grep "\.dotfiles"
   ls -la ~/.config | grep "\.dotfiles"
   ```

2. **Test ZSH configuration:**
   ```bash
   # Start new shell and verify no errors
   zsh -l
   
   # Check functions are available
   which dotfiles
   type is-darwin
   type is-linux
   ```

3. **Test Neovim setup:**
   ```bash
   # Launch Neovim and check for plugin errors
   nvim --headless -c 'checkhealth' -c 'quitall'
   
   # Verify plugins loaded
   nvim -c 'Lazy' -c 'q'
   ```

4. **Test Homebrew packages:**
   ```bash
   # Verify all packages installed
   brew bundle check
   
   # Check core commands available
   which bat fzf rg nvim tmux gh
   ```

5. **Test platform-specific features (macOS):**
   ```bash
   # Check Hammerspoon config loads
   open -a Hammerspoon
   
   # Verify casks installed
   ls /Applications | grep -E "(Ghostty|Raycast)"
   ```

## Code Style

### Shell Scripts (Bash/ZSH)

**General conventions:**
- **Shebang:** Use `#!/usr/bin/env zsh` for ZSH scripts, `#!/bin/bash` for Bash
- **Functions:** Use ZSH function syntax: `name() { ... }`
- **Conditionals:** Use `[[ ]]` for tests (ZSH/Bash), not `[ ]`
- **Arrays:** ZSH 1-indexed arrays, use `${array[@]}` for all elements
- **Exit codes:** Use `if ! command; then` or check with `(( $? != 0 ))`
- **Logging:** Use helper functions `log`, `logSub`, `err` from `zsh/utilities.zsh`
- **Path manipulation:** Use ZSH modifiers like `:t` (tail/basename), `:h` (head/dirname), `:A` (realpath)

**ZSH-specific best practices:**
- **Quoting:** Quote variables when they contain user input to prevent glob expansion: `"$1"`, `"$2"`
- **Glob qualifiers:** Use `(/N)` to silently ignore non-existent paths in arrays
- **Command lookups:** Use `$commands[cmd]` array instead of `$(which cmd)` or `$(command -v cmd)`
- **Arguments:** Use `"$@"` not `$*` to preserve argument boundaries
- **Error handling:** Add `|| return 1` to critical operations like `cd`, `mkdir -p`

**Examples:**
```zsh
# Good: Quotes protect from glob expansion
mkdir -p "$1" || return 1
cd "$directory" || continue

# Good: Glob qualifier ignores non-existent paths
path=($HOME/.local/bin(/N) $path)

# Good: Direct command array access
export VISUAL="$commands[nvim]"

# Good: Proper argument handling
command nvim "$@"
```

**Example from bin/dotfiles:**
```zsh
function dotfiles-brew {
    log "Updating brew packages..."
    
    brew bundle check &> /dev/null
    if (( $? != 0 )); then
        logSub "Installing missing brew packages..."
        brew bundle install
    fi
}
```

### Lua Scripts (Neovim/Hammerspoon)

- **Formatting:** Use StyLua (`.stylua.toml` config present)
- **Neovim config:** Use lazy.nvim plugin spec format
- **File organization:** Modular configs in `config/nvim/lua/`
- **Linting:** Run `stylua --check .` before committing Lua changes

**Format Lua files:**
```bash
stylua config/nvim hammerspoon
```

**Check formatting:**
```bash
stylua --check config/nvim hammerspoon
```

### Configuration Files

- **Dotfiles naming:** Files in `home/` should NOT have leading dot (added during symlinking)
- **Config directories:** Use modern `~/.config/` location (XDG standard)
- **Comments:** Use shell-style `#` comments in config files
- **Line endings:** Use Unix LF line endings

## Build and Deployment

### No Build Process

This is a configuration repository with no compilation step. "Deployment" means symlinking files to home directory.

### Deployment Steps

1. **Initial deployment (via install.sh):**
   - Installs Homebrew
   - Clones repository to `~/.dotfiles`
   - Installs ZSH and sets as default shell
   - Runs `dotfiles` command

2. **Update deployment:**
   ```bash
   cd ~/.dotfiles
   git pull
   dotfiles
   ```

3. **Selective updates:**
   ```bash
   dotfiles home    # Just update symlinks
   dotfiles brew    # Just update packages
   dotfiles vim     # Just update Neovim plugins
   ```

### Platform-Specific Deployment

**macOS:**
- Installs GUI apps via Homebrew Casks
- Sets up Hammerspoon for window management
- Configures nginx/dnsmasq (optional, in `osx/`)

**Linux:**
- Skips macOS-specific casks and Hammerspoon
- Uses Linux Homebrew path (`/home/linuxbrew/.linuxbrew`)

**Architecture detection:**
- ARM64 Macs: `/opt/homebrew`
- Intel Macs: `/usr/local`
- Automatically detected via `UNAME_MACHINE` in install.sh

## Maintenance and Troubleshooting

### Common Tasks

**Add a new utility script:**
1. Create script in `bin/` with executable permissions
2. Use appropriate shebang (`#!/usr/bin/env zsh`)
3. No need to update PATH (bin/ already included)

**Add a new ZSH function:**
1. Create file in `zsh/functions/` (no extension, no shebang needed)
2. File name becomes function name (e.g., `take` becomes `take` function)
3. Will auto-load via ZSH's fpath mechanism (configured in zshrc)
4. Follow quoting and error handling conventions (see Code Style above)
5. For completion functions, prefix with `_` (e.g., `_dotfiles`, `_git-sync`)

**Add a new config directory:**
1. Create directory in `config/`
2. Run `dotfiles home` to symlink to `~/.config/`

**Update Neovim plugins:**
1. Edit `config/nvim/lua/` files for plugin config
2. Run `dotfiles vim` or launch Neovim and run `:Lazy sync`

### Troubleshooting

**Terminal key bindings broken (C-h not working):**
```bash
fixterm  # Rebuilds terminfo database
# Or run: dotfiles home (includes fixterm)
```

**ZSH completions not working:**
```bash
# Rebuild completion cache
rm -rf ~/.cache/zsh/zcompdump*
dotfiles zsh
dotfiles brew  # Reinstalls completions

# Or force regenerate
rm -rf ~/.cache/zsh/completions ~/.cache/zsh/zcompdump*
exec zsh -l
```

**Symlinks broken after moving repository:**
```bash
# Update DOTFILES path and re-symlink
export DOTFILES=$HOME/.dotfiles
dotfiles home
```

**Homebrew permissions issues:**
- `dotfiles brew` will skip updates if no write permissions
- Fix: `sudo chown -R $(whoami) $(brew --prefix)/*`

**Neovim plugins failing:**
```bash
# Remove and reinstall plugins
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
dotfiles vim
```

**Python/Node packages not updating:**
- Check `HOMEBREW_PYTHON_VERSION` in `home/zprofile`
- Ensure Poetry/npm are in PATH
- Run specific updater: `dotfiles python` or `dotfiles node`

### Security Considerations

- **Secrets:** Never commit secrets to this repository
- **SSH keys:** Not managed by this repo (stored in `~/.ssh`)
- **API tokens:** Use environment variables or secure credential storage
- **Private configs:** Consider using a private dotfiles extension repo

### Git Workflow

**Pull latest changes:**
```bash
cd ~/.dotfiles
git pull --recurse-submodules
git submodule update --remote
dotfiles
```

**Commit changes:**
```bash
cd ~/.dotfiles
# Make changes to configs
git add -A
git commit -m "description of changes"
git push
```

**Test changes in isolation:**
```bash
# Test specific component updates
dotfiles home  # Test symlink changes
dotfiles vim   # Test Neovim changes
```

## Additional Notes

### Terminal Compatibility

The repository includes terminfo fixes for proper terminal behavior:
- Fixes backspace key by mapping it to ^? (DEL character)
- Supports tmux-256color
- Handles ncurses 5.7 color pair limits on macOS

**Clipboard Integration:**
- OSC 52 clipboard support enabled in both Neovim and tmux
- Neovim uses conditional clipboard configuration:
  - Inside tmux: Custom `tmux-osc52` provider (implemented in `config/nvim/lua/user/util/tmux-osc52.lua`) that uses `tmux load-buffer -w` for copy and `tmux save-buffer` for paste, with tmux requesting clipboard from client via OSC 52. The paste operation includes timeout handling (1.5s) and polls for new paste buffers every 50ms.
  - Outside tmux: Standard `osc52` clipboard provider
- All modes use `opt.clipboard = 'unnamedplus'` for automatic register integration
- Tmux configured with `set-clipboard external` and `escape-time 25` to handle clipboard escape sequences
- Allows clipboard operations to work over SSH without X11 forwarding

### Plugin Management

**ZSH Plugins:** Managed by custom `zfetch` function in `~/.cache/zsh/plugins/{org}/{repo}` structure
- Updated via `dotfiles zsh` or `zfetch update`
- Pulled via git from source repositories  
- Plugins loaded in `home/zshrc`:
  - zsh-completions
  - zsh-syntax-highlighting
  - zsh-history-substring-search
  - zsh-autosuggestions
  - pure (prompt)
  - zsh-autocomplete

**Neovim Plugins:** Managed by lazy.nvim
- Lock file: `config/nvim/lazy-lock.json`
- Updated via `dotfiles vim` or `:Lazy sync`

**Tmux Plugins:** Managed by TPM (Tmux Plugin Manager)
- Updated via `dotfiles tmux`
- Config: `config/tmux/tmux.conf`

### Mise Version Manager

If using mise for language version management:
- Configuration: `config/mise/config.toml`
- Activation cached in `~/.cache/zsh/mise-shellenv-cache.zsh` (regenerated when mise binary updates)
- Completions auto-generated: `dotfiles brew` updates mise completions
- Per-project versions: Create `.mise.toml` in project directories

**Performance note:** mise activation is cached to avoid slow shell startup. The cache regenerates automatically when the mise binary is updated.

### Utility Scripts Reference

**Located in `bin/`:**
- `dotfiles` - Main environment management script
- `git-sync` - Sync git repositories
- `cycle-bluetooth` - Toggle Bluetooth (macOS)
- `flash-glove80` - Flash Kinesis Glove80 keyboard firmware
- `gifify` - Convert videos to GIFs
- `hostit` - Local web server

**Located in `zsh/functions/` (auto-loaded):**
- `take` - Create directory and cd into it (quoted for safety)
- `tdev` - Create tmux development environment with panes
- `vi` / `vimdiff` - Smart editor wrapper (prefers nvim, falls back to vim/vi)
- `zfetch` - Plugin fetcher for ZSH plugins
- `install-terminfo` - Install terminfo on remote host via SSH
- `_dotfiles` - Completion function for dotfiles command
- `_git-sync` - Completion function for git-sync command
- `git-branch-current` - Get current git branch name

**Located in `zsh/utilities.zsh` (for setup scripts):**
- `is-darwin` / `is-linux` - Platform detection functions
- `log` / `logSub` / `err` - Colored logging functions
- `makedir` - Create directory with optional logging
- `link` - Create symlink with optional logging
- `dot-sleep` - Animated progress indicator

### Neovim Utilities

**Located in `config/nvim/lua/user/util/`:**
- `tmux-osc52.lua` - Custom clipboard provider for tmux integration with OSC 52 support
  - Exports `M.provider()` function that returns a clipboard provider table
  - Uses `tmux load-buffer -w` for copy operations
  - Implements paste via `tmux refresh-client -l` to request clipboard, then polls for new tmux buffer
  - Includes timeout and polling logic (50ms intervals, 1.5s timeout) for reliable paste operations
  - Used by `config/nvim/lua/user/config/options.lua` when running inside tmux

### File Type Associations

- `.zsh` files - ZSH functions and utilities
- `.lua` files - Neovim and Hammerspoon configs (format with StyLua)
- `Brewfile` - Homebrew package definitions (Ruby DSL)
- Dotfiles in `home/` - Various config formats (git, npm, etc.)
