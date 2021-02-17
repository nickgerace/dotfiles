alias aws-login="aws configure"

function aws-create-key-pair {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Required argument(s): <key-name> <path-to-directory>\n"
    else
        ( cd ${2}; aws ec2 create-key-pair --key-name ${1} --query "KeyMaterial" --output text > ${1}.pem )
        ( cd ${2}; chmod 400 ${1}.pem )
    fi
}

function aws-delete-key-pair {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Required argument(s): <key-name> <path-to-directory-containing-key-file>\n"
    else
        aws ec2 delete-key-pair --key-name ${1}
        ( cd ${2}; rm -i ${1}.pem )
    fi
}
