# Maintenance

Keep your PuzzleTime installation running smoothly.

## Updates

### Checking for Updates

Monitor the GitHub repository for new releases:

- [Releases](https://github.com/puzzle/puzzletime/releases)
- [Changelog](https://github.com/puzzle/puzzletime/blob/master/CHANGELOG.md)

### Updating PuzzleTime

Use the deploy script:

```bash
cd deploy
./bin/deploy.sh
```

This will:

1. Pull latest images
2. Run database migrations
3. Restart services

### Manual Update

```bash
# Pull new images
docker compose pull

# Stop services
docker compose down

# Run migrations
docker compose run --rm web bin/rails db:migrate

# Start services
docker compose up -d
```

### Rollback

If an update causes issues:

```bash
# Stop services
docker compose down

# Use previous image version
# Edit docker-compose.prod.yml:
#   image: ghcr.io/puzzle/puzzletime:v1.2.3

# Start with old version
docker compose up -d

# Restore database if needed
./bin/restore.sh backup_before_update.sql.gz
```

## Health Checks

### Application Health

```bash
# Check if web server responds
curl -f http://localhost:3000/status || echo "UNHEALTHY"
```

### Container Status

```bash
docker compose ps
```

All services should show `Up`:

```
NAME                 STATUS
puzzletime-web       Up (healthy)
puzzletime-jobs      Up
puzzletime-db        Up (healthy)
puzzletime-cache     Up
```

### Database Health

```bash
docker compose exec db pg_isready -U puzzletime
```

### Background Jobs

Check if DelayedJob is processing:

```bash
docker compose exec web bin/rails runner "puts Delayed::Job.count"
```

High job count may indicate processing issues.

## Logs

### Viewing Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f web

# Last 100 lines
docker compose logs --tail=100 web
```

### Log Files

Logs are written to stdout. To persist:

```yaml
# docker-compose.prod.yml
services:
  web:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### Important Log Patterns

| Pattern | Meaning |
|---------|---------|
| `Completed 200` | Successful request |
| `Completed 500` | Server error |
| `ActiveRecord::` | Database issue |
| `ActionController::` | Request error |

## Performance

### Slow Requests

Check for slow requests in logs:

```bash
docker compose logs web | grep "Completed .* in [0-9]\{4,\}ms"
```

### Database Performance

```bash
docker compose exec db psql -U puzzletime puzzletime_production -c "
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
"
```

### Memory Usage

```bash
docker stats --no-stream
```

### Disk Usage

```bash
# Database size
docker compose exec db psql -U puzzletime puzzletime_production -c "
SELECT pg_size_pretty(pg_database_size('puzzletime_production'));
"

# Container volumes
docker system df -v
```

## Database Maintenance

### Vacuum

PostgreSQL vacuum (usually automatic):

```bash
docker compose exec db psql -U puzzletime puzzletime_production -c "VACUUM ANALYZE;"
```

### Reindex

If searches are slow:

```bash
docker compose exec db psql -U puzzletime puzzletime_production -c "REINDEX DATABASE puzzletime_production;"
```

### Connection Pool

Monitor active connections:

```bash
docker compose exec db psql -U puzzletime puzzletime_production -c "
SELECT count(*) FROM pg_stat_activity;
"
```

## Cache Management

### Clear Cache

```bash
docker compose exec web bin/rails runner "Rails.cache.clear"
```

### Memcached Stats

```bash
docker compose exec cache sh -c "echo 'stats' | nc localhost 11211"
```

## Cleanup

### Old Sessions

Sessions expire automatically. To force cleanup:

```bash
docker compose exec cache sh -c "echo 'flush_all' | nc localhost 11211"
```

!!! warning
    This logs out all users.

### Old Jobs

Clean up failed jobs:

```bash
docker compose exec web bin/rails runner "Delayed::Job.where('failed_at IS NOT NULL').delete_all"
```

### Docker Cleanup

```bash
# Remove unused images
docker image prune -a

# Remove unused volumes (CAREFUL!)
docker volume prune

# Full cleanup
docker system prune -a
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker compose logs web

# Common issues:
# - Database not ready: wait and retry
# - Missing environment variables: check .env.prod
# - Port conflict: check what's using port 3000
```

### Database Connection Failed

```bash
# Check database is running
docker compose ps db

# Check connectivity
docker compose exec web ping db

# Check credentials
docker compose exec db psql -U puzzletime
```

### Out of Memory

```bash
# Check current usage
docker stats

# Increase limits in docker-compose.prod.yml:
services:
  web:
    deploy:
      resources:
        limits:
          memory: 1G
```

### Disk Full

```bash
# Find large files
docker compose exec web du -sh /app/*

# Clean logs
docker compose exec web truncate -s 0 /app/log/*.log

# Remove old backups
find backups/ -mtime +30 -delete
```

## Monitoring

### External Monitoring

Set up monitoring for:

| Check | Frequency | Alert |
|-------|-----------|-------|
| HTTP response | 1 min | If not 200 |
| SSL certificate | Daily | Before expiry |
| Disk space | 15 min | If > 80% |
| Backup age | Daily | If > 25h |

### Prometheus Metrics

If using Prometheus, add metrics endpoint:

```bash
# Add prometheus-exporter gem
# Configure /metrics endpoint
```

### Alerting

Configure alerts for:

- Application errors (500s)
- High response times
- Failed backups
- Disk space warnings

## Security Updates

### System Updates

Keep the host system updated:

```bash
apt update && apt upgrade -y
```

### Docker Updates

```bash
apt update
apt install docker-ce docker-ce-cli containerd.io
```

### Application Security

- Monitor for CVE announcements
- Update gems regularly
- Review GitHub security alerts

