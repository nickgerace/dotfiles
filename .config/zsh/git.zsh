# ZSH GIT
# https://nickgerace.dev

# Set Git aliases.
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

# Set branch-related aliases.
alias branch="git rev-parse --abbrev-ref HEAD"
alias branches="git branch -a"
alias branch-new="git checkout -b"
alias branch-delete="git branch -d"

# Show tips and reminders when using Git.
alias squash='printf "git reset --soft HEAD~N\n"'
alias git-checkout-remote='printf "git checkout -b branch origin/branch\n"' 
alias git-delete-remote-tag='printf "git push --delete origin <tag>\n"'

# If a remote branch has been merged and deleted, sync the local repository accordingly.
function post-merge {
    if [[ ! $1 ]]; then
        printf "Requires main branch name as first argument.\n"
    else
        MERGED=$(git rev-parse --abbrev-ref HEAD)
        git pull --rebase origin $1
        git checkout $1
        git pull origin $1
        git branch -d $MERGED
    fi
}

# Show instructions on to rebase a forked Git repository.
function rebase-forked-repo {
    printf "git remote add upstream https://github.com/<org>/<repo>.git\n"
    printf "git fetch upstream\n"
    printf "git rebase upstream/<main>\n"
    printf "git push origin <main> --force\n"
}

