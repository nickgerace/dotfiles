if [ "$(command -v zypper)" ]; then
    alias zin="sudo zypper install -y"
    alias zup="sudo zypper update -y"
    alias zrm="sudo zypper remove -y"
fi

# Upstream issue: https://github.com/microsoft/WSL/issues/2530#issuecomment-879597974
if [ "$NICK_WSL2" = "true" ] && [ "$NICK_OS" = "opensuse-tumbleweed" ]; then
    export TMUX_TMPDIR='/tmp'
fi