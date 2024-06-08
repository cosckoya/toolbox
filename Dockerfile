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
        jq && \
    # Install Python with specified version
    apt-get install -qq -y --no-install-recommends \
        python3.11 \
        python3-pip && \
    ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install pipx separately to avoid issues with Python version not being set up
RUN pip3 install --no-cache-dir pipx && \
    pipx ensurepath

# Clone the asdf repository
RUN git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf

# Set environment variables for asdf
ENV PATH="/root/.asdf/bin:/root/.asdf/shims:${PATH}"

# Validate installation
RUN python3 --version && pipx --version && asdf --version
