# Nginx Integration

> **Community Contributed** — Last tested: December 2024 with Nginx 1.25
>
> For complete Nginx documentation, see [nginx.org/en/docs](https://nginx.org/en/docs/)

## Prerequisites

- PuzzleTime running (see [main README](../README.md))
- Nginx installed
- SSL certificate (via Let's Encrypt/certbot or other CA)

## PuzzleTime Configuration

### 1. Nginx Server Block

```nginx
upstream puzzletime {
    server puzzletime-web:3000;  # Or localhost:3000 if on host
}

server {
    listen 80;
    server_name puzzletime.example.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name puzzletime.example.com;

    ssl_certificate /etc/letsencrypt/live/puzzletime.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/puzzletime.example.com/privkey.pem;

    location / {
        proxy_pass http://puzzletime;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 2. Connect Networks (Docker Nginx)

If Nginx runs in Docker:

```yaml
# PuzzleTime docker-compose.prod.yml
services:
  web:
    container_name: puzzletime-web
    networks:
      - internal
      - nginx_network

networks:
  internal:
  nginx_network:
    external: true
```

### 3. Expose Port (Host Nginx)

If Nginx runs on the host:

```yaml
services:
  web:
    ports:
      - "127.0.0.1:3000:3000"
```

## SSL with Let's Encrypt

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d puzzletime.example.com
```

For other install methods, see [certbot.eff.org](https://certbot.eff.org/).

## Troubleshooting

| Issue | Solution |
|-------|----------|
| 502 Bad Gateway | Check upstream server is reachable |
| SSL errors | Verify certificate paths, run `nginx -t` |
| Permission denied | Check Nginx can read certificate files |

For detailed troubleshooting, see [Nginx documentation](https://nginx.org/en/docs/).
