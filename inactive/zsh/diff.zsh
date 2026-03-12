if [ "$(command -v diff)" ] && [ "$(command -v bat)" ]; then
  function diff-pretty {
    if [ ! $1 ] || [ ! $2 ]; then
      echo "required arguments: <file-left> <file-right>"
      return
    fi
    diff -u "$1" "$2" | bat --language=diff
  }
fi
