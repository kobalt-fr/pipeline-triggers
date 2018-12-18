#! /bin/bash

set -e

MIRROR_REPOSITORY="${1}"

if [ -z "${MIRROR_REPOSITORY}" ]; then
  echo "No repository provided as first argument. Aborting."
  exit 1
fi

# ^^*: uppercase all letters
VAR_SRC_REPO=${MIRROR_REPOSITORY^^*}_SRC_REPO
VAR_SRC_USER=${MIRROR_REPOSITORY^^*}_SRC_USER
VAR_SRC_TOKEN=${MIRROR_REPOSITORY^^*}_SRC_TOKEN

VAR_DEST_REPO=${MIRROR_REPOSITORY^^*}_DEST_REPO
VAR_DEST_USER=${MIRROR_REPOSITORY^^*}_DEST_USER
VAR_DEST_TOKEN=${MIRROR_REPOSITORY^^*}_DEST_TOKEN

SRC=${!VAR_SRC_REPO}
SRC_USER=${!VAR_SRC_USER}
SRC_TOKEN=${!VAR_SRC_TOKEN}
AUTH_SRC="${SRC}"
[[ -n "${SRC_USER}" && "${SRC}" =~ "_USER_" ]] && AUTH_SRC=${AUTH_SRC/_USER_/${SRC_USER}} && echo "$SRC: _USER_ is set"
[[ -n "${SRC_TOKEN}" && "${SRC}" =~ "_TOKEN_" ]] && AUTH_SRC=${AUTH_SRC/_TOKEN_/${SRC_TOKEN}} && echo "$SRC: _TOKEN_ is set"

DEST=${!VAR_DEST_REPO}
DEST_USER=${!VAR_DEST_USER}
DEST_TOKEN=${!VAR_DEST_TOKEN}
AUTH_DEST="${DEST}"
[[ -n "${DEST_USER}" && "${DEST}" =~ "_USER_" ]] && AUTH_DEST=${AUTH_DEST/_USER_/${DEST_USER}} && echo "$DEST: _USER_ is set"
[[ -n "${DEST_TOKEN}" && "${DEST}" =~ "_TOKEN_" ]] && AUTH_DEST=${AUTH_DEST/_TOKEN_/${DEST_TOKEN}} && echo "$DEST: _USER_ is set"

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
  $_git fetch -p origin || $_git clone --bare "${AUTH_SRC}" .
  
  echo "Fetching ${DEST}"
  $_git fetch -p dest || $_git remote add dest "${AUTH_DEST}"
  
  echo "Pushing to ${DEST}"
  $_git push dest --mirror
}
popd
