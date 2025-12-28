# Data Model

Understanding PuzzleTime's core data model.

## Overview

```
┌─────────────┐
│   Client    │ ← Customer/Organization
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Order    │ ← Project/Mandate
└──────┬──────┘
       │
       ▼
┌─────────────┐
│Accounting   │ ← Booking Position
│   Post      │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Worktime   │ ← Time Entry
└─────────────┘
```

## Core Entities

### Client (Kunde)

Represents a customer or organization.

| Field | Type | Description |
|-------|------|-------------|
| name | string | Full company name |
| shortname | string | Short code (e.g., "ACME") |
| sector_id | integer | Industry sector |

**Relationships:**

- Has many Orders
- Has many Contacts
- Has many Billing Addresses

### Order (Auftrag)

Represents a project, mandate, or ongoing work.

| Field | Type | Description |
|-------|------|-------------|
| work_item_id | integer | Link to work item |
| kind_id | integer | Order type |
| status_id | integer | Current status |
| responsible_id | integer | Project lead |
| department_id | integer | Owning department |

**Relationships:**

- Belongs to Client (via work_item)
- Has many Accounting Posts
- Has many Contracts
- Has many Team Members

### Accounting Post (Buchungsposition)

Represents a billable position within an order.

| Field | Type | Description |
|-------|------|-------------|
| work_item_id | integer | Link to work item |
| offered_hours | decimal | Budgeted hours |
| offered_rate | decimal | Hourly rate |
| billable | boolean | Is billable? |
| closed | boolean | Is closed? |

**Relationships:**

- Belongs to Order (via work_item)
- Has many Worktimes

### Work Item

Hierarchical structure linking Client → Order → Position.

| Field | Type | Description |
|-------|------|-------------|
| name | string | Full name |
| shortname | string | Short code |
| parent_id | integer | Parent work item |
| leaf | boolean | Is bottom level? |
| path_shortnames | string | Full path (e.g., "ACME-WEB-DEV") |

### Employee (Mitarbeiter)

Represents a user/team member.

| Field | Type | Description |
|-------|------|-------------|
| firstname | string | First name |
| lastname | string | Last name |
| shortname | string | Login shortname |
| email | string | Email address |
| department_id | integer | Department |

**Relationships:**

- Belongs to Department
- Has many Employments
- Has many Worktimes

### Worktime (Arbeitszeit)

Base class for time entries. Uses Single Table Inheritance (STI).

| Field | Type | Description |
|-------|------|-------------|
| employee_id | integer | Who recorded |
| work_date | date | Date of work |
| hours | decimal | Hours worked |
| from_start_time | time | Start time |
| to_end_time | time | End time |
| description | text | What was done |
| ticket | string | Ticket reference |
| billable | boolean | Is billable? |
| type | string | STI type |

**Types:**

- `Ordertime` — Time on orders
- `Absencetime` — Absences (vacation, sick)

### Department (Abteilung)

Organizational unit.

| Field | Type | Description |
|-------|------|-------------|
| name | string | Department name |
| shortname | string | Short code |
| parent_id | integer | Parent department |

### Employment (Anstellung)

Employment record for an employee.

| Field | Type | Description |
|-------|------|-------------|
| employee_id | integer | Employee |
| percent | decimal | Employment percentage |
| start_date | date | Start date |
| end_date | date | End date (optional) |

## Reference Tables

### Order Kind (Auftragsart)

Types of orders.

| Value | Description |
|-------|-------------|
| Projekt | Fixed-scope project |
| Mandat | Ongoing consulting |
| Wartung | Maintenance contract |
| Intern | Internal project |

### Order Status

Order lifecycle states.

| Value | Description |
|-------|-------------|
| Bearbeitung | Active |
| Abschluss | Wrapping up |
| Garantie | Warranty period |
| Abgeschlossen | Closed |

### Absence

Types of absences.

| Value | Description |
|-------|-------------|
| Ferien | Vacation |
| Krankheit | Sick leave |
| Militär | Military service |
| Bezahlte Absenz | Paid absence |
| Unbezahlte Absenz | Unpaid absence |

## Relationships Diagram

```
Client (1) ─────────────── (n) Order
                               │
Order (1) ─────────────── (n) Accounting Post
                               │
Accounting Post (1) ────── (n) Ordertime

Employee (1) ──────────── (n) Worktime
         │
         └────────────── (n) Employment

Department (1) ─────────── (n) Employee
           │
           └────────────── (1) Department (parent)
```

## Work Item Hierarchy

Work Items form a tree structure:

```
Level 0: Client
         └── Level 1: Order (or Category)
                      └── Level 2: Order or Position
                                   └── Level 3: Position
```

### Path Examples

| Path | Components |
|------|------------|
| `ACME` | Client only |
| `ACME-WEB` | Client + Order |
| `ACME-WEB-DEV` | Client + Order + Position |
| `ACME-APO-A11-REA` | Full 4-level path |

## Soft References

Some fields use string references rather than foreign keys:

| Entity | Field | Reference |
|--------|-------|-----------|
| Worktime | ticket | External ticket system |
| Order | crm_key | External CRM ID |

## Timestamps

All entities include:

| Field | Description |
|-------|-------------|
| created_at | Creation timestamp |
| updated_at | Last modification |

## Validations

### Required Fields

| Entity | Required |
|--------|----------|
| Client | name, shortname |
| Order | work_item, kind, status, responsible |
| Employee | firstname, lastname, shortname, email |
| Worktime | employee, work_date, hours |

### Unique Constraints

| Entity | Unique Fields |
|--------|---------------|
| Client | shortname |
| Employee | shortname, email |
| Work Item | shortname (within parent) |

## Database Schema

See `db/schema.rb` for the complete database schema.

Key tables:

```
clients
work_items
orders
accounting_posts
employees
worktimes
absences
departments
employments
```

