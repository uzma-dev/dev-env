#!/usr/bin/env bash
# Platform detection and system validation helpers.

die() {
    print_error "$1"
    exit 1
}

is_apple_silicon() {
    [[ "$(uname -m)" == "arm64" ]]
}

require_apple_silicon() {
    if ! is_apple_silicon; then
        die "This setup is designed for Apple Silicon Macs (M1/M2/M3/M4). Detected: $(uname -m)"
    fi
}

# Set XDG base directory variables (standard locations for config, cache, data)
export_xdg_vars() {
    export XDG_CONFIG_HOME="${HOME}/.config"
    export XDG_CACHE_HOME="${HOME}/.cache"
    export XDG_DATA_HOME="${HOME}/.local/share"
    export XDG_STATE_HOME="${HOME}/.local/state"
}

install_homebrew() {
    if command -v brew &>/dev/null; then
        print_success "Homebrew already installed"
        return 0
    fi

    print_action "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the current session (Apple Silicon path)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    print_success "Homebrew installed"
}

install_xcode_clt() {
    if xcode-select -p &>/dev/null; then
        print_success "Xcode Command Line Tools already installed"
        return 0
    fi

    print_action "Installing Xcode Command Line Tools (this may take a few minutes)..."
    xcode-select --install 2>/dev/null || true

    # Wait for installation to finish
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    print_success "Xcode Command Line Tools installed"
}
