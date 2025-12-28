#!/usr/bin/env bash

#  Copyright (c) 2006-2025, Puzzle ITC GmbH. This file is part of
#  PuzzleTime and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/puzzletime.

# =============================================================================
# PuzzleTime Admin User Creation Script
# Creates the initial admin user for a fresh deployment
#
# Usage:
#   ./bin/create-admin.sh                     # Interactive mode
#   ./bin/create-admin.sh --env               # From ADMIN_* environment variables
#   ./bin/create-admin.sh --email x --pass y  # From arguments
# =============================================================================

set -e

cd "$(dirname "$0")/.."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ENV_FILE="${ENV_FILE:-.env.prod}"
COMPOSE_CMD="docker compose -f docker-compose.prod.yml --env-file $ENV_FILE"

# -----------------------------------------------------------------------------
# Parse arguments
# -----------------------------------------------------------------------------
USE_ENV=false
ARG_FIRSTNAME=""
ARG_LASTNAME=""
ARG_EMAIL=""
ARG_PASSWORD=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --env)
            USE_ENV=true
            shift
            ;;
        --firstname)
            ARG_FIRSTNAME="$2"
            shift 2
            ;;
        --lastname)
            ARG_LASTNAME="$2"
            shift 2
            ;;
        --email)
            ARG_EMAIL="$2"
            shift 2
            ;;
        --password|--pass)
            ARG_PASSWORD="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --env                Use ADMIN_* environment variables"
            echo "  --firstname NAME     Admin first name"
            echo "  --lastname NAME      Admin last name"
            echo "  --email EMAIL        Admin email address"
            echo "  --password PASS      Admin password"
            echo "  --help               Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Interactive mode"
            echo "  $0 --env                              # From .env.prod ADMIN_* vars"
            echo "  $0 --email admin@example.com --password secret"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# -----------------------------------------------------------------------------
# Load environment file
# -----------------------------------------------------------------------------
if [ -f "$ENV_FILE" ]; then
    set -a
    source "$ENV_FILE"
    set +a
fi

# -----------------------------------------------------------------------------
# Check if admin already exists
# -----------------------------------------------------------------------------
check_admin_exists() {
    local count
    count=$($COMPOSE_CMD exec -T web bin/rails runner "puts Employee.where(management: true).count" 2>/dev/null | tr -d '\r')
    if [ "$count" != "0" ] && [ -n "$count" ]; then
        return 0  # Admin exists
    fi
    return 1  # No admin
}

# -----------------------------------------------------------------------------
# Get admin details
# -----------------------------------------------------------------------------
get_admin_details() {
    # Priority: Arguments > Environment > Interactive

    # First name
    if [ -n "$ARG_FIRSTNAME" ]; then
        FIRSTNAME="$ARG_FIRSTNAME"
    elif [ -n "$ADMIN_FIRSTNAME" ]; then
        FIRSTNAME="$ADMIN_FIRSTNAME"
    elif [ "$USE_ENV" = true ]; then
        echo -e "${RED}Error: ADMIN_FIRSTNAME not set${NC}"
        exit 1
    else
        read -p "First name: " FIRSTNAME
    fi

    # Last name
    if [ -n "$ARG_LASTNAME" ]; then
        LASTNAME="$ARG_LASTNAME"
    elif [ -n "$ADMIN_LASTNAME" ]; then
        LASTNAME="$ADMIN_LASTNAME"
    elif [ "$USE_ENV" = true ]; then
        echo -e "${RED}Error: ADMIN_LASTNAME not set${NC}"
        exit 1
    else
        read -p "Last name: " LASTNAME
    fi

    # Email
    if [ -n "$ARG_EMAIL" ]; then
        EMAIL="$ARG_EMAIL"
    elif [ -n "$ADMIN_EMAIL" ]; then
        EMAIL="$ADMIN_EMAIL"
    elif [ "$USE_ENV" = true ]; then
        echo -e "${RED}Error: ADMIN_EMAIL not set${NC}"
        exit 1
    else
        read -p "Email: " EMAIL
    fi

    # Password
    if [ -n "$ARG_PASSWORD" ]; then
        PASSWORD="$ARG_PASSWORD"
    elif [ -n "$ADMIN_PASSWORD" ]; then
        PASSWORD="$ADMIN_PASSWORD"
    elif [ "$USE_ENV" = true ]; then
        echo -e "${RED}Error: ADMIN_PASSWORD not set${NC}"
        exit 1
    else
        while true; do
            read -s -p "Password: " PASSWORD
            echo ""
            read -s -p "Confirm password: " PASSWORD_CONFIRM
            echo ""
            if [ "$PASSWORD" = "$PASSWORD_CONFIRM" ]; then
                break
            else
                echo -e "${RED}Passwords do not match. Try again.${NC}"
            fi
        done
    fi

    # Generate shortname from initials
    SHORTNAME=$(echo "${FIRSTNAME:0:1}${LASTNAME:0:1}" | tr '[:lower:]' '[:upper:]')
}

# -----------------------------------------------------------------------------
# Create admin user
# -----------------------------------------------------------------------------
create_admin() {
    echo -e "${YELLOW}Creating admin user...${NC}"

    # Escape special characters for Ruby
    ESCAPED_PASSWORD=$(printf '%s' "$PASSWORD" | sed 's/\\/\\\\/g; s/"/\\"/g')

    $COMPOSE_CMD exec -T web bin/rails runner "
        employee = Employee.new(
            firstname: '$FIRSTNAME',
            lastname: '$LASTNAME',
            shortname: '$SHORTNAME',
            email: '$EMAIL',
            password: \"$ESCAPED_PASSWORD\",
            management: true
        )

        # Handle duplicate shortname
        if Employee.exists?(shortname: employee.shortname)
            # Add number to make unique
            base = employee.shortname
            counter = 1
            while Employee.exists?(shortname: employee.shortname)
                employee.shortname = \"\#{base}\#{counter}\"
                counter += 1
            end
        end

        employee.save!
        puts \"SHORTNAME:\#{employee.shortname}\"
    " 2>/dev/null | while read -r line; do
        if [[ "$line" == SHORTNAME:* ]]; then
            SHORTNAME="${line#SHORTNAME:}"
            echo -e "${GREEN}✓ Admin user created successfully!${NC}"
            echo ""
            echo "Login credentials:"
            echo -e "  Username: ${BLUE}${SHORTNAME}${NC}"
            echo -e "  Email:    ${BLUE}$EMAIL${NC}"
            echo "  Password: (as entered)"
        fi
    done
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           PuzzleTime Admin User Setup                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if web container is running
if ! $COMPOSE_CMD ps web 2>/dev/null | grep -q "Up"; then
    echo -e "${RED}Error: PuzzleTime is not running.${NC}"
    echo "Start it first with: docker compose -f docker-compose.prod.yml up -d"
    exit 1
fi

# Check if admin already exists
if check_admin_exists; then
    echo -e "${GREEN}✓ Admin user(s) already exist.${NC}"
    echo ""
    echo "Existing managers:"
    $COMPOSE_CMD exec -T web bin/rails runner "
        Employee.where(management: true).each { |e| puts \"  - #{e.shortname}: #{e.firstname} #{e.lastname} (#{e.email})\" }
    " 2>/dev/null
    echo ""
    read -p "Create another admin user? (y/N) " response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Get details and create
get_admin_details
create_admin

echo ""

