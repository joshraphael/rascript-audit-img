FROM node:20

# Variables
ENV GOLANG_VERSION=1.24.2
ENV RATOOLS_VERSION=v1.15.1
ENV AUTOCRCLI_VERSION=1.2.2

# CONSTANTS
ENV APP_DIR=/app

RUN mkdir -p ${APP_DIR}

# Only copy the bash and go script to get code notes
COPY go.mod ${APP_DIR}
COPY go.sum ${APP_DIR}
COPY main.go ${APP_DIR}
COPY scripts/entry.sh ${APP_DIR}
COPY scripts/copy.sh ${APP_DIR}

# Install Node
RUN apt update
RUN apt install -y wget unzip

# Install Golang
RUN wget https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz -O ${APP_DIR}/go.tar.gz
RUN tar -xzvf ${APP_DIR}/go.tar.gz -C /usr/local
ENV PATH=/usr/local/go/bin:${PATH}

# Get AutoCR CLI
RUN wget -O ${APP_DIR}/autocr-cli-${AUTOCRCLI_VERSION}.zip "https://github.com/joshraphael/autocr-cli/archive/refs/tags/v${AUTOCRCLI_VERSION}.zip"
RUN unzip ${APP_DIR}/autocr-cli-${AUTOCRCLI_VERSION}.zip -d ${APP_DIR}/autocr-cli-${AUTOCRCLI_VERSION}
RUN rm -rf ${APP_DIR}/autocr-cli-${AUTOCRCLI_VERSION}.zip

# Get RAScript CLI v1.15.1
RUN wget -O ${APP_DIR}/rascript-cli_v1.15.1_linux-x64.zip "https://github.com/joshraphael/rascript-cli/releases/download/v1.15.1/rascript-cli_v1.15.1_linux-x64.zip"
RUN unzip ${APP_DIR}/rascript-cli_v1.15.1_linux-x64.zip -d ${APP_DIR}
RUN rm -rf ${APP_DIR}/rascript-cli_v1.15.1_linux-x64.zip

# Cleanup
RUN rm -f ${APP_DIR}/go.tar.gz
RUN apt purge -y wget

RUN chmod -R 777 /app