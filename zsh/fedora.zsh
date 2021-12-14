# Needed until the following issue is resolved: https://github.com/pop-os/system76-power/issues/299
if [ "$NICK_OS" = "fedora" ]; then
    function s76-power-start {
        sudo systemctl start system76-power
    }
fi
