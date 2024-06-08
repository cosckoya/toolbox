FROM kalilinux/kali-rolling:latest

LABEL description = "Toolbox"
LABEL maintainer = "cosckoya@mail.me"

# Set the working directory
WORKDIR /root

# Install Base Packages
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq \
  && apt-get install -qq -y --no-install-recommends \
    ca-certificates apt-transport-https lsb-release gnupg \
    wget curl iputils-ping nmap unzip git jq

# Set Python version as an argument
ARG PYTHON_VERSION=3.11

# Install Python with specified version
RUN apt  install -y python${PYTHON_VERSION} pipx \
  && ln -sf /usr/bin/python3.11 /usr/bin/python3 \
  && pipx ensurepath

RUN git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf

# Cleanup
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/*
