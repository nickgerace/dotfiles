#!/usr/bin/env bash
if [ ! $1 ] || [ "$1" = "" ] || [ ! -d $1 ]; then
    echo "required argument: <path-to-directory>"
    exit 1
fi

for CARGO_DOT_TOML in $(find $1 -type f -name Cargo.toml); do
    if [ -f $CARGO_DOT_TOML ]; then
        CRATE=$(dirname $CARGO_DOT_TOML)
        TARGET=$CRATE/target
        BASENAME=$(basename $CRATE)
        if [ -d $TARGET ]; then
            SIZE=$(du -hs $TARGET)
            echo "[ ✅ ] $SIZE"
            read -n1 -p "[ 🦀 ] run \"cargo clean\" for $BASENAME? [y/n]: " yn
            echo ""
            if [ "$yn" = "y" ]; then
                echo "[ 🧹 ] cleaning $BASENAME..."
                ( cd $CRATE; cargo clean )
            fi
        fi
    fi
done