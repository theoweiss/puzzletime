# First Steps

This guide walks you through your first session with PuzzleTime — from logging in to recording your first hours.

## Understanding the Structure

PuzzleTime organizes work in a hierarchy:

```
Client (Customer)
  └── Order (Project)
        └── Accounting Post (Position)
```

**Employees** record time against **Accounting Posts**, which belong to **Orders**, which belong to **Clients**.

## 1. Logging In

1. Open PuzzleTime in your browser
2. Enter your **shortname** (e.g., `MW`) and **password**
3. Click **Login**

!!! tip "Default Users"
    If you seeded the database, try: `MW` / `a` or `PZ` / `a`

## 2. The Dashboard

After login, you'll see the **time recording** view:

| Section | Purpose |
|---------|---------|
| Week tabs | Navigate between weeks |
| Time entries | Your recorded hours |
| Quick entry | Add new time records |

## 3. Create Your First Client

Before recording time, you need a client and an order.

1. Click **Kunden** (Clients) in the menu
2. Click **+ erstellen** (Create)
3. Fill in:
    - **Name**: Company name (e.g., "Acme Corporation")
    - **Kurzname**: Short code (e.g., "ACME")
4. Click **Speichern** (Save)

## 4. Create an Order

Orders represent projects or ongoing work.

1. Click **Aufträge** (Orders)
2. Click **+ erstellen**
3. Fill in:

| Field | Description | Example |
|-------|-------------|---------|
| Kunde | Select client | Acme Corporation |
| Name | Project name | Website Redesign |
| Kurzname | Short code | WEB |
| Art | Work type | Projekt |
| Status | Current state | Bearbeitung |
| Auftragsverantwortlicher | Project lead | Your name |

4. Click **Speichern**

## 5. Create an Accounting Post

Accounting Posts are where time gets recorded.

1. From the Order, go to **Positionen**
2. Click **+ erstellen**
3. Fill in:
    - **Name**: Position name (e.g., "Development")
    - **Kurzname**: Short code (e.g., "DEV")
4. Click **Speichern**

!!! tip "Common Positions"
    Create positions like: Development, Design, Meetings, Project Management

## 6. Record Your First Hours

Now you can record time!

1. Go to **Zeiten** (Times)
2. Click **+ Arbeitszeit** (Add work time)
3. Fill in:

| Field | Description |
|-------|-------------|
| Datum | Date worked |
| Von / Bis | Start/end time (optional) |
| Stunden | Hours worked |
| Position | Search: "ACME WEB DEV" |
| Beschreibung | What you did |

4. Click **Speichern**

### Searching for Positions

Type any combination:

- Client: `Acme`
- Order: `WEB`
- Position: `DEV`
- Combined: `ACME WEB` or `Acme Development`

## 7. Record Absences

For vacation, sick leave, or other absences:

1. Click **+ Absenz**
2. Select the absence type
3. Enter date and hours
4. Click **Speichern**

## 8. View Your Time

### Weekly Overview

The main view shows:

- **Target hours**: Expected based on your employment %
- **Recorded hours**: What you've logged
- **Balance**: Over/under target

### Reports

For detailed analysis:

1. Click **Auswertung** (Evaluation)
2. Select time period
3. View by client, order, or position

## Navigation Reference

| English | German | Purpose |
|---------|--------|---------|
| Times | Zeiten | Record hours |
| Orders | Aufträge | Manage projects |
| Clients | Kunden | Manage customers |
| Employees | Mitarbeiter | View team |
| Evaluation | Auswertung | Reports |
| Planning | Planung | Resource planning |

## Common Tasks

### Edit an Entry

1. Click on the entry
2. Modify fields
3. Click **Speichern**

### Delete an Entry

1. Click on the entry
2. Click **Löschen** (Delete)
3. Confirm

## Troubleshooting

??? question "No positions available"
    - Ensure at least one accounting post exists
    - Check the position isn't marked as "closed"

??? question "Cannot book to this position"
    - Verify you're in the order's team
    - Check the order status allows booking

??? question "Login issues"
    - Use your shortname, not email
    - Check caps lock
    - Contact your administrator

## Next Steps

- [Time Tracking Guide](../guide/time-tracking.md) — Advanced time entry
- [Reports](../guide/reports.md) — Generate reports
- [Planning](../guide/planning.md) — Resource planning

