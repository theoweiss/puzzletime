# User Management

Manage employees and their access to PuzzleTime.

## Employee Overview

Navigate to **Mitarbeiter** (Employees) to see all users.

### Employee List

| Column | Description |
|--------|-------------|
| Name | Full name |
| Kurzzeichen | Short code (login) |
| Abteilung | Department |
| Pensum | Employment percentage |

## Creating Employees

### Database Authentication

When using database auth (`AUTH_DB_ACTIVE=true`):

1. Go to **Mitarbeiter**
2. Click **+ erstellen**
3. Fill in:

| Field | Required | Description |
|-------|----------|-------------|
| Vorname | Yes | First name |
| Nachname | Yes | Last name |
| Kurzzeichen | Yes | Login shortname |
| Email | Yes | Email address |
| Passwort | Yes | Initial password |
| Pensum | Yes | Employment % |
| Abteilung | No | Department |

4. Click **Speichern**

### LDAP/SSO Users

When using LDAP or SSO:

- Users are created automatically on first login
- Sync attributes from directory
- Local fields can be edited

## Employee Details

### Personal Information

| Field | Description |
|-------|-------------|
| Vorname | First name |
| Nachname | Last name |
| Kurzzeichen | Login identifier |
| Email | Email address |
| LDAP-Name | LDAP username (if applicable) |

### Employment

| Field | Description |
|-------|-------------|
| Pensum | Employment percentage (e.g., 80%) |
| Abteilung | Department assignment |
| Eintritt | Start date |
| Austritt | End date (if leaving) |

### Roles

Assign roles to control access:

| Role | Permissions |
|------|-------------|
| Standard | Record own time |
| Order Manager | Create and manage orders |
| Management | Full access, reports |
| Admin | System configuration |

## Departments

Organize employees into departments:

1. Go to **Abteilungen** (Departments)
2. Create departments
3. Assign employees

### Department Hierarchy

```
Company
  ├── Development
  │     ├── Frontend
  │     └── Backend
  ├── Design
  └── Operations
```

## Employment Records

Track employment history:

### Viewing Employments

1. Open employee
2. Go to **Anstellungen** (Employments)
3. View history

### Adding Employment

For new employment periods:

1. Click **+ erstellen**
2. Enter:
    - Start date
    - Employment percentage
    - End date (optional)
3. Save

### Employment Changes

When an employee changes:

- Pensum changes
- Department moves
- Role changes

Create a new employment record with the new values.

## Workload Settings

### Target Hours

Based on:

- Employment percentage
- Working conditions
- Holidays

```
Weekly target = Base hours × Employment %
Example: 42h × 80% = 33.6h
```

### Working Conditions

Configure base hours:

1. Go to **Arbeitsbedingungen**
2. Set hours per week
3. Set vacation days

## Password Management

### Reset Password

Administrators can reset passwords:

1. Open employee
2. Click **Passwort zurücksetzen**
3. Enter new password
4. Communicate to user

### Self-Service

Users can change their own password:

1. Go to profile
2. Click **Passwort ändern**
3. Enter old and new password

## Deactivating Employees

When someone leaves:

1. Open employee
2. Set **Austritt** (end date)
3. Employee becomes inactive after date

!!! note
    Inactive employees:
    - Cannot log in
    - Historical data is preserved
    - Appear in past reports

## Bulk Operations

### Import Employees

For large imports, use the console:

```bash
docker compose exec web bin/rails console
```

```ruby
Employee.create!(
  firstname: 'New',
  lastname: 'User',
  shortname: 'NU',
  email: 'new@example.com',
  password: 'initial-password'
)
```

### Export Employees

Generate employee list:

1. Go to **Mitarbeiter**
2. Click **Export**
3. Download CSV/Excel

## Permissions Matrix

| Action | Standard | Order Manager | Management | Admin |
|--------|----------|---------------|------------|-------|
| Record own time | ✓ | ✓ | ✓ | ✓ |
| View own reports | ✓ | ✓ | ✓ | ✓ |
| Create orders | | ✓ | ✓ | ✓ |
| View team time | | | ✓ | ✓ |
| Manage employees | | | | ✓ |
| System config | | | | ✓ |

## Common Issues

??? question "Cannot create employee"
    - Check required fields
    - Shortname must be unique
    - Email must be unique

??? question "Employee cannot log in"
    - Verify shortname (not email)
    - Check password
    - Verify not past end date
    - Check auth method matches

??? question "Wrong department"
    - Edit employee
    - Change department
    - May need new employment record

