#!/usr/bin/unv python3

'''
CHECK GIT STATUS
created by: Nick Gerace

MIT License, Copyright (c) Nick Gerace
See "LICENSE" file for more information

Please find license and further
information via the link below.
https://github.com/nickgerace/dotfiles
'''

from subprocess import check_output

clime = '\033[38;5;70m'
cred = '\033[38;5;196m'
creset = '\033[38;5;0m'


def main():
    '''This script checks all repositories for their git status.'''
    base_path = "/Users/nick/github/"
    repositories = ['lateralus',
                    'dotfiles',
                    'full-stack-python-template',
                    'determinant-domination',
                    'private']
    success = ("On branch master\nYour branch is up to "
               "date with 'origin/master'.\n\nnothing to "
               "commit, working tree clean\n")

    # Begin git status
    print("=" * 20)
    for repository in repositories:
        path = base_path + repository
        git_status = check_output(["git", "-C", path, "status"])
        if success == git_status.decode("utf-8"):
            print("%sCLEAN:%s %s" % (clime, creset, repository))
        else: 
            print("%sWORKING:%s %s" % (cred, creset, repository))
    print("=" * 20)


if __name__ == '__main__':
    main()
