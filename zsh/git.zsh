alias g="git"
alias gbc="git branch --show-current"
alias gbva="git branch -v -a"
alias gcdf="git clean -df"
alias gcl="git config -l"
alias gd="git diff"
alias gpo="git push origin"
alias gpull="git pull"
alias gpullo="git pull origin"
alias gst="git status"
alias gcs="git commit -s"
alias gc="git commit"

alias git-copy="git diff --cached -M -C -C"
alias git-branch-current="git branch --show-current"
alias git-clean-all-"git clean -fd"
alias git-config-pull-fix="git config --global pull.ff only"
alias git-history="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias git-reset-repo-to-last-commmit="git reset --hard"
alias git-reset-undo="git reset 'HEAD@{1}'"
alias git-show-tags='git log --tags --simplify-by-decoration --pretty="format:%ci %d"'
alias git-squash='echo "git reset --soft HEAD~N"' 
alias git-update-branches="git remote update origin --prune"

alias branch="git rev-parse --abbrev-ref HEAD"

function post-merge {
    if [ ! $1 ]; then
        echo "required argument: <main-branch>"
        return
    fi

    local DELETE
    DELETE=$(git rev-parse --abbrev-ref HEAD)
    if [ "$1" = "$DELETE" ]; then
        echo "cannot delete main branch: $1"
        return
    fi

    git checkout $1
    git pull origin $1
    git branch -d $DELETE
    git pull --prune
}

function rebase-forked-repo {
    if [ ! $1 ]; then
        echo "requires arguments: <upstream-branch> <OPTIONAL-provide-full-remote-address>"
        return
    fi
    if [ $2 ] && [ "$2" != "" ]; then
        if [ "$(git remote | grep upstream)" ]; then
            git remote remove upstream
        fi
        git remote add upstream $2
        git remote -v
    fi
    if git ls-remote upstream > /dev/null; then
        git fetch upstream
        git rebase upstream/$1
    else
        echo "could not find expected remote: upstream"
    fi
}

function git-checkout-tag {
    if [ ! $1 ]; then
        echo "required argument: <tag>"
        return
    fi
    git fetch --all --tags
    local DOES_EXIST=$(git branch --list $1)
    if [[ -z ${DOES_EXIST} ]]; then
        git checkout tags/$1 -b $1
    else
        echo "branch already exists"
    fi
}

function git-checkout-remote-branch {
    if [ ! $1 ] || [ "$1" = "" ]; then
        echo "required argument: <remote-branch-name>"
        return
    fi
    git checkout -b $1 origin/$1
}

function git-diff-check-permissions {
    ls -l $(git diff --name-only)
}

function github-clone {
    if [ ! $1 ]; then
        echo "required argument(s): <repo-under-nickgerace> <optional-destination-path>"
    elif [ ! $2 ]; then
        git clone git@github.com:nickgerace/${1}
    else
        git clone git@github.com:nickgerace/${1} ${2}
    fi
}

function github-branch-comparison {
    if [ ! $1 ] || [ ! $2 ] || [ ! $3 ]; then
        echo "required arguments: <owner/repo> <older-branch> <newer-branch>"
        echo "note: to specify a fork, use \"fork:branch\" rather than just \"branch\""
        return
    fi
    echo "https://github.com/$1/compare/$2...$3"
}

function git-delete-remote-branch {
    if [ ! $1 ] || [ "$1" != "" ]; then
        echo "required argument: <branch-name>"
        return
    fi
    git push origin --delete $1
    git branch -D $1
}

function git-delete-remote-tag {
    if [ ! $1 ] || [ "$1" != "" ]; then
        echo "required argument: <tag-name>"
        return
    fi
    git push --delete origin $1
}

function gpob {
    git push origin $(git branch --show-current)
}

function status {
    if ! [ "$(command -v fd)" ]; then
        echo "fd needs to be installed in an PATH"
        return
    fi
    local CWD
    CWD=$(pwd)
    local FIRST
    FIRST="true"

    cd $NICK_SRC
    for REPO in $(fd -t d); do
        if [ -d $REPO/.git ]; then
            if [ "$FIRST" = "true" ]; then
                FIRST="false"
            else
                echo ""
            fi
            echo -e "\033[1m$REPO\033[0m"
            ( cd $REPO; git branch --show-current; git status -s; git config --get remote.origin.url; git config --get user.email )
        fi
    done
    cd $CWD
}
