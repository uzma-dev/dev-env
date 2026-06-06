# Homebrew package definitions.
# Run 'brew bundle' to install everything, or let install.sh handle it.
# Run 'brew bundle check' to see what's missing.

# ── Taps (extra package sources) ─────────────────────────────────────────────
tap "homebrew/cask-fonts"

# ── GNU utilities ─────────────────────────────────────────────────────────────
# These replace the older BSD versions that ship with macOS.
# After install, they're accessible from the PATH set in .exports.
brew "coreutils"       # GNU ls, cp, mv, etc.
brew "findutils"       # GNU find, xargs, locate
brew "gnu-sed"         # GNU sed (more features than macOS sed)
brew "grep"            # GNU grep

# ── Core system utilities ─────────────────────────────────────────────────────
brew "curl"            # HTTP client (newer than macOS's)
brew "wget"            # Download files from the web
brew "less"            # Pager (scroll through files)

# ── Shell & terminal ──────────────────────────────────────────────────────────
brew "starship"        # Cross-shell prompt (shows git, language versions, etc.)
brew "tmux"            # Terminal multiplexer — split terminal, keep sessions alive
brew "zoxide"          # Smarter cd: 'z project' jumps to ~/dev/my-project
brew "fzf"             # Fuzzy finder: Ctrl+R for history, Ctrl+T for files

# ── Modern CLI replacements ────────────────────────────────────────────────────
brew "eza"             # Better 'ls': colors, icons, git status
brew "bat"             # Better 'cat': syntax highlighting, line numbers
brew "fd"              # Better 'find': faster, respects .gitignore
brew "ripgrep"         # Better 'grep': very fast, respects .gitignore
brew "tree"            # Show directory structure as a tree
brew "jq"              # JSON processor: 'curl api | jq .name'
brew "yazi"            # Terminal file manager — navigate dirs, preview files (alias: y)
brew "ffmpegthumbnailer" # yazi: video thumbnails in file preview
brew "unar"            # yazi: open archives in preview
brew "poppler"         # yazi: PDF preview support
brew "imagemagick"     # yazi: image preview support
brew "exiftool"        # yazi: show media metadata in preview
brew "tldr"            # Simplified man pages — 'tldr git' shows practical examples
brew "ncdu"            # Interactive disk usage viewer — see what's eating space
brew "httpie"          # Friendlier curl — 'http GET api.example.com' returns colored JSON

# ── Version control ────────────────────────────────────────────────────────────
brew "git"             # Version control
brew "gh"              # GitHub CLI: create PRs, clone repos from terminal
brew "git-delta"       # Better git diff: syntax highlighting in diffs
brew "lazygit"         # Terminal UI for git — press 'lzg' to open

# ── Editor & dotfile management ────────────────────────────────────────────────
brew "neovim"          # Terminal text editor (see ~/.config/nvim/init.lua)
brew "stow"            # Dotfile symlink manager (used by install.sh)

# ── Monitoring & system info ───────────────────────────────────────────────────
brew "btop"            # Better 'top': visual CPU, memory, process monitor
brew "fastfetch"       # Print system info (run 'fastfetch' in terminal)

# ── Shell script quality ───────────────────────────────────────────────────────
brew "shellcheck"      # Shell script linter (catches bugs in .sh files)
brew "shfmt"           # Shell script formatter

# ── Language version management ────────────────────────────────────────────────
# mise is a single tool that replaces pyenv, nodenv, goenv, and jenv.
# One command: 'mise install python@latest', 'mise install node@lts', etc.
# One file per project: .mise.toml listing all required language versions.
brew "mise"            # Polyglot version manager (Python, Node, Go, Java, and more)
brew "llvm"            # C/C++ compiler toolchain (modern clang/clang++) — not managed by mise
brew "clang-format"    # C/C++ code formatter
brew "direnv"          # Load .envrc files per-directory (project env vars)

# ── GUI Applications ───────────────────────────────────────────────────────────
cask "visual-studio-code"   # Primary code editor (GUI)
cask "wezterm"              # Terminal emulator (see ~/.config/wezterm/wezterm.lua)
cask "orbstack"             # Docker engine + docker CLI (lighter than Docker Desktop)
brew "lazydocker"           # Terminal UI for Docker — press 'lzd' to open
cask "postman"              # API testing GUI
cask "raycast"              # App launcher + clipboard history + shortcuts (replaces Spotlight)
cask "bitwarden"            # Password manager
cask "maccy"                # Clipboard history manager
cask "the-unarchiver"       # Open .zip, .rar, .7z, .tar.gz files
cask "appcleaner"           # Completely uninstall apps (removes all related files)
cask "google-chrome"        # Browser
cask "brave-browser"        # Browser (privacy-focused, built-in ad blocker)

# Java JDK (managed by mise)
cask "temurin"              # Eclipse Temurin OpenJDK (free, open-source)

# ── Fonts ──────────────────────────────────────────────────────────────────────
# Nerd Fonts patch in icons/symbols — required for eza, starship, and nvim icons
cask "font-cascadia-code-nf"         # Microsoft's Cascadia Code with Nerd Font icons
cask "font-jetbrains-mono-nerd-font" # JetBrains Mono with Nerd Font icons
