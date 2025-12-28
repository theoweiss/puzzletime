# PuzzleTime Internal Documentation

> Internal technical analysis and documentation for the PuzzleTime project.

---

## Quick Start (Docker)

Run the entire application with a single command — no local Ruby or PostgreSQL installation required.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running

### First-time Setup

```bash
# Clone the repository
git clone https://github.com/puzzle/puzzletime.git
cd puzzletime

# Copy environment template
cp .env.example .env

# Start everything
bin/dev
```

### What Gets Started

| Service | URL | Description |
|---------|-----|-------------|
| **Rails App** | http://localhost:3000 | Main application |
| **MailCatcher** | http://localhost:1080 | Catches all outgoing emails |
| **PostgreSQL** | localhost:5432 | Database |
| **Memcached** | localhost:11211 | Cache |
| **DelayedJob** | (background) | Background job processing |

### First-time Database Setup

After `bin/dev` starts, open a new terminal and run:

```bash
docker compose exec web bin/rails db:setup
```

### Default Users

| Name | Username | Role | Password |
|------|----------|------|----------|
| Mark Waber | MW | Manager | a |
| Andreas Rava | AR | Manager | a |
| Pascal Zumkehr | PZ | User | a |
| Daniel Illi | DI | User | a |

### Common Commands

```bash
# Start all services
bin/dev

# Start in detached mode
bin/dev -d

# Stop all services
docker compose down

# View logs
docker compose logs -f web

# Run Rails console
docker compose exec web bin/rails console

# Run tests
docker compose exec web rake test

# Run a specific rake task
docker compose exec web bin/rails db:migrate
```

### Troubleshooting

**Port already in use:**
```bash
# Stop existing services and try again
docker compose down
bin/dev
```

**Database connection issues:**
```bash
# Wait for PostgreSQL to be ready, then:
docker compose exec web bin/rails db:prepare
```

**Reset everything:**
```bash
docker compose down -v  # Removes volumes too
bin/dev
docker compose exec web bin/rails db:setup
```

---

## Project Overview

**PuzzleTime** is an open-source time tracking and resource planning web application designed for SMEs (Small and Medium-sized Enterprises). It is developed and maintained by [Puzzle ITC AG](https://www.puzzle.ch).

- **Current Version:** 2.15.2
- **License:** GNU Affero General Public License v3
- **Repository:** https://github.com/puzzle/puzzletime
- **Copyright:** 2006-2025 Puzzle ITC GmbH

---

## Technology Stack

### Backend
| Component | Technology |
|-----------|------------|
| Framework | Ruby on Rails 7.0 |
| Database | PostgreSQL 16+ |
| Caching | Memcached |
| Background Jobs | DelayedJob (delayed_job_active_record) |
| Web Server | Puma |
| Authentication | Devise + LDAP + OmniAuth (Keycloak, SAML) |
| Authorization | CanCanCan |
| API Format | JSON:API (fast_jsonapi) |
| PDF Generation | Prawn |
| Error Tracking | Sentry / Glitchtip / Airbrake |

### Frontend
| Component | Technology |
|-----------|------------|
| Templates | HAML (326+ views) |
| Stylesheets | SCSS + Bootstrap 3 (Sass) |
| JavaScript | CoffeeScript (34 files) |
| JS Libraries | jQuery, jQuery UI, Turbolinks, Chart.js |
| CSS Tooling | Autoprefixer |

### External Integrations
- **CRM:** Highrise, Odoo
- **Invoicing:** SmallInvoice
- **Authentication:** LDAP, Keycloak (OpenID), SAML

---

## Architecture Overview

### Core Domain Model

The application is built around these central models:

```
┌─────────────────────────────────────────────────────────────────┐
│                         WorkItem (Tree)                         │
│  ┌──────────┐    ┌──────────┐    ┌─────────────────┐           │
│  │  Client  │───▶│  Order   │───▶│ AccountingPost  │           │
│  └──────────┘    └──────────┘    └─────────────────┘           │
│       │               │                   │                     │
│       ▼               ▼                   ▼                     │
│   Contacts       Contracts          Plannings                   │
│   Billing        Invoices           Worktimes                   │
│   Addresses      Comments                                       │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                          Employee                               │
│  ┌──────────────┐  ┌─────────────┐  ┌──────────────────┐       │
│  │ Employments  │  │  Plannings  │  │    Worktimes     │       │
│  │ (contracts)  │  │  (future)   │  │ (time tracking)  │       │
│  └──────────────┘  └─────────────┘  └──────────────────┘       │
│         │                                    │                  │
│         ▼                                    ▼                  │
│  Employment Roles              ┌─────────────┴─────────────┐   │
│  Departments                   │                           │   │
│  Workplaces                    ▼                           ▼   │
│                           Ordertime               Absencetime   │
└─────────────────────────────────────────────────────────────────┘
```

### Key Entities

| Entity | Description |
|--------|-------------|
| **Worktime** | Central time tracking object. Uses STI: `Ordertime` (work on projects) and `Absencetime` (absences like vacation, sick leave) |
| **WorkItem** | Tree structure organizing Clients → Orders → Accounting Posts. Contains path information for navigation |
| **Client** | Top-level entity with contacts and billing addresses |
| **Order** | Central project entity for managing workflow, reporting, and invoicing |
| **AccountingPost** | Defines budget, hourly rates, and billing requirements per position |
| **Employee** | Users of the system. Tracks employments, work time, and plannings |
| **Planning** | Resource allocation on accounting posts for future forecasting |

---

## Application Structure

### Directory Layout

```
app/
├── assets/
│   ├── javascripts/     # 34 CoffeeScript files
│   └── stylesheets/     # 30 SCSS files
├── controllers/
│   ├── api/             # JSON:API endpoints
│   ├── concerns/        # Shared controller concerns
│   ├── dry_crud/        # DRY CRUD framework
│   ├── employees/       # Employee-related controllers
│   ├── orders/          # Order workflow controllers
│   └── plannings/       # Resource planning controllers
├── domain/              # Business logic layer (104 files)
│   ├── billing/         # Billing reports
│   ├── crm/             # CRM integrations (Highrise, Odoo)
│   ├── evaluations/     # Various evaluation modules
│   ├── invoicing/       # Invoice generation (SmallInvoice)
│   ├── order/           # Order management logic
│   ├── plannings/       # Planning board logic
│   └── reports/         # Various reports
├── helpers/             # View helpers (46 files)
├── jobs/                # Background jobs (6 files)
├── mailers/             # Email (2 files)
├── models/              # ActiveRecord models (61 files)
│   ├── concerns/        # Model concerns
│   └── util/            # Utility classes (Period, ReportType, etc.)
├── serializers/         # JSON:API serializers
├── validators/          # Custom validators
└── views/               # HAML templates (349 files)
```

### Layer Architecture

1. **Controllers** (`app/controllers/`)
   - Uses a DRY CRUD pattern with `CrudController` base class
   - `ListController` for list views
   - RESTful design with nested resources

2. **Domain Layer** (`app/domain/`)
   - Business logic separated from models
   - Evaluations: Complex reporting calculations
   - Integrations: CRM and Invoicing interfaces
   - Reports: Revenue, workload, capacity

3. **Models** (`app/models/`)
   - ActiveRecord models with validations
   - Single Table Inheritance for Worktimes
   - Tree structure for WorkItems (`acts_as_tree`)

---

## Database Schema

### Key Tables (31+ tables)

| Table | Purpose |
|-------|---------|
| `employees` | User accounts and personal data |
| `employments` | Employment contracts with dates and percentages |
| `worktimes` | Time entries (STI: ordertime, absencetime) |
| `work_items` | Hierarchical structure (clients, orders, positions) |
| `clients` | Client companies |
| `orders` | Project orders |
| `accounting_posts` | Billing positions with rates/budgets |
| `plannings` | Resource allocations |
| `invoices` | Generated invoices |
| `expenses` | Employee expense claims |
| `absences` | Absence types (vacation, sick, etc.) |
| `departments` | Organizational units |
| `contracts` | Contract details |
| `holidays` | Public holidays |

### Important Relationships

- `Employee` → many `Employments` → many `EmploymentRoles`
- `Employee` → many `Worktimes` (Ordertime | Absencetime)
- `WorkItem` → one of: `Client`, `Order`, `AccountingPost`
- `Order` → many `Invoices` → many `Worktimes`
- `Order` → many `OrderComments`, `OrderTargets`, `OrderUncertainties`

---

## Key Features

### Time Tracking
- Multiple report types: start/stop, absolute day, week, month
- Auto-start functionality
- Billable/non-billable classification
- Internal/external descriptions
- Ticket integration
- Meal compensation tracking

### Resource Planning
- Department-level planning views
- Employee planning boards
- Order-based planning
- Company-wide overview
- Definitive vs. tentative planning

### Reporting
- **Order Reports:** Budget, controlling, time rapport
- **Invoice Reports:** Billing status, amounts
- **Workload Reports:** Employee utilization
- **Revenue Reports:** By department, portfolio, sector, service
- **Capacity Reports:** Extended capacity analysis
- **Export:** CSV export across all reports

### Invoicing
- Integration with SmallInvoice
- PDF time reports (Prawn)
- Customizable grouping
- Period-based filtering

### Order Management
- Order status workflow
- Risk/chance tracking
- Target scope monitoring
- Budget controlling cockpit
- Team member assignment

---

## API

### REST API (JSON:API)
- Endpoint: `/api/v1/`
- Currently exposed: `employees` (index, show)
- Swagger documentation: `/api/docs`
- Format: JSON:API specification

### Authentication
- Database password (optional)
- LDAP integration
- Keycloak OpenID Connect
- SAML

---

## Configuration

### Environment Variables

| Variable | Purpose |
|----------|---------|
| `RAILS_TIME_ZONE` | Application timezone |
| `RAILS_LOCALE` | Language (default: de-CH) |
| `RAILS_MEMCACHED_HOST` | Memcached server |
| `RAILS_LDAP_*` | LDAP configuration |
| `AUTH_KEYCLOAK_*` | Keycloak SSO settings |
| `AUTH_SAML_*` | SAML SSO settings |
| `RAILS_HIGHRISE_*` | Highrise CRM integration |
| `RAILS_ODOO_*` | Odoo CRM integration |
| `RAILS_SMALL_INVOICE_*` | SmallInvoice integration |
| `GLITCHTIP_DSN` / `SENTRY_DSN` | Error tracking |
| `RAILS_PTIME_*` | Application-specific settings |

### Settings Files
- `config/settings.yml` - Main configuration
- `config/settings/*.yml` - Environment-specific overrides

---

## Development

### Prerequisites
- Ruby (see `.ruby-version`)
- PostgreSQL 16+
- Memcached (optional for development)
- Node.js + Yarn

### Setup
```bash
bin/setup              # Install dependencies & setup database
docker-compose up -d   # Start PostgreSQL + MailCatcher
rails server           # Start development server
```

### Testing
```bash
rake                   # Run all tests
bin/m test/...         # Run specific tests
```

### Code Quality
- RuboCop for Ruby linting
- HAML-Lint for templates
- Brakeman for security analysis

---

## Docker Services

```yaml
services:
  ptimedb:        # PostgreSQL 16.6 (port 5432)
  ptimemailcatcher:  # MailCatcher (SMTP: 1025, Web: 1080)
```

---

## Key Gems

| Gem | Purpose |
|-----|---------|
| `devise` | Authentication |
| `cancancan` | Authorization |
| `haml` | Template engine |
| `prawn` / `prawn-table` | PDF generation |
| `delayed_job_active_record` | Background jobs |
| `paper_trail` | Audit logging / versioning |
| `acts_as_tree` | WorkItem tree structure |
| `kaminari` | Pagination |
| `fast_jsonapi` | JSON:API serialization |
| `omniauth-keycloak` / `omniauth-saml` | SSO |
| `net-ldap` | LDAP authentication |
| `rswag-ui` | Swagger API docs |

---

## Localization

- Default locale: `de-CH` (Swiss German)
- Locale files: `config/locales/*.yml`
- Supports i18n via `rails-i18n`

---

## File Organization Notes

- **No filesystem storage:** All persistent data in PostgreSQL
- **Active Storage:** Used for expense receipts (configurable: local or S3)
- **Caching:** Memcached for sessions and computed data

---

## Contact & Resources

- **Public Docs:** `doc/` directory
- **User Guide:** `doc/user/`
- **Architecture:** `doc/architecture/` (arc42 format)
- **Development:** `doc/development/`
- **Changelog:** `CHANGELOG.md`

