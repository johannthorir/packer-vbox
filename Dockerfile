FROM ubuntu:18.04

LABEL maintainer="johann.thorir.johannsson@gmail.com"

# Requisits.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    lsb-release \
    module-init-tools \
    openssh-client \
    gnupg2 \
    unzip \
    curl \
    jq \
    wget

# Virtualbox
RUN echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" >> /etc/apt/sources.list.d/virtualbox.list
RUN wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
RUN apt-get update && apt-get install -y --no-install-recommends virtualbox-6.1
RUN apt-get -y clean

# Packer

RUN PACKER_VERSION=`wget -O- https://releases.hashicorp.com/packer/ 2> /dev/null \
      | fgrep '/packer' \
      | head -1 \
      | sed -r 's/.*packer_([0-9.]+).*/\1/'` && \
    wget -O /root/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    cd /root && \
    unzip packer.zip && \
    chmod +x packer && \
    mv packer /usr/local/bin && \
    rm packer.zip

# Setup the directory
ENV BUILD_DIR="/build"
RUN test ! -f "${BUILD_DIR}" -a ! -d "${BUILD_DIR}" && mkdir -p "${BUILD_DIR}"

# Working
WORKDIR "${BUILD_DIR}"

