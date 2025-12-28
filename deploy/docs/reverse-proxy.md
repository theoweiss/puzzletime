# Reverse Proxy Requirements

This document describes what any reverse proxy needs to provide for PuzzleTime.

## Why Use a Reverse Proxy?

- **HTTPS/SSL** — Encrypt traffic between users and PuzzleTime
- **Domain routing** — Serve PuzzleTime on a custom domain
- **Security** — Hide internal ports, add security headers
- **Load balancing** — Scale horizontally (if needed)

## Requirements

Any reverse proxy must:

### 1. Forward to Port 3000

PuzzleTime listens on port 3000 inside its container.

```
[Internet] → [Reverse Proxy :443] → [PuzzleTime :3000]
```

### 2. Set Proxy Headers

These headers are required for PuzzleTime to know the real client IP and protocol:

| Header | Value |
|--------|-------|
| `Host` | Original host header |
| `X-Real-IP` | Client's real IP address |
| `X-Forwarded-For` | Client IP (may include proxy chain) |
| `X-Forwarded-Proto` | `https` (for SSL termination) |

### 3. Handle SSL/TLS

Terminate SSL at the reverse proxy. PuzzleTime expects unencrypted traffic internally.

### 4. Network Connectivity

The reverse proxy must be able to reach PuzzleTime's container. Options:

- **Same Docker network** — Add both to a shared Docker network
- **Host networking** — Expose PuzzleTime's port to the host
- **Docker socket** — Some proxies (like Traefik) discover containers automatically

## Example Configuration

Here's a generic example of what the proxy config should achieve:

```
# Pseudocode - adapt to your proxy

listen 443 ssl
server_name puzzletime.example.com

ssl_certificate /path/to/cert
ssl_certificate_key /path/to/key

proxy_pass http://puzzletime-container:3000
proxy_set_header Host $host
proxy_set_header X-Real-IP $client_ip
proxy_set_header X-Forwarded-For $client_ip
proxy_set_header X-Forwarded-Proto https
```

## Docker Compose Network Setup

To connect PuzzleTime to an external reverse proxy network:

```yaml
# In docker-compose.prod.yml

services:
  web:
    networks:
      - internal
      - proxy_network  # Your reverse proxy's network

networks:
  internal:
  proxy_network:
    external: true
```

## Community Guides

For specific reverse proxy implementations, see the community-contributed guides:

- [Traefik](../contrib/traefik.md)
- [Caddy](../contrib/caddy.md)
- [Nginx](../contrib/nginx.md)

> **Note:** These guides are community-contributed and may not be actively maintained.
> Always check the official documentation for your chosen reverse proxy.

## No Reverse Proxy

For internal/homelab deployments where a reverse proxy isn't needed:

- [Direct Access Guide](direct-access.md) — HTTP-only or self-signed certificates

