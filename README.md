# dev-env

A clean, minimal macOS development environment for Python, JavaScript/Node.js, C++, Java, and Go.

Designed to be **easy to understand** — every tool has a one-line explanation, and all config files are commented.

---

## What's included

### Terminal & Shell
| Tool | What it does |
|------|-------------|
| [WezTerm](https://wezfurlong.org/wezterm/) | Terminal emulator — fast, GPU-accelerated, configured in `~/.config/wezterm/wezterm.lua` |
| [Zsh](https://www.zsh.org/) + [oh-my-zsh](https://ohmyz.sh/) | Shell with git integration, auto-suggestions, and syntax highlighting |
| [Starship](https://starship.rs/) | Prompt that shows your current directory, git branch, and active language version |
| [Tmux](https://github.com/tmux/tmux) | Split your terminal into panes; keep sessions alive after closing the window. Run `ta` to start |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder — press `Ctrl+R` to search command history, `Ctrl+T` to find files |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` — type `z proj` to jump to `~/dev/my-project` |

### Editor
| Tool | What it does |
|------|-------------|
| [VS Code](https://code.visualstudio.com/) | Main GUI editor — open a project with `code .` |
| [Neovim](https://neovim.io/) | Terminal editor — type `v` or `nvim` to open. Configured in `~/.config/nvim/init.lua` |

### Modern CLI replacements
| Alias | Replaces | Why it's better |
|-------|---------|-----------------|
| `ls` → `eza` | `ls` | Colors, icons, git status in file listing |
| `cat` → `bat` | `cat` | Syntax highlighting and line numbers |
| `find` → `fd` | `find` | Faster, simpler syntax, respects `.gitignore` |
| `grep` → `ripgrep` | `grep` | Much faster, respects `.gitignore` |

### Git tools
| Tool | What it does |
|------|-------------|
| [git-delta](https://github.com/dandavison/delta) | Better `git diff` — syntax-highlighted diffs |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git — press `lzg` to open |
| [gh](https://cli.github.com/) | GitHub from the terminal — create PRs, clone repos |

### Language version management
| Tool | What it does |
|------|-------------|
| [mise](https://mise.jdx.dev/) | Single tool that manages Python, Node.js, Go, and Java versions |
| [llvm](https://llvm.org/) (brew) | C/C++ compiler toolchain — `clang++` and `clang-format` |

**One tool instead of four.** mise replaces pyenv, nodenv, goenv, and jenv with a single consistent interface:

```bash
mise install python@latest    # install latest Python
mise install node@lts         # install latest Node.js LTS
mise install go@latest        # install latest Go
mise install java@temurin-21  # install Java 21 LTS

mise use --global python@latest   # set global default
```

**Per-project versions**: Add a `.mise.toml` to any project directory:

```toml
# .mise.toml — one file for all languages in this project
[tools]
python = "3.11"
node   = "20"
go     = "1.22"
java   = "temurin-21"
```

Then run `mise install` inside the project to install those exact versions. mise switches automatically when you `cd` into the directory.

### Docker
| Tool | What it does |
|------|-------------|
| [OrbStack](https://orbstack.dev/) | Docker engine + CLI — much faster and lighter than Docker Desktop. Includes the `docker` command |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | Terminal UI for Docker — press `lzd` to open |

### Productivity apps
| App | What it does |
|-----|-------------|
| [Raycast](https://www.raycast.com/) | Replaces Spotlight (`Cmd+Space`) — app launcher, clipboard history, snippets |
| [Postman](https://www.postman.com/) | Test REST and GraphQL APIs |
| [Bitwarden](https://bitwarden.com/) | Password manager |
| [Maccy](https://maccy.app/) | Clipboard history — press `Shift+Cmd+C` to see past copies |
| [AppCleaner](https://freemacsoft.net/appcleaner/) | Fully uninstall apps (removes all associated files) |
| [The Unarchiver](https://theunarchiver.com/) | Open .zip, .rar, .7z, .tar.gz archives |

---

## Installation

**Requirements**: Apple Silicon Mac (M1/M2/M3/M4), macOS 13+

```bash
# 1. Clone this repo
git clone <this-repo-url> ~/dev-env
cd ~/dev-env

# 2. Run the installer
chmod +x install.sh
./install.sh --name "Your Name" --email "you@example.com"
```

After it finishes:
1. Add the SSH key to GitHub: `cat ~/.ssh/id_ed25519.pub` → paste at github.com/settings/ssh/new
2. Open a new terminal window
3. Run `nvim` once to let plugins install automatically

---

## Project structure

```
dev-env/
├── install.sh              # Main installer — run this
├── Brewfile                # All packages to install via Homebrew
├── home/                   # Dotfiles — stowed (symlinked) to ~/
│   ├── .zshrc              # Shell config
│   ├── .exports            # PATH and environment variables
│   ├── .aliases            # Shortcuts (ls, cat, git, docker, etc.)
│   ├── .zprofile           # Login shell (Homebrew init)
│   └── .config/
│       ├── starship.toml   # Prompt configuration
│       ├── wezterm/        # Terminal emulator config
│       ├── nvim/           # Neovim config (init.lua)
│       ├── tmux/           # Tmux config
│       └── lazygit/        # Lazygit config
└── utils/
    ├── logging.sh          # Colored output for install script
    ├── platform.sh         # System detection and Homebrew install
    └── languages.sh        # Language version setup (pyenv, nodenv, etc.)
```

**Important**: Edit config files inside `home/` (e.g., `home/.zshrc`), not directly in `~/`. The installer creates symlinks so changes take effect immediately.

---

## Common tasks

### Add a new shell alias
Edit `home/.aliases`, then run `reload` (alias for `source ~/.zshrc`).

### Change terminal font size
Edit `home/.config/wezterm/wezterm.lua`, change `config.font_size`.

### Install a specific language version
```bash
# Install any version
mise install python@3.11
mise install node@20
mise install go@1.22
mise install java@temurin-21

# Set as the global default
mise use --global python@3.11

# Pin a version for just one project
cd my-project
mise use python@3.11     # writes .mise.toml in the current directory
```

### Update everything
```bash
buu                       # alias for: brew update && brew upgrade && brew cleanup
```

### Search command history
```bash
hs                        # fuzzy search (fzf)
hg docker                 # grep: show all commands containing "docker"
```

### Start/resume a tmux session
```bash
ta                        # attach to existing session or create new one named "main"
```

---

## Neovim key bindings

The leader key is **Space**. Press `Space` and wait 0.5s to see all available shortcuts.

| Keys | Action |
|------|--------|
| `Space ff` | Find files (fuzzy) |
| `Space fg` | Search text across all files |
| `Space fb` | Switch between open files |
| `Space fr` | Recent files |
| `Space f` | Format current file (LSP) |
| `Space rn` | Rename symbol |
| `Space ca` | Code actions |
| `Space e` | Show error details |
| `gd` | Go to definition |
| `gr` | Find all references |
| `K` | Show documentation |
| `[d` / `]d` | Go to previous/next error |
| `Ctrl+H/J/K/L` | Move between splits |

---

## Keyboard shortcuts reference

### Tmux (prefix = Ctrl+A)
| Keys | Action |
|------|--------|
| `Ctrl+A \|` | Split pane left/right |
| `Ctrl+A -` | Split pane top/bottom |
| `Ctrl+A h/j/k/l` | Move between panes |
| `Ctrl+A [` | Enter scroll mode (use arrows or `k`/`j`) |
| `Ctrl+A r` | Reload tmux config |

### WezTerm
| Keys | Action |
|------|--------|
| `Cmd+D` | Split pane horizontally |
| `Cmd+Shift+D` | Split pane vertically |
| `Cmd+Alt+Arrow` | Move between panes |
| `Cmd+T` | New tab |

---

## Troubleshooting

**Icons look like boxes or question marks**
→ Set your terminal font to `CaskaydiaCove Nerd Font` or `JetBrainsMono Nerd Font`.

**`mise: command not found`** or language versions not switching
→ Open a new terminal window, or run `source ~/.zshrc`.

**Neovim plugins didn't install**
→ Run `nvim` and wait ~30 seconds. If nothing happens, run `:Lazy sync` inside nvim.

**`brew bundle` fails on a package**
→ Run `brew install <package-name>` manually to see the error. Some packages (like `temurin`) need to accept a license.

**Language server not working in Neovim**
→ Run `:Mason` inside nvim to see what's installed. Press `i` on a server to install it.
