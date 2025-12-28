# Caddy Integration

> **Community Contributed** — Last tested: December 2024 with Caddy v2.7
>
> For complete Caddy documentation, see [caddyserver.com/docs](https://caddyserver.com/docs)

## Prerequisites

- PuzzleTime running (see [main README](../README.md))
- Caddy installed
- Domain pointing to your server

## PuzzleTime Configuration

### Option A: Caddy on Same Docker Network

#### 1. Create Caddyfile

```caddyfile
puzzletime.example.com {
    reverse_proxy puzzletime-web:3000
}
```

#### 2. Connect PuzzleTime to Caddy Network

Update `docker-compose.prod.yml`:

```yaml
services:
  web:
    container_name: puzzletime-web
    networks:
      - internal
      - caddy_network

networks:
  internal:
  caddy_network:
    external: true
```

#### 3. Restart PuzzleTime

```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

### Option B: Caddy on Host

If Caddy runs directly on the host, expose PuzzleTime's port:

```yaml
services:
  web:
    ports:
      - "127.0.0.1:3000:3000"
```

Caddyfile:

```caddyfile
puzzletime.example.com {
    reverse_proxy localhost:3000
}
```

## New Caddy Installation

If you don't have Caddy yet, see the official install guide:
[Install Caddy](https://caddyserver.com/docs/install)

Caddy automatically provisions SSL certificates from Let's Encrypt.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| 502 Bad Gateway | Check container name matches Caddyfile |
| SSL errors | Ensure domain DNS points to server, ports 80/443 open |
| Connection refused | Verify network connectivity between Caddy and PuzzleTime |

For detailed troubleshooting, see [Caddy documentation](https://caddyserver.com/docs/).
