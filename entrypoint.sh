#!/bin/sh

error() {
  echo "::error::$*" 1>&2
  exit 1
}

set_key() {
  echo "$1" > /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa
}

test -n "$INPUT_SOURCE_REPO" || error "source repo is null"
test -n "$INPUT_DESTINATION_REPO" || error "destination repo is null"
test -n "$INPUT_DESTINATION_KEY" || error "destination repo ssh private key is null"
test -n "$INPUT_GIT_USER_NAME" || error "git user name is null"
test -n "$INPUT_GIT_USER_EMAIL" || error "git user email is null"

mkdir -p /root/.ssh
echo "StrictHostKeyChecking no" > /etc/ssh/ssh_config

test -n "$INPUT_SOURCE_KEY" && set_key "$INPUT_SOURCE_KEY"
GIT_CLONE_SOURCE="git clone --depth 1"
test -n "$INPUT_SOURCE_BRANCH" && GIT_CLONE_SOURCE="$GIT_CLONE_SOURCE --branch $INPUT_SOURCE_BRANCH"
GIT_CLONE_SOURCE="$GIT_CLONE_SOURCE $INPUT_SOURCE_REPO $HOME/source-repo"
echo "$GIT_CLONE_SOURCE"
$GIT_CLONE_SOURCE >/dev/null 2>&1 || error "clone source repo failed"

set_key "$INPUT_DESTINATION_KEY"
GIT_CLONE_DESTINATION="git clone --depth 1"
test -n "$INPUT_DESTINATION_BRANCH" && GIT_CLONE_DESTINATION="$GIT_CLONE_DESTINATION --branch $INPUT_DESTINATION_BRANCH"
GIT_CLONE_DESTINATION="$GIT_CLONE_DESTINATION $INPUT_DESTINATION_REPO $HOME/destination-repo"
echo "$GIT_CLONE_DESTINATION"
$GIT_CLONE_DESTINATION >/dev/null 2>&1 || error "clone destination repo failed"

rm -rf ~/source-repo/.git
cp -r ~/destination-repo/.git ~/source-repo/.git
cd ~/source-repo
if test "$(git status -s | wc -l)" -eq "0"; then
  echo "there is no change"
  exit 0
fi
git config --global user.name "$INPUT_GIT_USER_NAME"
git config --global user.email "$INPUT_GIT_USER_EMAIL"
git add --all >/dev/null 2>&1 || error "git add failed"
git commit -m "$(date)" >/dev/null 2>&1 || error "git commit failed"
git push >/dev/null 2>&1 || error "git push failed"
