#!/bin/bash

set -xe

echo "-----------------------------------------------------------"
echo "Processing $GITHUB_EVENT_PATH"
echo "-----------------------------------------------------------"

echo "### Printing $GITHUB_EVENT_PATH"
jq . "$GITHUB_EVENT_PATH"

echo "### Making sure this is a pull request by looking for the PR URL"
(jq -r ".pull_request.issue.href" "$GITHUB_EVENT_PATH") || exit 78

echo "### Getting head branch"
HEAD_BRANCH=$(jq -r .pull_request.head.ref "$GITHUB_EVENT_PATH")

echo "### Getting base branch"
BASE_BRANCH=$(jq -r .pull_request.base.ref "$GITHUB_EVENT_PATH")

echo "### HEAD_BRANCH = ${HEAD_BRANCH}"
echo "### BASE_BRANCH = ${BASE_BRANCH}"

echo "### Merging Pull Request"
git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@${GITHUB_HOST:-github.com}/${GITHUB_REPOSITORY}.git
git config --global user.email "actions@github.com"
git config --global user.name "GitHub Merge Action"

set -o xtrace

git fetch origin $BASE_BRANCH

# do the merge
git checkout -b $BASE_BRANCH origin/$BASE_BRANCH
git merge origin/$HEAD_BRANCH --no-edit
git push origin $BASE_BRANCH
