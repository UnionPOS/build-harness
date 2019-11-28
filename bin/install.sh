#!/bin/bash
export BUILD_HARNESS_ORG=${1:-unionpos}
export BUILD_HARNESS_PROJECT=${2:-build-harness}
export BUILD_HARNESS_BRANCH=${3:-master}
export BUILD_HARNESS_REPO="https://github.com/${BUILD_HARNESS_ORG}/${BUILD_HARNESS_PROJECT}.git"

if [ "$BUILD_HARNESS_PROJECT" ] && [ -d "$BUILD_HARNESS_PROJECT" ]; then
  echo "Removing existing $BUILD_HARNESS_PROJECT"
  rm -rf "$BUILD_HARNESS_PROJECT"
fi

echo "Cloning ${BUILD_HARNESS_REPO}#${BUILD_HARNESS_BRANCH}..."
git clone -b "$BUILD_HARNESS_BRANCH" "$BUILD_HARNESS_REPO"

# export BASH_COMMONS_ORG=${4:-unionpos}
# export BASH_COMMONS_PROJECT=${5:-bash-commons}
# export BASH_COMMONS_BRANCH=${6:-master}
# export BASH_COMMONS_REPO="https://github.com/${BASH_COMMONS_ORG}/${BASH_COMMONS_PROJECT}.git"

# (
#   cd "$BUILD_HARNESS_PROJECT" || exit
#   echo "Adding $BASH_COMMONS_PROJECT as subtree..."
#   git subtree add --prefix "$BASH_COMMONS_PROJECT" "$BASH_COMMONS_REPO" "$BASH_COMMONS_BRANCH" --squash
# )
