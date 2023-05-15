function shfmt-write {
    if [ ! $1 ] || [ $1 = "" ]; then
        echo "must provide file to shfmt and write back to"
        return
    fi
    shfmt -l -w $1
}
