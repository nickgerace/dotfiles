if [ ! "$(command -v github-linguist)" ]; then
  function docker-run-github-linguist {
    if docker image inspect linguist; then
      echo "found 'linguist' docker image"
    else
      echo "building 'linguist' docker image..."
      pushd "$(mktemp -d)"
      git clone https://github.com/github-linguist/linguist.git --depth=1
      pushd linguist
      docker build -t linguist .
      popd
      popd
    fi
    echo "running 'github-linguist' using 'linguist' docker image..."
    docker run \
      --user $(id -u) \
      --rm \
      -v $(pwd):$(pwd) \
      -w $(pwd) \
      -t linguist \
      github-linguist
  }
fi
