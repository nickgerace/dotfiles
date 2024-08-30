function si-build-cwd {
  buck2 build @//mode/release bin/sdf bin/rebaser bin/pinga bin/veritech bin/module-index
}

function si-build {
  pushd ~/src/si
  si-build-cwd
  popd
}

function si-build-rust {
  pushd ~/src/si
  buck2 uquery 'kind("rust_(binary|library|test)", set("//bin/..." "//lib/..."))' | xargs buck2 build
  popd
}

alias si-run-pinga="buck2 run @//mode/release //bin/pinga"
alias si-run-rebaser="buck2 run @//mode/release //bin/rebaser"
alias si-run-sdf="buck2 run @//mode/release //bin/sdf"
alias si-run-veritech="buck2 run @//mode/release //bin/veritech"

function si-up {
  buck2 run dev:down
  si-build-cwd
  buck2 run dev:up
}

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
