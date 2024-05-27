#!/bin/sh -l
set -e
upstream_repo="$1"
branchs="$2"
branchs=$(echo "$branchs" | sed 's/,/\n/g')
git config --global --add safe.directory /github/workspace
# add upstream
git remote add upstream https://github.com/${upstream_repo}.git
git fetch upstream 
git fetch origin
if [[ $branchs = "" ]]; then
    branchs=$(git branch -r --list upstream/*|cut -d/ -f2- | grep -v 'HEAD')
fi
for branch in ${branchs}; do
    if git ls-remote --exit-code --heads origin ${branch} &> /dev/null; then
        git checkout -b ${branch} origin/${branch} || git checkout ${branch}
        echo exists $(git branch --show-current)
        git merge upstream/${branch}
        echo merge upstream/${branch} into origin/${branch}
    else
        git checkout -b ${branch} upstream/${branch}
        git push origin ${branch} -f
    fi
done
