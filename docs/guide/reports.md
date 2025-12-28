# Reports

Generate insights from your time data with PuzzleTime's reporting features.

## Accessing Reports

Navigate to **Auswertung** (Evaluation) in the main menu.

## Report Types

### Time Reports

View time entries with various groupings:

| Grouping | Shows |
|----------|-------|
| By Employee | Each person's hours |
| By Order | Project totals |
| By Client | Customer totals |
| By Position | Task breakdowns |

### Period Selection

Choose your date range:

- **Week**: Current or specific week
- **Month**: Calendar month
- **Quarter**: Q1, Q2, Q3, Q4
- **Year**: Full year
- **Custom**: Any date range

## Employee Reports

### Personal Time

View your own time summary:

1. Go to **Auswertung**
2. Select yourself (default)
3. Choose period
4. View breakdown

Shows:

- Hours per day
- Hours per project
- Work vs. absence
- Target vs. actual

### Team Reports

Managers can view team reports:

1. Select department or team
2. View aggregated hours
3. Drill down to individuals

## Order Reports

### Order Summary

For a specific order:

1. Open the order
2. Go to **Controlling** tab
3. View:
    - Budget vs. actual
    - Burn rate
    - Remaining hours

### Cross-Order Report

Compare multiple orders:

1. Go to **Auswertung**
2. Filter by client
3. Select orders
4. View comparison

## Client Reports

Aggregate all work for a client:

1. Go to **Auswertung**
2. Filter by client
3. Select period
4. View total hours and breakdown

## Financial Reports

### Billable Hours

Track revenue-generating time:

| Metric | Description |
|--------|-------------|
| Billable hours | Time marked as billable |
| Non-billable | Internal, meetings, etc. |
| Rate | Hourly rate per position |
| Revenue | Billable × Rate |

### Invoice Reports

Track invoicing status:

1. Go to **Rechnungen** (Invoices)
2. View invoice status
3. Filter by:
    - Open
    - Sent
    - Paid

## Capacity Reports

Plan and track capacity:

### Utilization

```
Utilization = Billable Hours / Available Hours × 100%
```

### Workload

View team workload:

1. Go to **Planung** (Planning)
2. Select period
3. See capacity vs. planned

## Exporting Reports

### Excel Export

1. Generate your report
2. Click **Export**
3. Choose Excel format
4. Download file

### PDF Export

For printable reports:

1. Generate report
2. Click **PDF**
3. Download or print

### CSV Export

For data analysis:

1. Generate report
2. Click **CSV**
3. Import into tools

## Scheduled Reports

!!! note "Feature Availability"
    Scheduled reports may require configuration.

Set up automatic reports:

1. Configure report parameters
2. Set schedule (weekly, monthly)
3. Add email recipients
4. Reports are sent automatically

## Report Filters

### Common Filters

| Filter | Options |
|--------|---------|
| Employee | One, many, all |
| Department | Select department |
| Client | Select client(s) |
| Order | Select order(s) |
| Position | Select position(s) |
| Date range | Start and end date |

### Saving Filters

Save frequently used filter combinations:

1. Set up your filters
2. Click **Save** (if available)
3. Name the filter set
4. Reuse later

## Reading Reports

### Understanding Columns

| Column | Meaning |
|--------|---------|
| Soll (Target) | Expected hours |
| Ist (Actual) | Recorded hours |
| Differenz | Variance |
| % | Percentage |

### Color Coding

- 🟢 **Green**: On target
- 🟡 **Yellow**: Minor variance
- 🔴 **Red**: Significant variance

## Tips

### Regular Review

- **Daily**: Check your entries
- **Weekly**: Review totals
- **Monthly**: Analyze trends

### Data Quality

Good reports require good data:

- ✓ Enter time daily
- ✓ Use correct positions
- ✓ Add descriptions
- ✓ Track billable correctly

### Report Uses

| Report | Use Case |
|--------|----------|
| Employee time | Timesheets, payroll |
| Order report | Project status |
| Client report | Account review |
| Financial | Revenue tracking |

## Common Issues

??? question "Numbers don't match"
    - Check date filters
    - Verify employee selection
    - Look for missing entries

??? question "Report is empty"
    - Expand date range
    - Check filters
    - Verify data exists

??? question "Cannot export"
    - Check browser pop-up settings
    - Try different format
    - Contact administrator

