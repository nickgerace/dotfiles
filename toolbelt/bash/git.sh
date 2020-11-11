# BASH GIT
# https://nickgerace.dev

alias g="git"
alias gd="git diff"
alias gadd="git add"
alias gcomm="git commit"
alias gcommit="git commit"
alias gcs="git commit -s"
alias gcomms="git commit -s"
alias gdiff="git diff"
alias gpo="git push origin"
alias gpull="git pull"
alias gpu="git pull"
alias gpuo="git pull origin"
alias gst="git status"
alias gstat="git status"
alias reset-repo-to-last-commmit="git reset --hard"
alias git-pull-fix="git config --global pull.ff only"
alias git-show-tags='git log --tags --simplify-by-decoration --pretty="format:%ci %d"'

alias gbva="git branch -v -a"
alias branch="git rev-parse --abbrev-ref HEAD"
alias branches="git branch -a"
alias branch-new="git checkout -b"
alias branch-delete="git branch -d"

alias squash='printf "git reset --soft HEAD~N\n"'
alias git-checkout-remote='printf "git checkout -b branch origin/branch\n"' 
alias git-delete-remote-tag='printf "git push --delete origin <tag>\n"'

function post-merge {
    if [[ ! $1 ]]; then
        printf "Requires main branch name as first argument.\n"
    else
        MERGED=$(git rev-parse --abbrev-ref HEAD)
        git pull --rebase origin $1
        git checkout $1
        git pull origin $1
        git branch -d $MERGED
        git pull --prune
    fi
}

function rebase-forked-repo {
    if [[ ! $1 || ! $2 || ! $3 ]]; then
        printf "[-] Requires three arguments: <github-org/original-repo> <original-branch> <forked-branch>\n"
    else
        printf "\n[+] Starting rebase from original repository to forked repository...\n"
        git remote add upstream https://github.com/${1}.git
        git fetch upstream
        git rebase upstream/${2}
        git push origin ${3} --force
        printf "\n[+] Done! Current remotes...\n"
        git remote -v
    fi
}

function rebase-forked-repo-git {
    if [[ ! $1 || ! $2 || ! $3 ]]; then
        printf "[-] Requires three arguments: <github-org/original-repo> <original-branch> <forked-branch>\n"
    else
        printf "\n[+] Starting rebase from original repository to forked repository...\n"
        git remote add upstream git@github.com:${1}.git
        git fetch upstream
        git rebase upstream/${2}
        git push origin ${3} --force
        printf "\n[+] Done! Current remotes...\n"
        git remote -v
    fi
}

function checkout-tag {
    if [ ! $1 ]; then
        printf "argument(s): <tag>"
    else
        git fetch --all --tags
        BRANCH=tag-${1}
        DOES_EXIST=$(git branch --list ${BRANCH})
        if [[ -z ${DOES_EXIST} ]]; then
            git checkout tags/${1} -b ${BRANCH}
        else
            TAG_BRANCHES=$(git branch | grep tag-*)
            printf "Branch already exists: ${BRANCH}\nAll existing tags with 'tag' prepended...\n${TAG_BRANCHES}\n"
        fi
    fi
}
