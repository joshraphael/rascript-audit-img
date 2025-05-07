#!/bin/sh

if [ -z "${CONTAINER_HOME}" ]; then
  echo "CONTAINER_HOME env var is not set"
  exit 1
fi

export RATOOLS_DIR=${CONTAINER_HOME}/Installs/RATools-${RATOOLS_VERSION}
export RALIBRETRO_DIR=${CONTAINER_HOME}/Installs/RALibretro-x64
export RA_DATA_DIR=${RALIBRETRO_DIR}/RACache/Data
export CODENOTES_DIR=${CONTAINER_HOME}/rascript-audit-codenotes

echo $RATOOLS_DIR
mkdir -p ${RATOOLS_DIR}
mkdir -p ${RA_DATA_DIR}
mkdir -p ${CODENOTES_DIR}

mv ${APP_DIR}/go.mod ${CODENOTES_DIR}
mv ${APP_DIR}/go.sum ${CODENOTES_DIR}
mv ${APP_DIR}/main.go ${CODENOTES_DIR}
mv ${APP_DIR}/autocr-cli-${AUTOCRCLI_VERSION}.zip ${CONTAINER_HOME}
mv ${APP_DIR}/RATools-${RATOOLS_VERSION}.zip ${CONTAINER_HOME}
# mv ${APP_DIR}/${GAME_ID}.rascript ${HOME}
touch ${RA_DATA_DIR}/${GAME_ID}.json

unzip ${CONTAINER_HOME}/autocr-cli-${AUTOCRCLI_VERSION}.zip -d ${CONTAINER_HOME}
rm ${CONTAINER_HOME}/autocr-cli-${AUTOCRCLI_VERSION}.zip

unzip ${CONTAINER_HOME}/RATools-${RATOOLS_VERSION}.zip -d ${RATOOLS_DIR}
rm ${CONTAINER_HOME}/RATools-${RATOOLS_VERSION}.zip
cd ${CODENOTES_DIR} && go get -t ./... && go run main.go > ${RA_DATA_DIR}/${GAME_ID}-Notes.json
# wine ${RATOOLS_DIR}/rascript-cli.exe -i ${HOME}/${GAME_ID}.rascript -o ${RALIBRETRO_DIR}
# node ${HOME}/autocr-cli-${AUTOCRCLI_VERSION}/index.js --notes ${RA_DATA_DIR}/${GAME_ID}-Notes.json --user ${RA_DATA_DIR}/${GAME_ID}-User.txt --rich ${RA_DATA_DIR}/${GAME_ID}-Rich.txt --report