#!/usr/bin/env bash
# Install language version managers and set up default language versions.
# Each function installs the manager (already in Brewfile), installs the
# latest stable version of the language, and sets it as the global default.

# ── Python via pyenv ────────────────────────────────────────────────────────
install_python() {
    print_header "Setting up Python"

    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"

    # Get latest stable Python 3.x (exclude pre-releases like 3.x.0a1)
    local version
    version=$(pyenv install --list 2>/dev/null \
        | grep -E '^\s+3\.[0-9]+\.[0-9]+$' \
        | tail -1 \
        | tr -d ' ')
    version="${version:-3.13.3}"

    if pyenv versions | grep -q "${version}"; then
        print_success "Python ${version} already installed"
    else
        print_action "Installing Python ${version}..."
        pyenv install "${version}"
    fi

    pyenv global "${version}"
    print_success "Python ${version} set as global default"
    print_detail "$(python3 --version 2>/dev/null)"
}

# ── Node.js via nodenv ──────────────────────────────────────────────────────
install_node() {
    print_header "Setting up Node.js"

    export NODENV_ROOT="${HOME}/.nodenv"
    export PATH="${NODENV_ROOT}/bin:${PATH}"
    eval "$(nodenv init -)"

    # Get latest LTS (even major version: 20.x, 22.x, 24.x)
    local version
    version=$(nodenv install --list 2>/dev/null \
        | grep -E '^\s+[0-9]+\.[0-9]+\.[0-9]+$' \
        | awk '$1 ~ /^(20|22|24)\./' \
        | tail -1 \
        | tr -d ' ')
    version="${version:-22.14.0}"

    if nodenv versions | grep -q "${version}"; then
        print_success "Node.js ${version} already installed"
    else
        print_action "Installing Node.js ${version}..."
        nodenv install "${version}"
    fi

    nodenv global "${version}"
    print_success "Node.js ${version} set as global default"
    print_detail "$(node --version 2>/dev/null)"
}

# ── Go via goenv ────────────────────────────────────────────────────────────
install_go() {
    print_header "Setting up Go"

    export GOENV_ROOT="${HOME}/.goenv"
    export PATH="${GOENV_ROOT}/bin:${PATH}"
    eval "$(goenv init -)"

    local version
    version=$(goenv install --list 2>/dev/null \
        | grep -E '^\s+[0-9]+\.[0-9]+\.[0-9]+$' \
        | tail -1 \
        | tr -d ' ')
    version="${version:-1.23.4}"

    if goenv versions | grep -q "${version}"; then
        print_success "Go ${version} already installed"
    else
        print_action "Installing Go ${version}..."
        goenv install "${version}"
    fi

    goenv global "${version}"
    print_success "Go ${version} set as global default"
    print_detail "$(go version 2>/dev/null)"
}

# ── Java via jenv + Temurin JDK ─────────────────────────────────────────────
install_java() {
    print_header "Setting up Java"

    export PATH="${HOME}/.jenv/bin:${PATH}"
    eval "$(jenv init -)"

    # temurin is installed via the Brewfile cask.
    # Register all installed Temurin JDKs with jenv.
    local jdk_home
    jdk_home="$(/usr/libexec/java_home 2>/dev/null)"

    if [[ -z "${jdk_home}" ]]; then
        print_warning "No JDK found. Make sure 'temurin' cask was installed via Homebrew."
        return 1
    fi

    jenv add "${jdk_home}" 2>/dev/null || true

    # Set the latest added version as global
    local jenv_version
    jenv_version=$(jenv versions --bare 2>/dev/null | grep -v 'system' | tail -1 | tr -d ' ')
    if [[ -n "${jenv_version}" ]]; then
        jenv global "${jenv_version}"
        print_success "Java ${jenv_version} set as global default"
    else
        print_warning "Could not detect Java version for jenv. Run 'jenv versions' after setup."
    fi
    print_detail "$(java -version 2>&1 | head -1)"
}

# ── C++ via LLVM (brew) ─────────────────────────────────────────────────────
setup_cpp() {
    print_header "Setting up C++"

    local llvm_prefix
    llvm_prefix="$(brew --prefix llvm 2>/dev/null)"

    if [[ -z "${llvm_prefix}" ]]; then
        print_warning "llvm not found. Skipping C++ setup."
        return 1
    fi

    # Verify clang and clang-format are available
    if [[ -x "${llvm_prefix}/bin/clang++" ]]; then
        print_success "Clang++ available at ${llvm_prefix}/bin/clang++"
    fi

    if command -v clang-format &>/dev/null; then
        print_success "clang-format available ($(clang-format --version 2>/dev/null | head -1))"
    fi

    print_detail "Add 'export PATH=\"\$(brew --prefix llvm)/bin:\$PATH\"' to .exports if you need clang to override system defaults."
}

# ── Run all ─────────────────────────────────────────────────────────────────
install_all_languages() {
    install_python
    install_node
    install_go
    install_java
    setup_cpp
}
