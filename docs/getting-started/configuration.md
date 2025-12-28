# Configuration

Configure PuzzleTime through environment variables in `.env.prod`.

## Core Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `DOMAIN` | Your domain name | (required) |
| `SECRET_KEY_BASE` | Rails secret key | (generated) |
| `RAILS_ENV` | Environment | `production` |
| `RAILS_LOG_TO_STDOUT` | Log to console | `true` |
| `RAILS_SERVE_STATIC_FILES` | Serve assets | `true` |

## Database

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_USER` | Database user | `puzzletime` |
| `POSTGRES_PASSWORD` | Database password | (generated) |
| `POSTGRES_DB` | Database name | `puzzletime_production` |
| `RAILS_DB_HOST` | Database host | `db` |

## Authentication

PuzzleTime supports multiple authentication methods. See [Authentication](../admin/authentication.md) for details.

### Database Authentication

```bash
AUTH_DB_ACTIVE=true
```

### LDAP

```bash
AUTH_DB_ACTIVE=false
LDAP_HOST=ldap.example.com
LDAP_PORT=636
LDAP_ENCRYPTION=simple_tls
LDAP_BASE_DN=ou=users,dc=example,dc=com
LDAP_BIND_DN=cn=admin,dc=example,dc=com
LDAP_BIND_PASSWORD=secret
```

### Keycloak / OIDC

```bash
AUTH_DB_ACTIVE=false
KEYCLOAK_ENABLED=true
KEYCLOAK_REALM=puzzletime
KEYCLOAK_SITE=https://auth.example.com
KEYCLOAK_CLIENT_ID=puzzletime
KEYCLOAK_CLIENT_SECRET=your-secret
```

## Email (SMTP)

| Variable | Description | Example |
|----------|-------------|---------|
| `SMTP_ADDRESS` | SMTP server | `smtp.example.com` |
| `SMTP_PORT` | SMTP port | `587` |
| `SMTP_USER_NAME` | Username | `user@example.com` |
| `SMTP_PASSWORD` | Password | `secret` |
| `SMTP_DOMAIN` | HELO domain | `example.com` |
| `SMTP_AUTHENTICATION` | Auth method | `plain` |
| `SMTP_ENABLE_STARTTLS_AUTO` | Use STARTTLS | `true` |
| `MAIL_FROM` | From address | `puzzletime@example.com` |

## Session & Security

| Variable | Description | Default |
|----------|-------------|---------|
| `RAILS_SESSION_SECURE` | Require HTTPS cookies | `true` |
| `RAILS_FORCE_SSL` | Redirect to HTTPS | (depends on proxy) |

!!! warning "HTTPS Required"
    Set `RAILS_SESSION_SECURE=false` only for internal/testing without HTTPS.

## Cache

| Variable | Description | Default |
|----------|-------------|---------|
| `RAILS_MEMCACHED_HOST` | Memcached host | `cache` |
| `RAILS_MEMCACHED_PORT` | Memcached port | `11211` |

## File Storage

| Variable | Description | Default |
|----------|-------------|---------|
| `RAILS_STORAGE_SERVICE` | Storage backend | `local` |

For S3-compatible storage:

```bash
RAILS_STORAGE_SERVICE=s3
S3_BUCKET=puzzletime
S3_REGION=eu-central-1
S3_ACCESS_KEY_ID=...
S3_SECRET_ACCESS_KEY=...
```

## Admin User (Setup)

Used by `./bin/setup.sh` and `./bin/create-admin.sh`:

| Variable | Description |
|----------|-------------|
| `ADMIN_SHORTNAME` | Admin username |
| `ADMIN_EMAIL` | Admin email |
| `ADMIN_FIRSTNAME` | First name |
| `ADMIN_LASTNAME` | Last name |
| `ADMIN_PASSWORD` | Password |

## Example .env.prod

```bash
# Domain
DOMAIN=time.example.com

# Database
POSTGRES_USER=puzzletime
POSTGRES_PASSWORD=your-secure-password
POSTGRES_DB=puzzletime_production

# Rails
SECRET_KEY_BASE=your-64-char-secret-key
RAILS_ENV=production
RAILS_LOG_TO_STDOUT=true
RAILS_SERVE_STATIC_FILES=true

# Authentication
AUTH_DB_ACTIVE=true

# Email
SMTP_ADDRESS=smtp.example.com
SMTP_PORT=587
SMTP_USER_NAME=puzzletime@example.com
SMTP_PASSWORD=smtp-password
MAIL_FROM=puzzletime@example.com

# Security
RAILS_SESSION_SECURE=true
```

## Applying Changes

After modifying `.env.prod`:

```bash
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d
```

