#! /bin/bash

set -e

VAR_SRC_REPO=${MIRROR_REPOSITORY}_SRC_REPO
VAR_DEST_REPO=${MIRROR_REPOSITORY}_DEST_REPO

SRC=${!VAR_SRC_REPO}
DEST=${!VAR_DEST_REPO}

if [ -z "${SRC}" -o -z "${DEST}" ]; then
  echo "${VAR_SRC_REPO} or ${VAR_DEST_REPO} is not set. Aborting."
  exit 1;
fi

echo "Mirroring ${SRC} > ${DEST}"

echo "Fetching ${SRC}"
git fetch -p origin || git clone --bare "${SRC}"

echo "Fetching ${DEST}"
git fetch -p dest || git remote add dest "${DEST}"

echo "Pushing to ${DEST}"
git push dest --mirror
