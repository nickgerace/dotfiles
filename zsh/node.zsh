export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

if [ -d "/opt/homebrew/opt/node@16/bin" ]; then
    export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
fi
