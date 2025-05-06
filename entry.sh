#!/bin/sh

export RATOOLS_DIR=${HOME}/Installs/RATools-${RATOOLS_VERSION}
export RALIBRETRO_DIR=${HOME}/Installs/RALibretro-x64
export RA_DATA_DIR=${RALIBRETRO_DIR}/RACache/Data
export CODENOTES_DIR=${HOME}/rascript-audit-codenotes

echo $RATOOLS_DIR
mkdir -p ${RATOOLS_DIR}
mkdir -p ${RA_DATA_DIR}
mkdir -p ${CODENOTES_DIR}

mv ${APP_DIR}/go.mod ${CODENOTES_DIR}
mv ${APP_DIR}/go.sum ${CODENOTES_DIR}
mv ${APP_DIR}/main.go ${CODENOTES_DIR}
mv ${APP_DIR}/autocr-cli-${AUTOCRCLI_VERSION}.zip ${HOME}
mv ${APP_DIR}/RATools-${RATOOLS_VERSION}.zip ${HOME}
# mv ${APP_DIR}/${GAME_ID}.rascript ${HOME}
touch ${RA_DATA_DIR}/${GAME_ID}.json

unzip ${HOME}/autocr-cli-${AUTOCRCLI_VERSION}.zip -d ${HOME}
rm ${HOME}/autocr-cli-${AUTOCRCLI_VERSION}.zip

unzip ${HOME}/RATools-${RATOOLS_VERSION}.zip -d ${RATOOLS_DIR}
rm ${HOME}/RATools-${RATOOLS_VERSION}.zip
cd ${CODENOTES_DIR} && go get -t ./... && go run main.go > ${RA_DATA_DIR}/${GAME_ID}-Notes.json
# wine ${RATOOLS_DIR}/rascript-cli.exe -i ${HOME}/${GAME_ID}.rascript -o ${RALIBRETRO_DIR}
# node ${HOME}/autocr-cli-${AUTOCRCLI_VERSION}/index.js --notes ${RA_DATA_DIR}/${GAME_ID}-Notes.json --user ${RA_DATA_DIR}/${GAME_ID}-User.txt --rich ${RA_DATA_DIR}/${GAME_ID}-Rich.txt --report