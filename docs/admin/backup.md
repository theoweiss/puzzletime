# Backup & Restore

Protect your PuzzleTime data with regular backups.

## What to Back Up

| Component | Location | Method |
|-----------|----------|--------|
| Database | PostgreSQL | pg_dump |
| Uploads | /app/storage | File copy |
| Configuration | .env.prod | File copy |

## Manual Backup

### Database Backup

Use the provided script:

```bash
cd deploy
./bin/backup-now.sh
```

This creates a timestamped backup in `./backups/`:

```
backups/
  └── puzzletime_2024-01-15_143022.sql.gz
```

### Direct pg_dump

```bash
docker compose exec db pg_dump -U puzzletime puzzletime_production \
  | gzip > backup_$(date +%Y%m%d).sql.gz
```

### File Uploads

If using local storage:

```bash
docker compose exec web tar czf - /app/storage > uploads_$(date +%Y%m%d).tar.gz
```

## Automated Backups

### Option 1: Ofelia (Recommended)

Ofelia is a Docker-native job scheduler.

#### Enable in docker-compose.prod.yml

```yaml
services:
  ofelia:
    image: mcuadros/ofelia:latest
    container_name: puzzletime-ofelia
    command: daemon --docker
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    depends_on:
      - db
```

Add labels to the db service:

```yaml
  db:
    labels:
      ofelia.enabled: "true"
      ofelia.job-exec.backup.schedule: "0 0 2 * * *"
      ofelia.job-exec.backup.command: >
        sh -c 'pg_dump -U puzzletime puzzletime_production | 
        gzip > /backups/puzzletime_$(date +%Y%m%d_%H%M%S).sql.gz'
```

#### Using External Ofelia

If Ofelia runs elsewhere, add labels to enable discovery:

```yaml
  db:
    labels:
      ofelia.enabled: "true"
      ofelia.job-exec.backup.schedule: "0 0 2 * * *"
      ofelia.job-exec.backup.command: "..."
```

### Option 2: Cron

On the host system:

```bash
# /etc/cron.d/puzzletime-backup
0 2 * * * root /path/to/puzzletime/deploy/bin/backup-now.sh
```

### Option 3: Systemd Timer

```ini
# /etc/systemd/system/puzzletime-backup.timer
[Unit]
Description=Daily PuzzleTime backup

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

```ini
# /etc/systemd/system/puzzletime-backup.service
[Unit]
Description=PuzzleTime backup

[Service]
Type=oneshot
ExecStart=/path/to/puzzletime/deploy/bin/backup-now.sh
```

## Restore

### From Backup Script

```bash
cd deploy
./bin/restore.sh backups/puzzletime_2024-01-15_143022.sql.gz
```

### Manual Restore

```bash
# Stop the application
docker compose stop web jobs

# Drop and recreate database
docker compose exec db dropdb -U puzzletime puzzletime_production
docker compose exec db createdb -U puzzletime puzzletime_production

# Restore
gunzip -c backup.sql.gz | docker compose exec -T db psql -U puzzletime puzzletime_production

# Start application
docker compose start web jobs
```

### Restore Uploads

```bash
docker compose exec -T web tar xzf - -C / < uploads_backup.tar.gz
```

## Backup Verification

### Test Your Backups

Regularly verify backups by restoring to a test environment:

```bash
# Create test database
docker compose exec db createdb -U puzzletime puzzletime_test

# Restore backup
gunzip -c backup.sql.gz | docker compose exec -T db psql -U puzzletime puzzletime_test

# Verify data
docker compose exec db psql -U puzzletime puzzletime_test -c "SELECT COUNT(*) FROM employees;"

# Clean up
docker compose exec db dropdb -U puzzletime puzzletime_test
```

### Backup Checklist

- [ ] Backups run daily
- [ ] Backups are stored off-site
- [ ] Retention policy is configured
- [ ] Restore has been tested
- [ ] Alerts on backup failure

## Backup Retention

Keep backups according to your needs:

| Type | Retention |
|------|-----------|
| Daily | 7 days |
| Weekly | 4 weeks |
| Monthly | 12 months |
| Yearly | 7 years (if required) |

### Cleanup Script

```bash
#!/bin/bash
# Keep last 7 daily backups
find /path/to/backups -name "puzzletime_*.sql.gz" -mtime +7 -delete
```

## Off-Site Backup

### S3/MinIO

```bash
# Install AWS CLI
apt-get install awscli

# Upload backup
aws s3 cp backup.sql.gz s3://your-bucket/puzzletime/

# Or with rclone
rclone copy backup.sql.gz remote:puzzletime-backups/
```

### Rsync

```bash
rsync -av backups/ backup-server:/backups/puzzletime/
```

## Disaster Recovery

### Recovery Procedure

1. **Provision new server**
2. **Install Docker**
3. **Clone repository**
4. **Restore configuration**
   ```bash
   cp saved-env.prod deploy/.env.prod
   ```
5. **Start database only**
   ```bash
   docker compose up -d db
   ```
6. **Restore database**
   ```bash
   ./bin/restore.sh backup.sql.gz
   ```
7. **Start application**
   ```bash
   docker compose up -d
   ```
8. **Verify functionality**

### Recovery Time Objective (RTO)

With preparation:

| Step | Time |
|------|------|
| Server provision | 5-30 min |
| Docker install | 5 min |
| App deployment | 5 min |
| Database restore | 5-60 min (size dependent) |
| **Total** | **20-100 min** |

## Monitoring Backups

### Check Backup Age

```bash
# Alert if no backup in last 25 hours
find /backups -name "*.sql.gz" -mtime -1 | grep -q . || echo "ALERT: No recent backup!"
```

### Backup Size Trend

```bash
# List backup sizes
ls -lh /backups/*.sql.gz | tail -10
```

Unexpected size changes may indicate issues.

## Common Issues

??? question "Backup file is empty"
    - Check disk space
    - Verify database is running
    - Check PostgreSQL logs

??? question "Restore fails with permission error"
    - Ensure database user exists
    - Check connection parameters
    - Verify backup file is readable

??? question "Backup takes too long"
    - Consider pg_dump parallel mode
    - Check for large tables
    - Use incremental backups

