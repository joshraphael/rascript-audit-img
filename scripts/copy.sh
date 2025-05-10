#!/bin/bash

CONTAINER_HOME_FILE="container_home/home.txt"

if [ ! -f $CONTAINER_HOME_FILE ]; then
   echo "File $CONTAINER_HOME_FILE does not exist."
   exit 1
fi

if [ -z "${GAME_ID}" ]; then
  echo "GAME_ID env var is not set"
  exit 1
fi

if [ -z "${REPORT}" ]; then
  echo "REPORT env var is not set"
  exit 1
fi

REPORT_STR=""
true=("true" "TRUE" "True")
if [[ ${true[@]} =~ ${REPORT} ]]; then
  REPORT_STR="true"
fi

export CONTAINER_HOME=$(cat $CONTAINER_HOME_FILE)

docker cp rascript-audit-img:${CONTAINER_HOME}/Installs/RALibretro-x64/RACache/Data/${GAME_ID}-Notes.json container_home/
docker cp rascript-audit-img:${CONTAINER_HOME}/Installs/RALibretro-x64/RACache/Data/${GAME_ID}-User.txt container_home/
docker cp rascript-audit-img:${CONTAINER_HOME}/Installs/RALibretro-x64/RACache/Data/${GAME_ID}-Rich.txt container_home/
if [ ! -z "${REPORT_STR}" ]; then
  docker cp rascript-audit-img:${CONTAINER_HOME}/Installs/RALibretro-x64/RACache/Data/${GAME_ID}-Report.txt container_home/
fi