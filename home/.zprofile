# Runs once at login. Initializes Homebrew so all brew-installed tools are
# available in the PATH before anything else loads.

if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
