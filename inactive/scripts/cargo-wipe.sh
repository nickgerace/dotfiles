#!/usr/bin/env bash
set -eu

for CARGO_DOT_TOML in $(find ~/src -type f -name Cargo.toml); do
  if [ -f $CARGO_DOT_TOML ]; then
    CRATE=$(dirname $CARGO_DOT_TOML)
    TARGET=$CRATE/target
    BASENAME=$(basename $CRATE)
    if [ -d $TARGET ]; then
      SIZE=$(du -hs $TARGET)
      read -n1 -p "Run \"cargo clean\" for $BASENAME? ($SIZE) [y/n]: " yn
      echo ""
      if [ "$yn" = "y" ]; then
        echo "Cleaning $BASENAME..."
        pushd "$CRATE"
        pwd
        cargo clean
        popd
      fi
    fi
  fi
done
