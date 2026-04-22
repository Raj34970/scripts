FROM python:3.11-slim

RUN apt update && apt install -y --no-install-recommends openssh-client git && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /project

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
