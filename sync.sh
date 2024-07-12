#!/bin/sh -l
set -e
upstream_repo="$1"
branchs="$2"
git config --global --add safe.directory /github/workspace
# add upstream
git remote add upstream https://github.com/${upstream_repo}.git
git fetch upstream 
git fetch origin
if [[ $branchs = "" ]]; then
    branchs=$(git branch -r --list upstream/*|cut -d/ -f2- | grep -v 'HEAD')
else
    branchs=$(echo "$branchs" | sed 's/,/\n/g')
fi

# sync branch
for branch in ${branchs}; do
    if git ls-remote --exit-code --heads origin ${branch} &> /dev/null; then
        git checkout -b ${branch} origin/${branch} || git checkout ${branch}
        echo exists $(git branch --show-current)
        git merge upstream/${branch}
        echo merge upstream/${branch} into origin/${branch}
        git push origin ${branch} -f
    else
        git checkout -b ${branch} upstream/${branch}
        git push origin ${branch}
    fi
done

# sync tag
git fetch upstream --tags -f
git push origin --tags -f
