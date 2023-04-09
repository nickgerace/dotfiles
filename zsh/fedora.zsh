# Needed until the following issue is resolved: https://github.com/pop-os/system76-power/issues/299
if [ "$NICK_OS" = "fedora" ]; then
    function s76-power-start {
        sudo systemctl start system76-power
    }
fi

if [ "$(command -v dnf)" ]; then
    alias dnf-list-installed='sudo dnf repoquery --userinstalled --queryformat "%{NAME}"'
    alias dnf-list-repositories='sudo dnf repolist'

    function dnf-disable-repository {
        if [ ! $1 ] || [ "$1" = "" ]; then
            echo "must provide argument: <dnf-repository-name>"
            return
        fi
        sudo dnf config-manager --set-disabled $1
    }
fi