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
        git push origin ${branch}
    else
        git checkout -b ${branch} upstream/${branch}
        git push origin ${branch}
    fi
done

# sync tag
upstream_tags=$(git ls-remote --tags upstream|cut -d -f3-)
origin_tags=$(git ls-remote --tags origin|cut -d -f3-|tr '\n' ',')

for tag in ${upstream_tags}; do
    if [[ ${origin_tags} = *"${tag}"* ]]; then
        echo exists tag ${tag}
    else
        git fetch upstream tags/${tag}
        git tag ${tag}
        git push origin ${tag}
    fi
done
