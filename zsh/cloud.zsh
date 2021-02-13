alias aws-login="aws configure"

function aws-create-key-pair {
    if [ ! $1 ] || [ ! $2 ]; then
        printf "Required argument(s): <key-name> <path-to-directory>\n"
    else
        ( cd ${2}; aws ec2 create-key-pair --key-name ${1} --query "KeyMaterial" --output text > ${1}.pem )
        ( cd ${2}; chmod 400 ${1}.pem )
    fi
}
