#!/bin/bash

if [ -z "${GAME_ID}" ]; then
  echo "GAME_ID env var is not set"
  exit 1
fi

if [ -z "${RASCRIPT_FILE}" ]; then
  echo "RASCRIPT_FILE env var is not set"
  exit 1
fi

if [ -z "${REPORT}" ]; then
  echo "REPORT env var is not set"
  exit 1
fi

SEVERITY_TXT=""
levels=("info" "warn" "error")
if [ ! -z "${SEVERITY}" ]; then
  if [[ ${levels[@]} =~ ${SEVERITY} ]]; then
    SEVERITY_TXT=" --severity ${SEVERITY}"
  fi
fi

REPORT_STR=""
true=("true" "TRUE" "True")
if [[ ${true[@]} =~ ${REPORT} ]]; then
  REPORT_STR=" --report"
fi

export INSTALLS_DIR=${HOME}/Installs
export RATOOLS_DIR=${INSTALLS_DIR}/RATools-${RATOOLS_VERSION}
export RALIBRETRO_DIR=${INSTALLS_DIR}/RALibretro-x64
export RA_DATA_DIR=${RALIBRETRO_DIR}/RACache/Data
export CODENOTES_DIR=${HOME}/rascript-audit-codenotes

echo $RATOOLS_DIR
mkdir -p ${RATOOLS_DIR}
mkdir -p ${RA_DATA_DIR}
mkdir -p ${CODENOTES_DIR}
mkdir -p /app/rascript

mv ${APP_DIR}/go.mod ${CODENOTES_DIR}
mv ${APP_DIR}/go.sum ${CODENOTES_DIR}
mv ${APP_DIR}/main.go ${CODENOTES_DIR}
mv ${APP_DIR}/autocr-cli-${AUTOCRCLI_VERSION}/autocr-cli-${AUTOCRCLI_VERSION} ${INSTALLS_DIR}
mv ${APP_DIR}/RATools-${RATOOLS_VERSION} ${INSTALLS_DIR}
touch ${RA_DATA_DIR}/${GAME_ID}.json
rm -rf mv ${APP_DIR}/autocr-cli-${AUTOCRCLI_VERSION}
rm -rf ${APP_DIR}/RATools-${RATOOLS_VERSION}

cd ${CODENOTES_DIR} && go get -t ./... && go run main.go > ${RA_DATA_DIR}/${GAME_ID}-Notes.json
cp "/app/rascript/${RASCRIPT_FILE}" ${HOME}/${GAME_ID}.rascript
echo ${HOME} > /app/home.txt
wine ${RATOOLS_DIR}/rascript-cli.exe -i ${HOME}/${GAME_ID}.rascript -o ${RALIBRETRO_DIR}
set -o pipefail
node ${INSTALLS_DIR}/autocr-cli-${AUTOCRCLI_VERSION}/index.js --notes ${RA_DATA_DIR}/${GAME_ID}-Notes.json --user ${RA_DATA_DIR}/${GAME_ID}-User.txt --rich ${RA_DATA_DIR}/${GAME_ID}-Rich.txt${REPORT_STR}${SEVERITY_TXT} | tee ${RA_DATA_DIR}/${GAME_ID}-Report.txt
exit $?