# ======================
#      BASH PROFILE
# https://nickgerace.dev
# ======================

# Load bashrc if it exists.
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
fi
