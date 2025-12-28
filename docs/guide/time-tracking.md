# Time Tracking

Learn how to effectively record and manage your working time in PuzzleTime.

## Recording Work Time

### Basic Entry

1. Navigate to **Zeiten** (Times)
2. Click **+ Arbeitszeit** (Add work time)
3. Fill in the form:

| Field | Required | Description |
|-------|----------|-------------|
| Datum | Yes | Date of work |
| Von | No | Start time |
| Bis | No | End time |
| Stunden | Yes* | Hours (auto-calculated if times given) |
| Position | Yes | Where to book the time |
| Beschreibung | No | What you worked on |
| Ticket | No | Issue/ticket reference |

4. Click **Speichern**

### Time Entry Modes

PuzzleTime supports two modes:

=== "Duration Only"
    Enter just the hours worked:
    ```
    Stunden: 4.5
    ```

=== "From-To Times"
    Enter start and end times:
    ```
    Von: 09:00
    Bis: 12:30
    ```
    Hours are calculated automatically (3.5h)

### Finding Positions

Use the position search field. Type any combination:

| Search | Matches |
|--------|---------|
| `ACME` | All positions for client ACME |
| `WEB` | All positions with "WEB" in order |
| `DEV` | All positions named "DEV" |
| `ACME WEB DEV` | Specific position |

!!! tip "Favorites"
    Recently used positions appear at the top of search results.

## Recording Absences

For vacation, sick leave, military service, etc.:

1. Click **+ Absenz** (Add absence)
2. Select absence type:
    - Ferien (Vacation)
    - Krankheit (Sick leave)
    - Militär (Military service)
    - And others...
3. Enter date and hours
4. Click **Speichern**

!!! note "Vacation Balance"
    Vacation days are tracked against your annual allowance.

## Weekly View

The main view shows your week at a glance:

### Understanding the Summary

| Metric | Meaning |
|--------|---------|
| **Soll** | Target hours (based on your employment %) |
| **Ist** | Recorded hours |
| **Differenz** | Balance (over/under) |

### Navigating Weeks

- Use **← →** arrows to move between weeks
- Click on a date to jump to that week
- Use the date picker for specific dates

## Editing Entries

### Modify an Entry

1. Click on the entry in your list
2. Change the fields
3. Click **Speichern**

### Delete an Entry

1. Click on the entry
2. Click **Löschen** (Delete)
3. Confirm the deletion

### Split an Entry

If you need to split time across positions:

1. Edit the original entry, reduce hours
2. Create a new entry for the remaining hours

## Bulk Operations

### Copy to Another Day

1. Select an entry
2. Use **Kopieren** (Copy)
3. Select the target date

### Multi-Day Entry

For recurring entries (e.g., daily standup):

1. Create the entry for one day
2. Use the repeat function to copy to multiple days

## Time Validation

PuzzleTime validates your entries:

| Rule | Description |
|------|-------------|
| Max 24h/day | Cannot exceed 24 hours per day |
| Position open | Position must not be closed |
| Valid date | Date must be reasonable |

## Tips for Efficient Tracking

### End of Day Routine

1. Review your day's entries
2. Add missing time
3. Check the daily total matches expectations

### Weekly Review

1. Check weekly balance (Soll vs Ist)
2. Ensure all days are complete
3. Add descriptions for billing clarity

### Using Tickets

Link time entries to tickets for:

- Better traceability
- Easier reporting
- Integration with issue trackers

```
Ticket: PROJ-123
Beschreibung: Implement user authentication
```

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Tab` | Next field |
| `Enter` | Save entry |
| `Esc` | Cancel |

## Common Issues

??? question "Position not found"
    - Check spelling
    - Ensure the order is active (not closed)
    - Verify you have access to the project

??? question "Cannot save entry"
    - Check required fields (Stunden, Position)
    - Verify the date is valid
    - Ensure hours don't exceed 24/day

??? question "Entry disappeared"
    - Check the date filter
    - Look in the correct week
    - Entries might be on a different project

