if [ "$(command -v flatpak)" ]; then
  function flatpak-clean {
    flatpak uninstall --unused
    flatpak repair
  }
fi
