if [ -f "$HOME/.local/bin/claude" ]; then
  function claude {
    echo "pick one of the below:"
    echo "  claude-personal"
    echo "  claude-work"
  }

  alias claude-personal="CLAUDE_CONFIG_DIR=$HOME/.claude-personal $HOME/.local/bin/claude"
  alias claude-work="CLAUDE_CONFIG_DIR=$HOME/.claude-work $HOME/.local/bin/claude"
fi
