#!/usr/bin/env bash
# Install language versions using mise — a single tool that manages
# Python, Node.js, Go, and Java (replaces pyenv, nodenv, goenv, jenv).
#
# Usage: source this file, then call install_all_languages
#
# mise stores versions in ~/.local/share/mise/
# Per-project versions: create a .mise.toml file in your project directory.

# ── Ensure mise is initialized ───────────────────────────────────────────────
_init_mise() {
    if ! command -v mise &>/dev/null; then
        print_error "mise not found. Make sure 'brew install mise' ran successfully."
        exit 1
    fi
    eval "$(mise activate bash)"   # activate in this script's shell context
}

# ── Python ───────────────────────────────────────────────────────────────────
install_python() {
    print_header "Setting up Python"
    print_action "Installing latest Python via mise..."
    mise install python@latest
    mise use --global python@latest
    print_success "Python $(mise exec python -- python3 --version 2>/dev/null) set as global default"
}

# ── Node.js ──────────────────────────────────────────────────────────────────
install_node() {
    print_header "Setting up Node.js"
    print_action "Installing latest Node.js LTS via mise..."
    mise install node@lts
    mise use --global node@lts
    print_success "Node.js $(mise exec node -- node --version 2>/dev/null) set as global default"
}

# ── Go ───────────────────────────────────────────────────────────────────────
install_go() {
    print_header "Setting up Go"
    print_action "Installing latest Go via mise..."
    mise install go@latest
    mise use --global go@latest
    print_success "Go $(mise exec go -- go version 2>/dev/null) set as global default"
}

# ── Java ─────────────────────────────────────────────────────────────────────
install_java() {
    print_header "Setting up Java"
    # temurin@21 is the current LTS release of the Temurin OpenJDK
    print_action "Installing Java (Temurin 21 LTS) via mise..."
    mise install java@temurin-21
    mise use --global java@temurin-21
    print_success "Java $(mise exec java -- java -version 2>&1 | head -1) set as global default"
}

# ── C++ (LLVM via brew — not managed by mise) ────────────────────────────────
setup_cpp() {
    print_header "Setting up C++"

    local llvm_prefix
    llvm_prefix="$(brew --prefix llvm 2>/dev/null)"

    if [[ -z "${llvm_prefix}" ]]; then
        print_warning "llvm not found. Skipping C++ setup."
        return 1
    fi

    if [[ -x "${llvm_prefix}/bin/clang++" ]]; then
        print_success "clang++ available: $(${llvm_prefix}/bin/clang++ --version 2>/dev/null | head -1)"
    fi

    if command -v clang-format &>/dev/null; then
        print_success "clang-format available: $(clang-format --version 2>/dev/null)"
    fi
}

# ── Run all ──────────────────────────────────────────────────────────────────
install_all_languages() {
    _init_mise
    install_python
    install_node
    install_go
    install_java
    setup_cpp

    print_header "mise summary"
    mise list 2>/dev/null || true
    print_detail "Run 'mise help' to see all commands."
    print_detail "Per-project: add a .mise.toml to your project root (see README)."
}
