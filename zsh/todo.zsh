function ssh-keygen-nickgerace {
  ssh-keygen \
  	-N '' \
  	-C "nickgerace-$(date -u +%FT%TZ)" \
  	-t rsa \
  	-b 4096 \
  	-a 100
}

function cargo-wipe {
  local CRATE
  local TARGET
  local BASENAME
  local SIZE
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
          echo "would run cargo clean"
          # cargo clean
          popd
        fi
      fi
    fi
  done
}

function github-repos {
  REPOS=$(curl -s "https://api.github.com/users/nickgerace/repos?per_page=$(curl -s https://api.github.com/users/nickgerace | jq -r '.public_repos')")
  echo "[ACTIVE]"
  echo $REPOS | jq -r '.[] | select(.fork != true) | select(.archived != true) | .name'
  echo ""
  echo "[ARCHIVED]"
  echo $REPOS | jq -r '.[] | select(.fork != true) | select(.archived == true) | .name'
}

if [ "$NICK_OS" = "darwin" ]; then
  function darwin-launch-daemons {
    function scan-directory {
      echo "---"
      echo "$1"
      sudo ls $1 | rg -v "com\.apple"
    }

    scan-directory ~/Library/LaunchAgents # per-user agents <-- user
    scan-directory /Library/LaunchAgents # per-user agents <-- administrator
    scan-directory /Library/LaunchDaemons # system-wide daemons <-- administrator
    scan-directory /System/Library/LaunchAgents # per-user agents <-- macOS
    scan-directory /System/Library/LaunchDaemons # system-wide ademons <-- macOS
  }
fi

function github-shasum {
  if [ ! $1 ] || [ ! $2 ]; then
    echo "required arguments: <repo-from-nickgerace> <release-semver>"
    return
  fi  

  local SHA256SUM
  SHA256SUM=true
  if [ "$(command -v shasum)" ]; then
    SHA256SUM=false
  fi

  for i in {1..5}; do
    wget https://github.com/nickgerace/${1}/archive/${2}.tar.gz > /dev/null 2>&1
    if [ "$SHA256SUM" = true ]; then
      sha256sum ${2}.tar.gz
    else
      shasum -a 256 ${2}.tar.gz
    fi
    rm ${2}.tar.gz
  done
}

