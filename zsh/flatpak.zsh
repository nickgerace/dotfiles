if [ "$(command -v flatpak)" ]; then
  function flatpak-clean {
    flatpak uninstall --unused
    filatpak repair
  }
fi
