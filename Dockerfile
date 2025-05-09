FROM node:20

# Variables
ENV GOLANG_VERSION=1.24.2
ENV RATOOLS_VERSION=v1.15.1
ENV AUTOCRCLI_VERSION=1.2.2

# CONSTANTS
ENV DOTNET_DIR=C:\\Programs\\dotnet
ENV WINEARCH=win64
ENV APP_DIR=/app
ENV WINEPREFIX=${APP_DIR}/.wine64
ENV DOTNET_ROOT_X64=${DOTNET_DIR}
ENV DOTNET_ROOT=${DOTNET_DIR}
ENV WINEPATH=${DOTNET_DIR}
ENV INSTALL_DIR=${WINEPREFIX}/drive_c/Programs/dotnet

RUN mkdir -p ${APP_DIR}

# Only copy the bash and go script to get code notes
COPY go.mod ${APP_DIR}
COPY go.sum ${APP_DIR}
COPY main.go ${APP_DIR}
COPY scripts/entry.sh ${APP_DIR}
COPY scripts/copy.sh ${APP_DIR}

# Install Node
RUN apt update
RUN apt install -y wine wget unzip

# Install Golang
RUN wget https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz -O ${APP_DIR}/go.tar.gz
RUN tar -xzvf ${APP_DIR}/go.tar.gz -C /usr/local
ENV PATH=/usr/local/go/bin:${PATH}

# Config Wine
RUN winecfg /v win10

# Get AutoCR CLI
RUN wget -O ${APP_DIR}/autocr-cli-${AUTOCRCLI_VERSION}.zip "https://github.com/joshraphael/autocr-cli/archive/refs/tags/v${AUTOCRCLI_VERSION}.zip"

# Get RATools
RUN wget -O ${APP_DIR}/RATools-${RATOOLS_VERSION}.zip "https://github.com/Jamiras/RATools/releases/download/${RATOOLS_VERSION}/RATools-${RATOOLS_VERSION}.zip"

# Get .NET SDK
RUN mkdir -p ${INSTALL_DIR}
RUN wget -O "${INSTALL_DIR}/dotnet-sdk.zip" "https://download.visualstudio.microsoft.com/download/pr/5b2c6cee-abe2-4734-a099-729a346205e7/b5776361ebee2e1eeed9be4aad944652/dotnet-sdk-6.0.428-win-x64.zip"
RUN unzip "${INSTALL_DIR}/dotnet-sdk.zip" -d "${INSTALL_DIR}"

# Cleanup
RUN rm ${APP_DIR}/go.tar.gz
RUN rm ${INSTALL_DIR}/dotnet-sdk.zip
RUN apt purge -y wget

RUN chmod -R 777 /app

ENTRYPOINT ["/app/entry.sh"]