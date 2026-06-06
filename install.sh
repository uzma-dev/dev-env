#!/usr/bin/env bash
# Development environment setup script.
#
# Usage:
#   ./install.sh --name "Your Name" --email "you@example.com"
#   ./install.sh --name "Your Name" --email "you@example.com" --no-backup
#
# What this does:
#   1. Validates that you're on an Apple Silicon Mac
#   2. Installs Homebrew and all packages from Brewfile
#   3. Symlinks dotfiles from ./home/ to ~/  (using GNU Stow)
#   4. Installs language versions via pyenv, nodenv, goenv, jenv
#   5. Configures git with your name and email
#   6. Generates an SSH key for GitHub

set -euo pipefail   # exit on error, undefined vars, and pipe failures

# ── Source utilities ──────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils/logging.sh"
source "${SCRIPT_DIR}/utils/platform.sh"

# ── Parse arguments ───────────────────────────────────────────────────────────
GIT_NAME=""
GIT_EMAIL=""
SKIP_BACKUP=false

usage() {
    echo "Usage: $0 --name \"Your Name\" --email \"you@example.com\" [--no-backup]"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --name)  GIT_NAME="$2";  shift 2 ;;
        --email) GIT_EMAIL="$2"; shift 2 ;;
        --no-backup) SKIP_BACKUP=true; shift ;;
        --help|-h) usage ;;
        *) print_error "Unknown argument: $1"; usage ;;
    esac
done

if [[ -z "${GIT_NAME}" ]] || [[ -z "${GIT_EMAIL}" ]]; then
    print_error "Both --name and --email are required."
    usage
fi

# ── Pre-flight checks ─────────────────────────────────────────────────────────
print_header "Dev Environment Setup"
print_detail "Name:  ${GIT_NAME}"
print_detail "Email: ${GIT_EMAIL}"
echo ""

require_apple_silicon
export_xdg_vars

# Keep sudo alive for the duration of this script
sudo -v
(while true; do sudo -n true; sleep 50; done) &
SUDO_PID=$!
trap "kill ${SUDO_PID} 2>/dev/null" EXIT

# ── Step 1: Install dependencies ─────────────────────────────────────────────
print_step 1 6 "Installing dependencies"

print_action "Installing Xcode Command Line Tools..."
install_xcode_clt

print_action "Installing Homebrew..."
install_homebrew

print_action "Installing all packages from Brewfile..."
brew bundle --file="${SCRIPT_DIR}/Brewfile"
print_success "All packages installed"

# ── Step 2: Back up existing dotfiles ────────────────────────────────────────
print_step 2 6 "Backing up existing dotfiles"

if [[ "${SKIP_BACKUP}" == "true" ]]; then
    print_detail "Skipping backup (--no-backup passed)"
else
    BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "${BACKUP_DIR}"

    # List of files that stow will create symlinks for
    DOTFILES=(
        ".zshrc" ".zprofile" ".exports" ".aliases"
        ".config/starship.toml"
        ".config/wezterm"
        ".config/nvim"
        ".config/tmux"
        ".config/lazygit"
    )

    backed_up=0
    for dotfile in "${DOTFILES[@]}"; do
        src="${HOME}/${dotfile}"
        # Only back up real files/dirs (not existing symlinks from a previous install)
        if [[ -e "${src}" ]] && [[ ! -L "${src}" ]]; then
            mkdir -p "${BACKUP_DIR}/$(dirname "${dotfile}")"
            cp -r "${src}" "${BACKUP_DIR}/${dotfile}"
            # Remove the original so stow can create the symlink cleanly
            rm -rf "${src}"
            backed_up=$((backed_up + 1))
        fi
    done

    if [[ ${backed_up} -gt 0 ]]; then
        print_success "Backed up ${backed_up} existing files to ${BACKUP_DIR}"
        print_detail "Originals removed — stow will replace them with symlinks"
    else
        print_detail "No existing dotfiles to back up"
    fi
fi

# ── Step 3: Stow dotfiles ─────────────────────────────────────────────────────
print_step 3 6 "Symlinking dotfiles to ~/"

# GNU Stow creates symlinks from ./home/* → ~/
# --no-folding ensures it creates individual symlinks, not folder symlinks
stow --dir="${SCRIPT_DIR}" --target="${HOME}" home --no-folding --restow
print_success "Dotfiles symlinked to ~/"
print_detail "Config files are in ${SCRIPT_DIR}/home/ — edit them there"

# ── Step 4: Install oh-my-zsh and plugins ─────────────────────────────────────
print_step 4 6 "Installing shell plugins"

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    print_action "Installing oh-my-zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    print_success "oh-my-zsh installed"
else
    print_success "oh-my-zsh already installed"
fi

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

install_zsh_plugin() {
    local name="$1"
    local repo="$2"
    local dest="${ZSH_CUSTOM}/plugins/${name}"
    if [[ ! -d "${dest}" ]]; then
        print_action "Installing ${name}..."
        git clone --depth=1 "https://github.com/${repo}.git" "${dest}"
    else
        print_success "${name} already installed"
    fi
}

install_zsh_plugin "zsh-autosuggestions"   "zsh-users/zsh-autosuggestions"
install_zsh_plugin "zsh-syntax-highlighting" "zsh-users/zsh-syntax-highlighting"
install_zsh_plugin "zsh-completions"       "zsh-users/zsh-completions"

# ── Step 5: Install language versions ─────────────────────────────────────────
print_step 5 6 "Setting up language versions"
source "${SCRIPT_DIR}/utils/languages.sh"
install_all_languages

# ── Step 6: Configure git and SSH ─────────────────────────────────────────────
print_step 6 6 "Configuring git and SSH"

git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
git config --global core.editor "nvim"
git config --global init.defaultBranch "main"
git config --global pull.rebase false
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global delta.syntax-theme "Catppuccin-mocha"
print_success "Git configured for ${GIT_NAME} <${GIT_EMAIL}>"

SSH_KEY="${HOME}/.ssh/id_ed25519"
if [[ ! -f "${SSH_KEY}" ]]; then
    print_action "Generating SSH key..."
    mkdir -p "${HOME}/.ssh"
    chmod 700 "${HOME}/.ssh"
    ssh-keygen -t ed25519 -C "${GIT_EMAIL}" -f "${SSH_KEY}" -N ""
    print_success "SSH key generated at ${SSH_KEY}"
else
    print_success "SSH key already exists at ${SSH_KEY}"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
print_celebration "Setup complete!"

echo "Next steps:"
echo ""
echo "  1. Add your SSH public key to GitHub:"
echo "     cat ~/.ssh/id_ed25519.pub"
echo "     → paste it at https://github.com/settings/ssh/new"
echo ""
echo "  2. Open a new terminal window (or run 'source ~/.zshrc')"
echo "     to activate the new shell configuration."
echo ""
echo "  3. Open WezTerm for the best experience:"
echo "     Set the font to 'CaskaydiaCove Nerd Font' in Settings if icons look wrong."
echo ""
echo "  4. Open nvim once to let plugins auto-install:"
echo "     nvim"
echo ""
echo "  5. Open Raycast (Cmd+Space) and follow the setup wizard."
echo ""
