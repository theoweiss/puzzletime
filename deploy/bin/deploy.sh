#!/usr/bin/env bash

#  Copyright (c) 2006-2025, Puzzle ITC GmbH. This file is part of
#  PuzzleTime and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/puzzletime.

# =============================================================================
# PuzzleTime Deployment Script
# Updates PuzzleTime to the latest version with minimal downtime
# =============================================================================

set -e

cd "$(dirname "$0")/.."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ENV_FILE="${1:-.env.prod}"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           PuzzleTime Deployment                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${RED}Error: $ENV_FILE not found. Run setup.sh first.${NC}"
    exit 1
fi

# -----------------------------------------------------------------------------
# Create backup before deployment
# -----------------------------------------------------------------------------
echo -e "${YELLOW}Creating pre-deployment backup...${NC}"
./bin/backup-now.sh "$ENV_FILE"

# -----------------------------------------------------------------------------
# Pull latest images
# -----------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}Pulling latest images...${NC}"
docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" pull

# -----------------------------------------------------------------------------
# Run database migrations
# -----------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}Running database migrations...${NC}"
docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" run --rm web bin/rails db:migrate

# -----------------------------------------------------------------------------
# Restart application services (not database)
# -----------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}Restarting application...${NC}"
docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" up -d --no-deps web jobs

# -----------------------------------------------------------------------------
# Health check
# -----------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}Waiting for application to be ready...${NC}"
sleep 5

if docker compose -f docker-compose.prod.yml --env-file "$ENV_FILE" ps | grep -q "web.*Up"; then
    echo -e "${GREEN}✓ Application is running${NC}"
else
    echo -e "${RED}⚠ Application may not have started correctly${NC}"
    echo "Check logs with: docker compose -f docker-compose.prod.yml logs web"
fi

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Deployment Complete!                             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "View logs: ${BLUE}docker compose -f docker-compose.prod.yml logs -f web${NC}"
echo ""

