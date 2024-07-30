function bash-path-to-script {
  echo 'SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd -P)'
}
