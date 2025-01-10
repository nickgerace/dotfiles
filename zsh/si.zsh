function si-run-remote {
  TILT_HOST=0.0.0.0 DEV_HOST=0.0.0.0 buck2 run //dev:up-debug
}

function si-run-remote-release {
  TILT_HOST=0.0.0.0 DEV_HOST=0.0.0.0 buck2 run //dev:up
}

function si-run-remote-with-local-module-index {
  VITE_MODULE_INDEX_API_URL=http://nixos:5157 \
    SI_MODULE_INDEX_URL=http://localhost:5157 \
    TILT_HOST=0.0.0.0 DEV_HOST=0.0.0.0 buck2 run //dev:up-debug
}

function si-build-cwd {
  time buck2 build @//mode/debug bin/sdf bin/rebaser bin/pinga bin/veritech bin/forklift app/docs:dev app/web:dev
}

function si-build-cwd-release {
  time buck2 build @//mode/release bin/sdf bin/rebaser bin/pinga bin/veritech bin/forklift app/docs:dev app/web:dev
}

function si-build {
  pushd ~/src/si
  si-build-cwd
  popd
}

function si-build-release {
  pushd ~/src/si
  si-build-cwd
  popd
}

function si-build-rust {
  pushd ~/src/si
  buck2 uquery 'kind("rust_(binary|library|test)", set("//bin/..." "//lib/..."))' | xargs buck2 build @//mode/debug
  popd
}

alias si-run-pinga="buck2 run @//mode/debug //bin/pinga"
alias si-run-rebaser="buck2 run @//mode/debug //bin/rebaser"
alias si-run-sdf="buck2 run @//mode/debug //bin/sdf"
alias si-run-veritech="buck2 run @//mode/debug //bin/veritech"

function si-branches {
  function si-print-branch {
    echo "  ─ $branch"
    echo "    └── $(git log -1 --pretty=format:%s $branch)"
  }

  pushd ~/src/si

  echo ""
  echo "LOCAL"
  for branch in $(git branch); do
    if [[ $branch != *"*"* ]] && [[ $branch != "main" ]]; then
      si-print-branch $1
    fi
  done
  echo ""
  echo "REMOTE"
  for branch in $(git branch -a); do
    if [[ $branch == *"origin"* ]] && [[ $branch == *"nick"* ]]; then
      si-print-branch $1
    fi
  done
  echo ""

  popd
}

if [ "$NICK_OS" = "darwin" ]; then
  function si-wipe-cache {
    setopt PUSHDSILENT

    pushd /tmp
    for WIPE_NIX_SHELL in $(ls | rg "nix-shell\.."); do
      pushd $WIPE_NIX_SHELL
      for WIPE_CACHE_DIR in $(ls | rg ".\-cache\-."); do
        echo $WIPE_CACHE_DIR
        rm -r $WIPE_CACHE_DIR
      done
      popd
    done
    popd

    unsetopt PUSHDSILENT
  }
fi
