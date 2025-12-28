# Installation

Deploy PuzzleTime using Docker Compose for production environments.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2
- A reverse proxy for HTTPS (Traefik, Caddy, or Nginx)
- Domain name with DNS configured

## Quick Start

```bash
# Clone the repository
git clone https://github.com/puzzle/puzzletime.git
cd puzzletime/deploy

# Run setup (generates secrets, initializes database, creates admin)
./bin/setup.sh

# Configure your reverse proxy (see below)

# Access PuzzleTime at your domain
```

## Docker Images

| Image | Description |
|-------|-------------|
| `ghcr.io/puzzle/puzzletime:latest` | Official release |
| `ghcr.io/theoweiss/puzzletime:improve-theo` | Community build (AMD64 + ARM64) |

To use an alternative image, edit `docker-compose.prod.yml`:

```yaml
services:
  web:
    image: ghcr.io/theoweiss/puzzletime:improve-theo
```

## Architecture

```
┌─────────────────┐
│  Reverse Proxy  │  ← HTTPS termination
│ (Traefik/Caddy) │
└────────┬────────┘
         │
┌────────▼────────┐
│   Rails + Puma  │  ← Web application
│    (port 3000)  │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌───▼───┐
│ Postgres│ │Memcached│
│   DB    │ │ Cache   │
└─────────┘ └─────────┘
```

## Services

The Docker Compose stack includes:

| Service | Purpose |
|---------|---------|
| `web` | Rails application with Puma |
| `jobs` | DelayedJob background worker |
| `db` | PostgreSQL database |
| `cache` | Memcached for session/cache |

## Reverse Proxy Options

PuzzleTime requires a reverse proxy for HTTPS. Choose one:

### Traefik

Add labels to `docker-compose.prod.yml`:

```yaml
services:
  web:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.puzzletime.rule=Host(`time.example.com`)"
      - "traefik.http.routers.puzzletime.tls.certresolver=letsencrypt"
```

### Caddy

Add to your `Caddyfile`:

```
time.example.com {
    reverse_proxy puzzletime-web:3000
}
```

### Nginx

```nginx
server {
    listen 443 ssl;
    server_name time.example.com;
    
    location / {
        proxy_pass http://puzzletime-web:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Direct Access (No Proxy)

For internal/homelab use without HTTPS:

```bash
# Edit .env.prod
RAILS_SESSION_SECURE=false

# Expose port directly in docker-compose.prod.yml
ports:
  - "3000:3000"
```

## Environment Variables

Key configuration in `.env.prod`:

| Variable | Description | Default |
|----------|-------------|---------|
| `DOMAIN` | Your domain name | - |
| `POSTGRES_PASSWORD` | Database password | (generated) |
| `SECRET_KEY_BASE` | Rails secret | (generated) |
| `RAILS_SERVE_STATIC_FILES` | Serve assets | `true` |
| `AUTH_DB_ACTIVE` | Enable database auth | `true` |

See [Configuration](configuration.md) for all options.

## Management Scripts

```bash
# Initial setup
./bin/setup.sh

# Deploy updates
./bin/deploy.sh

# Create admin user
./bin/create-admin.sh

# Backup database
./bin/backup-now.sh

# Restore from backup
./bin/restore.sh backup.sql.gz
```

## Building from Source

```bash
cd puzzletime
docker build -t puzzletime:local .
```

Then update `docker-compose.prod.yml` to use `puzzletime:local`.

## Next Steps

- [First Steps](first-steps.md) — Log in and record your first hours
- [Configuration](configuration.md) — Customize your installation
- [Authentication](../admin/authentication.md) — Set up LDAP or SSO

