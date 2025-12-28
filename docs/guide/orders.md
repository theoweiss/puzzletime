# Orders & Projects

Orders represent projects, mandates, or ongoing work in PuzzleTime.

## Order Hierarchy

```
Client (Kunde)
  └── Category (optional)
        └── Order (Auftrag)
              └── Accounting Post (Buchungsposition)
```

### Example

```
NASA (Client)
  └── Apollo Program (Category)
        └── Apollo 11 (Order)
              ├── Development (Position)
              ├── Testing (Position)
              └── Meetings (Position)
```

## Creating Orders

!!! note "Permissions"
    Only users with **Order Manager** or **Management** roles can create orders.

### Steps

1. Navigate to **Aufträge** (Orders)
2. Click **+ erstellen**
3. Fill in the required fields:

| Field | Required | Description |
|-------|----------|-------------|
| Kunde | Yes | Client/customer |
| Name | Yes | Full order name |
| Kurzname | Yes | Short code (3-4 chars) |
| Art | Yes | Order type |
| Status | Yes | Current status |
| Organisationseinheit | Yes | Responsible department |
| Auftragsverantwortlicher | Yes | Project lead |

4. Click **Speichern**

## Order Types (Art)

| Type | German | Use Case |
|------|--------|----------|
| Project | Projekt | Fixed-scope projects |
| Mandate | Mandat | Ongoing consulting |
| Maintenance | Wartung | Support contracts |
| Service | Service und Support | Ad-hoc support |
| Training | Schulung | Workshops, training |
| Internal | Intern | Internal projects |

## Order Status

Orders progress through statuses:

```
Bearbeitung → Abschluss → Abgeschlossen
     │
     └──→ Garantie → Abgeschlossen
```

| Status | Meaning |
|--------|---------|
| Bearbeitung | Active, work in progress |
| Abschluss | Wrapping up |
| Garantie | Warranty period (2 years) |
| Abgeschlossen | Closed, no more booking |

## Accounting Posts (Positions)

Positions are where time gets recorded.

### Creating Positions

1. Open an order
2. Go to **Positionen** tab
3. Click **+ erstellen**
4. Fill in:

| Field | Required | Description |
|-------|----------|-------------|
| Name | Yes | Position name |
| Kurzname | Yes | Short code |
| Stundensatz | No | Hourly rate |
| Offerte Stunden | No | Budgeted hours |
| Verrechenbar | Yes | Billable? |

### Common Positions

```
- Analyse (Analysis)
- Konzept (Concept)
- Realisierung / REA (Development)
- Test (Testing)
- Projektleitung / PL (Project Management)
- Meeting (Meetings)
```

### Closing Positions

When a position is complete:

1. Open the position
2. Check **Abgeschlossen** (Closed)
3. Save

!!! warning
    Closed positions cannot receive new time entries.

## Order Team

Assign team members to orders:

1. Open the order
2. Go to **Team** section
3. Add employees

Team members can:

- Book time to the order
- View order details
- Access position budgets

## Order Controlling

Track order health with the controlling view:

| Metric | Description |
|--------|-------------|
| Budget | Contracted hours |
| Booked | Hours recorded |
| Remaining | Budget - Booked |
| Progress | % of budget used |

### Accessing Controlling

1. Open an order
2. Click **Controlling** tab
3. View budget vs. actuals

## Contracts

Link contracts to orders:

1. Open the order
2. Go to **Verträge** (Contracts)
3. Add contract details:
    - Start/end dates
    - Budget
    - Payment terms

## Journal / Comments

Document order progress:

1. Open the order
2. Go to **Journal** tab
3. Add comments with date stamps

Use the journal for:

- Status updates
- Important decisions
- Issues and resolutions

## Order Reports

Generate order reports:

1. Go to **Auswertung** (Evaluation)
2. Filter by order
3. Select date range
4. Export or view

## Bulk Operations

### Copy Order Structure

To create similar orders:

1. Create a new order
2. Manually add positions

!!! tip "Template Orders"
    Create template orders that you copy for new projects.

## Best Practices

### Naming Conventions

```
Client: ACME
Order: WEB (Website Redesign)
Position: DEV (Development)
→ Full code: ACME-WEB-DEV
```

### Position Granularity

- **Too few**: Can't analyze where time went
- **Too many**: Overhead for time entry
- **Just right**: 3-7 positions per order

### Regular Review

- Check budgets monthly
- Update status when phases complete
- Close finished positions

## Common Issues

??? question "Cannot create order"
    - Check your user role (need Order Manager)
    - Verify client exists

??? question "Position not showing in search"
    - Ensure order is not closed
    - Check position is not closed
    - Verify you're in the order team

??? question "Budget exceeded"
    - Review time entries for errors
    - Discuss scope with project lead
    - Consider budget extension

