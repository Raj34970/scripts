services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    ports:
     - 9445:80
    volumes:
     - ./bitwarden:/data:rw
    environment:
     - ADMIN_TOKEN=v/v7jAgzndj262AyyT+kQcgEUIb9VcZUzIoHESayUqP/umrbbsPAuQGYgWn2JmiK
     - WEBSOCKET_ENABLED=true
     - SIGNUPS_ALLOWED=true
     - SMTP_HOST=smtp.lxhome.fr
     - SMTP_FROM=info@lxhome.fr
     - SMTP_PORT=22
     - SMTP_SECURITY=off
     - SMTP_TIMEOUT=15
     - SMTP_USERNAME=info@lxhome.fr
     - SMTP_PASSWORD=Vaultwarden2024@%
     - DOMAIN=https://vaultwarden.lxhome.fr