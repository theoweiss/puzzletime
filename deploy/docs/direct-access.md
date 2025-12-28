# Direct Access (No Reverse Proxy)

This guide covers running PuzzleTime without a reverse proxy.

## When to Use Direct Access

- Internal network only (not exposed to internet)
- Homelab / development environment
- Behind corporate firewall/VPN
- Testing before setting up proper SSL

## ⚠️ Security Warning

Running without HTTPS is **not recommended for production** if:
- Users access over the internet
- Sensitive data is transmitted
- Authentication credentials are entered

For internal networks with trusted users, direct access may be acceptable.

---

## Option A: HTTP Only (Internal Use)

### 1. Update docker-compose.prod.yml

Uncomment the ports in the web service:

```yaml
services:
  web:
    # ... existing config ...
    ports:
      - "3000:3000"
```

### 2. Start PuzzleTime

```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

### 3. Access PuzzleTime

Open `http://your-server-ip:3000` in your browser.

---

## Option B: Self-Signed Certificate

For internal use with HTTPS (eliminates browser password warnings).

### 1. Generate Self-Signed Certificate

```bash
mkdir -p deploy/certs
cd deploy/certs

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout puzzletime.key \
    -out puzzletime.crt \
    -subj "/CN=puzzletime.local"
```

### 2. Create Simple Nginx Config

Create `deploy/nginx.conf`:

```nginx
events {
    worker_connections 1024;
}

http {
    upstream puzzletime {
        server web:3000;
    }

    server {
        listen 443 ssl;
        server_name _;

        ssl_certificate /etc/nginx/certs/puzzletime.crt;
        ssl_certificate_key /etc/nginx/certs/puzzletime.key;

        location / {
            proxy_pass http://puzzletime;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }

    server {
        listen 80;
        server_name _;
        return 301 https://$host$request_uri;
    }
}
```

### 3. Update docker-compose.prod.yml

Add Nginx service:

```yaml
services:
  nginx:
    image: nginx:alpine
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certs:/etc/nginx/certs:ro
    networks:
      - internal
    depends_on:
      - web

  web:
    # Remove or comment out ports section
    # ports:
    #   - "3000:3000"
```

### 4. Start Services

```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

### 5. Trust the Certificate

**On macOS:**
```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain deploy/certs/puzzletime.crt
```

**On Windows:**
1. Double-click the `.crt` file
2. Click "Install Certificate"
3. Select "Local Machine" → "Trusted Root Certification Authorities"

**On Linux:**
```bash
sudo cp deploy/certs/puzzletime.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

---

## Option C: Use Local DNS

For homelab setups, you can use local DNS to give PuzzleTime a proper hostname.

### Pi-hole / AdGuard Home

Add a local DNS record:
- Domain: `puzzletime.home`
- IP: Your server's IP

### /etc/hosts (Client Machines)

```
192.168.1.100  puzzletime.local
```

Then access via `http://puzzletime.local:3000` or `https://puzzletime.local`.

---

## Option D: Tailscale / ZeroTier

For secure access without exposing ports:

1. Install Tailscale/ZeroTier on your server
2. Access PuzzleTime via Tailscale IP: `http://100.x.x.x:3000`
3. Optionally enable Tailscale HTTPS for automatic certificates

---

## Firewall Configuration

If using direct access, ensure proper firewall rules:

### UFW (Ubuntu)

```bash
# Allow only from internal network
sudo ufw allow from 192.168.1.0/24 to any port 3000

# Or allow from anywhere (less secure)
sudo ufw allow 3000
```

### firewalld (RHEL/CentOS)

```bash
sudo firewall-cmd --add-port=3000/tcp --permanent
sudo firewall-cmd --reload
```

---

## Upgrading to Proper SSL Later

When ready to expose to the internet:

1. Get a domain name
2. Point DNS to your server
3. See [Reverse Proxy Requirements](reverse-proxy.md) and choose a solution:
   - [Traefik](../contrib/traefik.md) (community guide)
   - [Caddy](../contrib/caddy.md) (community guide)
   - [Nginx](../contrib/nginx.md) (community guide)

