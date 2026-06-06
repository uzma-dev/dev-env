#!/usr/bin/env bash
# Colored output helpers for the install script.

# Detect if the terminal supports color
has_color_support() {
    [[ -t 1 ]] && [[ "$(tput colors 2>/dev/null)" -ge 8 ]]
}

# ANSI color codes
if has_color_support; then
    RESET="\033[0m"
    BOLD="\033[1m"
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[0;33m"
    BLUE="\033[0;34m"
    CYAN="\033[0;36m"
    GRAY="\033[0;90m"
else
    RESET="" BOLD="" RED="" GREEN="" YELLOW="" BLUE="" CYAN="" GRAY=""
fi

print_header() {
    echo -e "\n${BOLD}${BLUE}==> $1${RESET}"
}

print_step() {
    # Usage: print_step 2 6 "Installing packages"
    echo -e "\n${BOLD}[Step $1/$2]${RESET} $3"
}

print_action() {
    echo -e "  ${CYAN}→${RESET} $1"
}

print_success() {
    echo -e "  ${GREEN}✓${RESET} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${RESET} $1"
}

print_error() {
    echo -e "  ${RED}✗${RESET} $1" >&2
}

print_detail() {
    echo -e "  ${GRAY}$1${RESET}"
}

print_celebration() {
    echo -e "\n${BOLD}${GREEN}🎉 $1${RESET}\n"
}
