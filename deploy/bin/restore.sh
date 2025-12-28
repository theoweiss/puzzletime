#!/usr/bin/env bash

#  Copyright (c) 2006-2025, Puzzle ITC GmbH. This file is part of
#  PuzzleTime and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/puzzletime.

# =============================================================================
# PuzzleTime Database Restore Script
# Restores database from a backup file
# =============================================================================

set -e

cd "$(dirname "$0")/.."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ENV_FILE=".env.prod"

# -----------------------------------------------------------------------------
# Check arguments
# -----------------------------------------------------------------------------
if [ -z "$1" ]; then
    echo "Usage: $0 <backup-file>"
    echo ""
    echo "Available backups:"
    ls -lh backups/*.sql.gz 2>/dev/null || echo "  No backups found"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${RED}Error: Backup file not found: $BACKUP_FILE${NC}"
    exit 1
fi

# Load environment
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

# -----------------------------------------------------------------------------
# Confirm restore
# -----------------------------------------------------------------------------
echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║           ⚠ DATABASE RESTORE WARNING ⚠                     ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "This will:"
echo "  1. Stop the web and jobs services"
echo "  2. DROP the existing database"
echo "  3. Restore from: $BACKUP_FILE"
echo "  4. Restart services"
echo ""
echo -e "${RED}ALL CURRENT DATA WILL BE LOST!${NC}"
echo ""
read -p "Type 'RESTORE' to confirm: " confirmation

if [ "$confirmation" != "RESTORE" ]; then
    echo "Restore cancelled."
    exit 0
fi

# -----------------------------------------------------------------------------
# Stop application services
# -----------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}Stopping application services...${NC}"
docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" stop web jobs

# -----------------------------------------------------------------------------
# Drop and recreate database
# -----------------------------------------------------------------------------
echo -e "${YELLOW}Dropping existing database...${NC}"
docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" exec -T db \
    psql -U "${POSTGRES_USER:-puzzletime}" -d postgres -c "DROP DATABASE IF EXISTS ${POSTGRES_DB:-puzzletime_production};"

docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" exec -T db \
    psql -U "${POSTGRES_USER:-puzzletime}" -d postgres -c "CREATE DATABASE ${POSTGRES_DB:-puzzletime_production};"

# -----------------------------------------------------------------------------
# Restore backup
# -----------------------------------------------------------------------------
echo -e "${YELLOW}Restoring database from backup...${NC}"
gunzip -c "$BACKUP_FILE" | docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" exec -T db \
    psql -U "${POSTGRES_USER:-puzzletime}" "${POSTGRES_DB:-puzzletime_production}"

# -----------------------------------------------------------------------------
# Start services
# -----------------------------------------------------------------------------
echo -e "${YELLOW}Starting application services...${NC}"
docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" up -d web jobs

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Restore Complete!                                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

