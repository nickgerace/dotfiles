function github-repos {
  REPOS=$(curl -s "https://api.github.com/users/nickgerace/repos?per_page=$(curl -s https://api.github.com/users/nickgerace | jq '.public_repos')")
  echo "active:"
  echo $REPOS | jq -r '.[] | select(.fork == false and .archived == false) | "  \(.name) :: \(.description)"'
  echo "archived:"
  echo $REPOS | jq -r '.[] | select(.fork == false and .archived == true) | "  \(.name) :: \(.description)"'
}

function github-branch-comparison {
  if [ ! $1 ] || [ ! $2 ] || [ ! $3 ]; then
    echo "required arguments: <owner/repo> <older-branch> <newer-branch>"
    echo "note: to specify a fork, use \"fork:branch\" rather than just \"branch\""
    return
  fi
  echo "https://github.com/$1/compare/$2...$3"
}

function github-shasum {
  if [ ! $1 ] || [ ! $2 ]; then
    echo "required arguments: <repo> <release-semver>"
    return
  fi

  SHA256SUM=true
  if [ "$(command -v shasum)" ]; then
    SHA256SUM=false
  fi

  for i in {1..5}; do
    wget https://github.com/nickgerace/${1}/archive/${2}.tar.gz >/dev/null 2>&1
    if [ "$SHA256SUM" = true ]; then
      sha256sum ${2}.tar.gz
    else
      shasum -a 256 ${2}.tar.gz
    fi
    rm ${2}.tar.gz
  done
}
