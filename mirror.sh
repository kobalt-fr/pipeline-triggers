#! /bin/bash

set -e

MIRROR_REPOSITORY="${1}"

if [ -z "${MIRROR_REPOSITORY}" ]; then
  echo "No repository provided as first argument. Aborting."
  exit 1
fi

# ^^*: uppercase all letters
VAR_SRC_REPO=${MIRROR_REPOSITORY^^*}_SRC_REPO
VAR_DEST_REPO=${MIRROR_REPOSITORY^^*}_DEST_REPO

SRC=${!VAR_SRC_REPO}
DEST=${!VAR_DEST_REPO}

if [ -z "${SRC}" -o -z "${DEST}" ]; then
  echo "${VAR_SRC_REPO} or ${VAR_DEST_REPO} is not set. Aborting."
  exit 1
fi

mkdir -p "${MIRROR_REPOSITORY}"

echo "Mirroring ${SRC} > ${DEST} in ${MIRROR_REPOSITORY}"

# as script is run inside a git repo, we need to enforce
# git-dir value
_git="git --git-dir ."

pushd "${MIRROR_REPOSITORY}"
{
  echo "Fetching ${SRC}"
  $_git fetch -p origin || $_git clone --bare "${SRC}" .
  
  echo "Fetching ${DEST}"
  $_git fetch -p dest || $_git remote add dest "${DEST}"
  
  echo "Pushing to ${DEST}"
  $_git push dest --mirror
}
popd
