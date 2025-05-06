FROM node:20-alpine

# Variables
ENV GOLANG_VERSION=1.24.2
ENV RATOOLS_VERSION=v1.15.1
ENV GAME_ID=4111

# CONSTANTS
ENV DOTNET_DIR=C:\\Programs\\dotnet
ENV APP_DIR=/app
ENV WINEPREFIX=${APP_DIR}/.wine
# ENV RATOOLS_DIR=${APP_DIR}/Installs/RATools-${RATOOLS}
# ENV RALIBRETRO_DIR=${APP_DIR}/Installs/RALibretro-x64
ENV DOTNET_ROOT_X64=${DOTNET_DIR}
ENV DOTNET_ROOT=${DOTNET_DIR}
ENV WINEPATH=${DOTNET_DIR}
ENV INSTALL_DIR=${WINEPREFIX}/drive_c/Programs/dotnet

RUN mkdir -p ${APP_DIR}

# Only copy the go script to get code notes
COPY go.mod ${APP_DIR}
COPY go.sum ${APP_DIR}
COPY main.go ${APP_DIR}
COPY entry.sh ${APP_DIR}

# Install Node
RUN apk update
RUN apk add wget wine unzip

# Install Golang
RUN wget https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz -O ${APP_DIR}/go.tar.gz
RUN tar -xzvf ${APP_DIR}/go.tar.gz -C /usr/local
ENV PATH=/usr/local/go/bin:${PATH}
# RUN mkdir -p ${RATOOLS_DIR} && mkdir -p ${RALIBRETRO_DIR}/RACache/Data

# Config Wine
RUN winecfg /v win10

# Get RATools
RUN wget -O ${APP_DIR}/RATools-${RATOOLS_VERSION}.zip "https://github.com/Jamiras/RATools/releases/download/${RATOOLS_VERSION}/RATools-${RATOOLS_VERSION}.zip"
# RUN wget -O ${RATOOLS_DIR}/RATools-${RATOOLS_VERSION}.zip "https://github.com/Jamiras/RATools/releases/download/${RATOOLS_VERSION}/RATools-${RATOOLS_VERSION}.zip"
# RUN unzip ${RATOOLS_DIR}/RATools-${RATOOLS_VERSION}.zip -d ${RATOOLS_DIR}

# Get .NET SDK
RUN mkdir -p ${INSTALL_DIR}
RUN wget -O "${INSTALL_DIR}/dotnet-sdk.zip" "https://download.visualstudio.microsoft.com/download/pr/5b2c6cee-abe2-4734-a099-729a346205e7/b5776361ebee2e1eeed9be4aad944652/dotnet-sdk-6.0.428-win-x64.zip"
RUN unzip "${INSTALL_DIR}/dotnet-sdk.zip" -d "${INSTALL_DIR}"

# Cleanup
RUN rm ${APP_DIR}/go.tar.gz
# RUN rm ${RATOOLS_DIR}/RATools-${RATOOLS_VERSION}.zip
RUN rm ${INSTALL_DIR}/dotnet-sdk.zip
RUN apk del --purge wget unzip
# RUN cd $HOME && go get -t ./... && go run main.go > ${RALIBRETRO_DIR}/RACache/Data/${GAME_ID}-Notes.json