if [ "$(command -v aws)" ]; then
    alias aws-login="aws configure"

    function aws-create-key-pair {
        if [ ! $1 ] || [ ! $2 ]; then
            echo "required arguments: <key-name> <path-to-directory>"
            return
        fi
        # We change directory just in case the pathing is incorrect (e.g. a wildcard being accidentally included).
        ( cd ${2}; aws ec2 create-key-pair --key-name ${1} --query "KeyMaterial" --output text > ${1}.pem )
        ( cd ${2}; chmod 400 ${1}.pem )
    }

    function aws-delete-key-pair {
        if [ ! $1 ] || [ ! $2 ]; then
            echo "required arguments: <key-name> <path-to-directory-containing-key-file>"
            return
        fi
        aws ec2 delete-key-pair --key-name ${1}
        # We change directory just in case the pathing is incorrect (e.g. a wildcard being accidentally included).
        ( cd ${2}; rm -i ${1}.pem )
    }
fi
