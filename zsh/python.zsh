if [ "$(command -v virtualenv)" ]; then
  function venv-start {
    if [ ! $1 ]; then
      echo "requires argument: <virtualenv-name>"
      return
    fi
  
    mkdir -p "${HOME}/.venv/${1}"
    virtualenv -p python3 "${HOME}/.venv/${1}"
    echo "execute the following: source ${HOME}/.venv/${1}/bin/activate"
  }
fi
