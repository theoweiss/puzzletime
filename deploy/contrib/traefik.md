# Traefik Integration

> **Community Contributed** — Last tested: December 2024 with Traefik v3.0
>
> For complete Traefik documentation, see [doc.traefik.io](https://doc.traefik.io)

## Prerequisites

- PuzzleTime running (see [main README](../README.md))
- Traefik installed with Docker provider enabled
- Let's Encrypt resolver configured (typically named `letsencrypt`)

## PuzzleTime Configuration

### 1. Add Traefik Labels

Update `docker-compose.prod.yml`, uncomment and configure the labels on the `web` service:

```yaml
services:
  web:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.puzzletime.rule=Host(`puzzletime.example.com`)"
      - "traefik.http.routers.puzzletime.entrypoints=websecure"
      - "traefik.http.routers.puzzletime.tls.certresolver=letsencrypt"
      - "traefik.http.services.puzzletime.loadbalancer.server.port=3000"
      - "traefik.docker.network=traefik_network"
    networks:
      - internal
      - traefik_network
```

### 2. Connect to Traefik Network

Add the external network:

```yaml
networks:
  internal:
  traefik_network:
    external: true
```

### 3. Restart PuzzleTime

```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

Traefik will automatically discover PuzzleTime and provision SSL.

## New Traefik Installation

If you don't have Traefik yet, see the official getting started guide:
[Traefik Docker Quick Start](https://doc.traefik.io/traefik/getting-started/quick-start/)

Basic Traefik setup requires:
1. Docker Compose file with Traefik service
2. Let's Encrypt configuration
3. Docker socket access for container discovery

## Troubleshooting

| Issue | Solution |
|-------|----------|
| 502 Bad Gateway | Check PuzzleTime is running, verify network connectivity |
| No SSL certificate | Ensure port 80 is accessible for HTTP challenge |
| Service not discovered | Verify `traefik.enable=true` label and shared network |
| Wrong network | Check `traefik.docker.network` matches your setup |

For detailed troubleshooting, see [Traefik documentation](https://doc.traefik.io/traefik/).
