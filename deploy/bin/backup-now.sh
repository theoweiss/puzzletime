#!/usr/bin/env bash

#  Copyright (c) 2006-2025, Puzzle ITC GmbH. This file is part of
#  PuzzleTime and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/puzzletime.

# =============================================================================
# PuzzleTime Manual Backup Script
# Creates an immediate database backup
# =============================================================================

set -e

cd "$(dirname "$0")/.."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ENV_FILE="${1:-.env.prod}"

# Load environment
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

BACKUP_FILE="backups/puzzletime_$(date +%Y%m%d_%H%M%S).sql.gz"

echo -e "${YELLOW}Creating backup...${NC}"

docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" exec -T db \
    pg_dump -U "${POSTGRES_USER:-puzzletime}" "${POSTGRES_DB:-puzzletime_production}" | gzip > "$BACKUP_FILE"

echo -e "${GREEN}✓ Backup created: $BACKUP_FILE${NC}"
echo ""
echo "Backup size: $(du -h "$BACKUP_FILE" | cut -f1)"
echo ""

