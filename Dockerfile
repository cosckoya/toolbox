FROM kalilinux/kali-rolling:latest

LABEL description="Toolbox" \
      maintainer="cosckoya@mail.me"

# Set the working directory
WORKDIR /root

# Install Base Packages
ENV DEBIAN_FRONTEND=noninteractive

# Update and install base packages in one RUN command to reduce image layers
RUN apt-get update -qq && \
    apt-get install -qq -y --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        lsb-release \
        gnupg \
        wget \
        curl \
        iputils-ping \
        nmap \
        unzip \
        git \
        jq \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        libncurses5-dev \
        libncursesw5-dev && \
    # Install Python with the latest version
    apt-get install -qq -y --no-install-recommends \
        python3 \
        python3-pip && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install pipx separately to avoid issues with Python version not being set up
RUN python3 -m pip install --upgrade pip && \
    pip install --no-cache-dir pipx && \
    pipx ensurepath

# Clone the asdf repository
RUN git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf

# Set environment variables for asdf
ENV PATH="/root/.asdf/bin:/root/.asdf/shims:${PATH}"

# Validate installation
RUN python3 --version && \
    pipx --version && \
    asdf --version
