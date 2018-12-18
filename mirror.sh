#! /bin/bash

set -e

VAR_SRC_REPO=${MIRROR_REPOSITORY}_SRC_REPO
VAR_DEST_REPO=${MIRROR_REPOSITORY}_DEST_REPO

SRC=${!VAR_SRC_REPO}
DEST=${!VAR_DEST_REPO}

if [ -z "${VAR_SRC_REPO}" -o -z "${VAR_DEST_REPO}" ]; then
  echo "${MIRROR_REPOSITORY}_SRC_REPO or ${MIRROR_REPOSITORY}_DEST_REPO is not set. Aborting."
  exit 1;
fi

git fetch -p src || git clone -o src --bare "${SRC}"
git fetch -p dest || git remote add dest "${DEST}"
git push dest --mirror
