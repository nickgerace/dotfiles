function shfmt-write {
  if [ -z "$1" ]; then
    echo "must provide file to shfmt and write back to"
    return
  fi
  shfmt -l -i 2 -w "$1"
}
