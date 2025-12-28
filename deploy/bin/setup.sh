#!/usr/bin/env bash

#  Copyright (c) 2006-2025, Puzzle ITC GmbH. This file is part of
#  PuzzleTime and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/puzzletime.

# =============================================================================
# PuzzleTime Production Setup Script
# First-time setup: generates secrets, creates directories, initializes database
# =============================================================================

set -e

cd "$(dirname "$0")/.."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           PuzzleTime Production Setup                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# -----------------------------------------------------------------------------
# Check prerequisites
# -----------------------------------------------------------------------------
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed.${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker is not running.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker is available${NC}"

# -----------------------------------------------------------------------------
# Create .env.prod if it doesn't exist
# -----------------------------------------------------------------------------
if [ ! -f .env.prod ]; then
    echo ""
    echo -e "${YELLOW}Creating .env.prod from template...${NC}"
    cp .env.prod.example .env.prod

    # Generate secrets
    echo -e "${YELLOW}Generating secrets...${NC}"
    
    # Generate POSTGRES_PASSWORD
    POSTGRES_PASSWORD=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)
    sed -i.bak "s/^POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=${POSTGRES_PASSWORD}/" .env.prod
    
    # Generate SECRET_KEY_BASE
    SECRET_KEY_BASE=$(openssl rand -hex 64)
    sed -i.bak "s/^SECRET_KEY_BASE=.*/SECRET_KEY_BASE=${SECRET_KEY_BASE}/" .env.prod
    
    rm -f .env.prod.bak
    
    echo -e "${GREEN}✓ Secrets generated${NC}"
    echo ""
    echo -e "${YELLOW}⚠ Please edit .env.prod to configure:${NC}"
    echo "  - DOMAIN (your domain name)"
    echo "  - SMTP settings (for email)"
    echo "  - Authentication settings"
    echo ""
else
    echo -e "${GREEN}✓ .env.prod already exists${NC}"
fi

# -----------------------------------------------------------------------------
# Create backup directory
# -----------------------------------------------------------------------------
mkdir -p backups
echo -e "${GREEN}✓ Backup directory ready${NC}"

# -----------------------------------------------------------------------------
# Pull images
# -----------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}Pulling Docker images...${NC}"
docker compose -f docker-compose.prod.yml --env-file .env.prod pull

# -----------------------------------------------------------------------------
# Start database first
# -----------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}Starting database...${NC}"
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d db
echo "Waiting for database to be ready..."
sleep 10

# -----------------------------------------------------------------------------
# Initialize database
# -----------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}Initializing database...${NC}"
docker compose -f docker-compose.prod.yml --env-file .env.prod run --rm web bin/rails db:prepare

# -----------------------------------------------------------------------------
# Start all services
# -----------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}Starting all services...${NC}"
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d

# Wait for web to be ready
echo "Waiting for application to start..."
sleep 10

# -----------------------------------------------------------------------------
# Create admin user
# -----------------------------------------------------------------------------
echo ""

# Check if ADMIN_EMAIL is set (automated mode)
if [ -n "${ADMIN_EMAIL:-}" ]; then
    echo -e "${YELLOW}Creating admin user from environment variables...${NC}"
    ./bin/create-admin.sh --env
else
    # Interactive mode
    echo -e "${YELLOW}Let's create your admin user.${NC}"
    echo ""
    ./bin/create-admin.sh
fi

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Setup Complete!                                  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit .env.prod with your domain and SMTP settings (if not done)"
echo "  2. Configure your reverse proxy (see docs/)"
echo "  3. Access PuzzleTime at https://\${DOMAIN:-localhost}"
echo ""
echo -e "View logs: ${BLUE}docker compose -f docker-compose.prod.yml logs -f${NC}"
echo ""

