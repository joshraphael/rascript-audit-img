#!/bin/sh

export RATOOLS_DIR=${HOME}/Installs/RATools-${RATOOLS_VERSION}
export RALIBRETRO_DIR=${HOME}/Installs/RALibretro-x64

echo $RATOOLS_DIR
mkdir -p ${RATOOLS_DIR}
mkdir -p ${RALIBRETRO_DIR}/RACache/Data

mv ${APP_DIR}/go.mod ${HOME}
mv ${APP_DIR}/go.sum ${HOME}
mv ${APP_DIR}/main.go ${HOME}
mv ${APP_DIR}/RATools-${RATOOLS_VERSION}.zip ${HOME}
mv ${APP_DIR}/18190.rascript ${HOME}
touch ${RALIBRETRO_DIR}/RACache/Data/${GAME_ID}.json

unzip ${HOME}/RATools-${RATOOLS_VERSION}.zip -d ${RATOOLS_DIR}
rm ${HOME}/RATools-${RATOOLS_VERSION}.zip
# cd $HOME && go get -t ./... && go run main.go > ${RALIBRETRO_DIR}/RACache/Data/${GAME_ID}-Notes.json
# wine ${RATOOLS_DIR}/rascript-cli.exe -i ${HOME}/18190.rascript -o ${RALIBRETRO_DIR}