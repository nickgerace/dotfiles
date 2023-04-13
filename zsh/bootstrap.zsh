function bootstrap {
    if [ "$(command -v rustup)" ]; then
        local RUSTUP_OS
        local RUSTUP_ARCH

        RUSTUP_ARCH="$NICK_ARCH"
        if [ "$NICK_OS" = "darwin" ]; then
            if [ "$NICK_ARCH" = "arm64" ]; then
                RUSTUP_ARCH="aarch64"
            fi
            RUSTUP_OS="apple-darwin"
        elif [ "$NICK_LINUX" = "true" ]; then
            RUSTUP_OS="unknown-linux-gnu"
        fi
    
        rustup toolchain install stable-$RUSTUP_ARCH-$RUSTUP_OS
        rustup toolchain install nightly-$RUSTUP_ARCH-$RUSTUP_OS
        rustup default stable-$RUSTUP_ARCH-$RUSTUP_OS
    fi
}