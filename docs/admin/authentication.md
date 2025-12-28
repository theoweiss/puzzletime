# Authentication

PuzzleTime supports multiple authentication methods.

## Overview

| Method | Use Case |
|--------|----------|
| Database | Standalone, small teams |
| LDAP | Enterprise directory |
| Keycloak/OIDC | Modern SSO |
| SAML | Enterprise federation |

## Database Authentication

The simplest option — users are stored locally.

### Configuration

```bash
# .env.prod
AUTH_DB_ACTIVE=true
```

### Creating Users

1. Go to **Mitarbeiter**
2. Create employee with password
3. User logs in with shortname + password

### Password Requirements

Passwords should be:

- At least 8 characters
- Mix of letters and numbers

## LDAP Authentication

Connect to an LDAP directory (Active Directory, OpenLDAP).

### Configuration

```bash
# .env.prod
AUTH_DB_ACTIVE=false

# LDAP Server
LDAP_HOST=ldap.example.com
LDAP_PORT=636

# Encryption
LDAP_ENCRYPTION=simple_tls  # or start_tls, plain

# Bind credentials
LDAP_BIND_DN=cn=admin,dc=example,dc=com
LDAP_BIND_PASSWORD=secret

# User search
LDAP_BASE_DN=ou=users,dc=example,dc=com
LDAP_FILTER=(objectClass=person)

# Attribute mapping
LDAP_ATTR_UID=uid
LDAP_ATTR_MAIL=mail
LDAP_ATTR_FIRSTNAME=givenName
LDAP_ATTR_LASTNAME=sn
```

### How It Works

1. User enters shortname + password
2. PuzzleTime binds to LDAP
3. Searches for user
4. Validates password
5. Creates/updates local employee record
6. User is logged in

### Active Directory Example

```bash
LDAP_HOST=ad.example.com
LDAP_PORT=636
LDAP_ENCRYPTION=simple_tls
LDAP_BIND_DN=CN=svc_puzzletime,OU=Service Accounts,DC=example,DC=com
LDAP_BIND_PASSWORD=service-password
LDAP_BASE_DN=OU=Users,DC=example,DC=com
LDAP_FILTER=(objectClass=user)
LDAP_ATTR_UID=sAMAccountName
```

### OpenLDAP Example

```bash
LDAP_HOST=ldap.example.com
LDAP_PORT=636
LDAP_ENCRYPTION=simple_tls
LDAP_BIND_DN=cn=admin,dc=example,dc=com
LDAP_BIND_PASSWORD=admin-password
LDAP_BASE_DN=ou=people,dc=example,dc=com
LDAP_FILTER=(objectClass=inetOrgPerson)
LDAP_ATTR_UID=uid
```

## Keycloak / OIDC

Modern single sign-on with OpenID Connect.

### Configuration

```bash
# .env.prod
AUTH_DB_ACTIVE=false

KEYCLOAK_ENABLED=true
KEYCLOAK_REALM=puzzletime
KEYCLOAK_SITE=https://auth.example.com
KEYCLOAK_CLIENT_ID=puzzletime
KEYCLOAK_CLIENT_SECRET=your-client-secret
```

### Keycloak Setup

1. Create a new realm (or use existing)
2. Create a client:
    - Client ID: `puzzletime`
    - Access Type: `confidential`
    - Valid Redirect URIs: `https://time.example.com/*`
3. Copy the client secret
4. Configure attribute mappings

### Login Flow

1. User clicks "Login with Keycloak"
2. Redirected to Keycloak
3. Authenticates (password, 2FA, etc.)
4. Redirected back with token
5. Employee record created/updated
6. User is logged in

## SAML Authentication

Enterprise SAML 2.0 federation.

### Configuration

```bash
# .env.prod
AUTH_DB_ACTIVE=false

SAML_ENABLED=true
SAML_IDP_METADATA_URL=https://idp.example.com/metadata
SAML_SP_ENTITY_ID=https://time.example.com/saml
SAML_ACS_URL=https://time.example.com/auth/saml/callback
```

### SAML Setup

1. Get IdP metadata URL
2. Register PuzzleTime as Service Provider
3. Configure attribute mapping
4. Exchange certificates

## Multiple Methods

You can enable multiple auth methods:

```bash
AUTH_DB_ACTIVE=true        # Allow local passwords
KEYCLOAK_ENABLED=true      # AND allow Keycloak SSO
```

Users can choose their login method.

## Attribute Mapping

Map directory attributes to PuzzleTime fields:

| PuzzleTime | LDAP | Keycloak | SAML |
|------------|------|----------|------|
| shortname | uid | preferred_username | NameID |
| email | mail | email | email |
| firstname | givenName | given_name | firstName |
| lastname | sn | family_name | lastName |

## First Login

When users first log in via SSO:

1. Employee record is created automatically
2. Attributes synced from directory
3. Default settings applied
4. Admin may need to assign roles

## Troubleshooting

### LDAP Issues

```bash
# Test LDAP connection
docker compose exec web bin/rails console
```

```ruby
ldap = Net::LDAP.new(
  host: 'ldap.example.com',
  port: 636,
  encryption: :simple_tls
)
ldap.bind(
  method: :simple,
  username: 'cn=admin,dc=example,dc=com',
  password: 'secret'
)
puts ldap.get_operation_result
```

### Keycloak Issues

- Check redirect URIs in Keycloak
- Verify client secret
- Check browser console for errors
- Review Rails logs

### Certificate Problems

For self-signed certificates:

```bash
# Add CA certificate (Dockerfile)
COPY your-ca.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates
```

## Security Best Practices

### LDAP

- Use TLS (port 636) not plain (389)
- Use service account with minimal permissions
- Rotate bind password regularly

### Keycloak/OIDC

- Use confidential client
- Rotate client secret
- Enable PKCE if supported

### General

- Enforce strong passwords
- Enable MFA where possible
- Review login logs
- Disable inactive accounts

## Common Issues

??? question "LDAP connection refused"
    - Check host and port
    - Verify firewall rules
    - Test with `ldapsearch` or similar

??? question "User not found in LDAP"
    - Check base DN
    - Verify filter syntax
    - Test search manually

??? question "Keycloak redirect error"
    - Check Valid Redirect URIs
    - Verify DOMAIN matches
    - Check for HTTPS/HTTP mismatch

??? question "Attributes not syncing"
    - Check attribute mapping
    - Verify attributes exist in source
    - Check logs for mapping errors

