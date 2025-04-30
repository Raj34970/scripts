FROM debian:12

RUN apt update -y && apt install -y wget gnupg make git gettext curl

RUN wget -qO- https://packages.sogo.nu/nightly/5/debian/sogo-nightly-archive-key.asc | gpg --dearmor -o /usr/share/keyrings/sogo-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/sogo-archive-keyring.gpg] https://packages.sogo.nu/nightly/5/debian/ bookworm bookworm" > /etc/apt/sources.list.d/sogo.list

RUN apt update -y && apt install -y \
    apt-transport-https \
    sogo \
    sope \
    mysql-client \
    nginx && \
    apt clean && rm -rf /var/lib/apt/lists/*


# Install bpkg (optional, if you still need it)
RUN curl -Lo- "https://raw.githubusercontent.com/bpkg/bpkg/master/setup.sh" | bash
RUN bpkg install cha87de/bashutil -g


# Set working directory and entrypoint
WORKDIR /opt/docker-init
ENTRYPOINT ["./entrypoint"]
