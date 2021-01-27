if [ -d "/usr/local/opt/yq@3/bin" ]; then
    export PATH="/usr/local/opt/yq@3/bin:$PATH"
fi

function rc {
    if [ ! $1 ]; then
        printf "Required argument(s): <command> <optional-package-name>\nExample commands: prepare patch clean charts\n"
    else
        TEMP_PACKAGE=rancher-logging 
        if [ $2 ]; then
            TEMP_PACKAGE="${2}"
        fi
        ( cd $HOME/rancher-charts; PACKAGE=${TEMP_PACKAGE} make ${1} )
    fi
}

