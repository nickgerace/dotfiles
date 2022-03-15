if [ "$(command -v flatpak)" ]; then
    function flatpak-clean {
        flatpak uninstall --unused
        flatpak repair
    }

    if [ -f /var/lib/flatpak/exports/bin/com.visualstudio.code ]; then
        alias code=/var/lib/flatpak/exports/bin/com.visualstudio.code
    fi
fi
