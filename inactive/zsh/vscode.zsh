if [ "$(command -v flakpak)" ] && [ -f /var/lib/flatpak/exports/bin/com.visualstudio.code ]; then
  alias code=/var/lib/flatpak/exports/bin/com.visualstudio.code
fi
