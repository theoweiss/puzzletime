# Clients

Clients (Kunden) represent your customers and organizations in PuzzleTime.

## Client Hierarchy

```
Client
  ├── Orders (Projects)
  ├── Contacts
  ├── Billing Addresses
  └── Contracts
```

## Creating Clients

1. Navigate to **Kunden** (Clients)
2. Click **+ erstellen**
3. Fill in:

| Field | Required | Description |
|-------|----------|-------------|
| Name | Yes | Full company name |
| Kurzname | Yes | Short code (3-5 chars) |
| Branche | No | Industry sector |

4. Click **Speichern**

## Client Details

### Basic Information

| Field | Description |
|-------|-------------|
| Name | Legal company name |
| Kurzname | Short code for references |
| Branche | Industry classification |
| Website | Company website |
| Notes | Internal notes |

### Contacts

Add key people at the client:

1. Open client
2. Go to **Kontakte** tab
3. Click **+ erstellen**
4. Enter contact details:
    - Name
    - Email
    - Phone
    - Role/Function

### Billing Addresses

Configure where invoices go:

1. Open client
2. Go to **Rechnungsadressen** tab
3. Add billing address(es)

## Sectors (Branchen)

Categorize clients by industry:

| Sector | Examples |
|--------|----------|
| IT | Software, Hardware |
| Finance | Banks, Insurance |
| Healthcare | Hospitals, Pharma |
| Manufacturing | Production, Engineering |
| Public | Government, NGO |

### Managing Sectors

Administrators can manage sectors:

1. Go to **Branchen** (admin menu)
2. Add/edit/remove sectors

## Client Reports

View all work for a client:

1. Go to **Auswertung** (Evaluation)
2. Filter by client
3. Select date range
4. View time breakdown

### Client Overview

The client list shows:

| Column | Meaning |
|--------|---------|
| Orders | Number of active orders |
| Total Hours | All time recorded |
| Open Amount | Unbilled revenue |

## Managing Clients

### Editing Clients

1. Click on client name
2. Modify fields
3. Click **Speichern**

### Deactivating Clients

Clients cannot be deleted if they have orders. Instead:

1. Close all orders
2. Mark client as inactive (if feature available)

!!! note
    Historical data is preserved for reporting.

## Best Practices

### Naming Conventions

| ✓ Good | ✗ Bad |
|--------|-------|
| `Acme Corporation` | `acme` |
| `ACME` (short) | `Acme Corp.` |

### Short Codes

- 3-5 uppercase letters
- Unique across all clients
- Memorable abbreviation

```
Acme Corporation → ACME
Swiss Federal Railways → SBB
Example Consulting → EXCO
```

### Contact Management

- Add primary contact first
- Include project-specific contacts
- Keep contact info updated

## Integration

### CRM Sync

If connected to a CRM:

- Clients sync automatically
- Don't edit synced fields
- Use CRM ID for reference

### Invoicing

Billing addresses link to invoicing:

1. Create order for client
2. Add positions with rates
3. Generate invoice
4. Invoice goes to billing address

## Common Issues

??? question "Cannot delete client"
    Clients with orders cannot be deleted. Close all orders first, or mark inactive.

??? question "Duplicate client"
    - Search before creating
    - Check short codes
    - Merge if duplicates exist (admin task)

??? question "Missing in dropdown"
    - Client might be inactive
    - Check search spelling
    - Verify client was saved

