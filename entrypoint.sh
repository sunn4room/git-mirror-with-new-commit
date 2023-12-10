#!/bin/sh

error() {
  echo "::error::$*" 1>&2
  exit 1
}

test -n "$INPUT_SSH_PRIVATE_KEY" || error "ssh private key is null"
test -n "$INPUT_SOURCE_REPO" || error "source repo is null"
test -n "$INPUT_DESTINATION_REPO" || error "destination repo is null"

echo "write ssh private key"
mkdir -p ~/.ssh
echo "$INPUT_SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
echo "StrictHostKeyChecking no" > ~/.ssh/config

GIT_CLONE_SOURCE="git clone --depth 1"
test -n "$INPUT_SOURCE_BRANCH" && GIT_CLONE_SOURCE="$GIT_CLONE_SOURCE --branch $INPUT_SOURCE_BRANCH"
GIT_CLONE_SOURCE="$GIT_CLONE_SOURCE git@$INPUT_SOURCE_REPO.git $HOME/source-repo"
echo "$GIT_CLONE_SOURCE"
#$GIT_CLONE_SOURCE || error "clone source repo failed"

GIT_CLONE_DESTINATION="git clone --depth 1"
test -n "$INPUT_DESTINATION_BRANCH" && GIT_CLONE_DESTINATION="$GIT_CLONE_DESTINATION --branch $INPUT_DESTINATION_BRANCH"
GIT_CLONE_DESTINATION="$GIT_CLONE_DESTINATION git@$INPUT_DESTINATION_REPO.git $HOME/destination-repo"
echo "$GIT_CLONE_DESTINATION"
#$GIT_CLONE_DESTINATION || error "clone destination repo failed"

