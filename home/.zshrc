# Main shell configuration. Loaded on every new terminal session.

# ── Environment variables & PATH ──────────────────────────────────────────────
source "${HOME}/.exports"

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="${HOME}/.oh-my-zsh"

# No theme — Starship handles the prompt (initialized at the bottom of this file)
ZSH_THEME=""

# Plugins (keep this list short — each one adds to startup time)
#   git               → git aliases and prompt info
#   brew              → homebrew completions
#   npm               → npm completions and aliases
#   vi-mode           → vim keybindings in the terminal (press Esc to enter normal mode)
#   zsh-autosuggestions    → grayed-out suggestions as you type (press → to accept)
#   zsh-syntax-highlighting → colors valid commands green, invalid commands red
#   zsh-completions        → extra tab completions for many tools
plugins=(
    git
    brew
    npm
    vi-mode
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

source "${ZSH}/oh-my-zsh.sh"

# ── Aliases ────────────────────────────────────────────────────────────────────
source "${HOME}/.aliases"

# ── Language version management (mise) ────────────────────────────────────────
# mise manages Python, Node.js, Go, and Java versions from a single tool.
# It intercepts commands (python, node, go, java) and routes them to the
# correct version based on the nearest .mise.toml or global config.
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

# ── Other tools ────────────────────────────────────────────────────────────────

# direnv: auto-load/unload environment variables when entering project directories
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# zoxide: smarter cd — learns your most visited dirs, use 'z <fuzzy-name>'
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# fzf: fuzzy finder key bindings (Ctrl+R for history, Ctrl+T for files)
if [[ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ]]; then
    source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
    source "/opt/homebrew/opt/fzf/shell/completion.zsh"
fi

# Use fd as the default source for fzf (respects .gitignore, shows hidden files)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

# ── Starship prompt ────────────────────────────────────────────────────────────
# Must be the very last line — initializes the custom prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi
