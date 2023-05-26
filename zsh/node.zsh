if [ -d "$HOME/Library/pnpm" ]; then
    # Docs: https://pnpm.io/installation
    export PNPM_HOME="$HOME/Library/pnpm"
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac

    alias pnpm-use-node="pnpm env use --global lts"
fi

if [ -d /opt/homebrew/opt/node@18/bin ]; then
    PATH=/opt/homebrew/opt/node@18/bin:$PATH
fi
