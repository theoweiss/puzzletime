# REST API

PuzzleTime provides a REST API based on the [JSON:API](https://jsonapi.org/) specification.

## Overview

The API provides read access to selected resources:

- Employees
- Orders
- Work Items
- Time Entries

## Authentication

All endpoints are protected with [HTTP Basic Authentication](https://tools.ietf.org/html/rfc2617).

### Configuration

Set credentials via environment variables:

```bash
# .env.prod
API_USER=api
API_PASSWORD=your-secure-api-password
```

### Usage

```bash
curl -u api:your-password https://time.example.com/api/v1/employees
```

Or with header:

```bash
curl -H "Authorization: Basic $(echo -n 'api:password' | base64)" \
     https://time.example.com/api/v1/employees
```

## Base URL

```
https://your-domain.com/api/v1/
```

## Endpoints

### Employees

```http
GET /api/v1/employees
GET /api/v1/employees/:id
```

**Response:**

```json
{
  "data": [
    {
      "id": "1",
      "type": "employees",
      "attributes": {
        "shortname": "MW",
        "firstname": "Max",
        "lastname": "Muster",
        "email": "max@example.com"
      }
    }
  ]
}
```

### Orders

```http
GET /api/v1/orders
GET /api/v1/orders/:id
```

### Work Items

```http
GET /api/v1/work_items
```

Work items represent the hierarchy: Client → Order → Position.

## Pagination

The API uses [Kaminari](https://github.com/kaminari/kaminari) for pagination.

### Query Parameters

| Parameter | Example | Description |
|-----------|---------|-------------|
| `page` | `?page=2` | Select page number |
| `per_page` | `?per_page=100` | Results per page (max 100) |

### Response Headers

| Header | Example | Description |
|--------|---------|-------------|
| `PaginationTotalCount` | `186` | Total number of resources |
| `PaginationPerPage` | `10` | Items per page |
| `PaginationCurrentPage` | `2` | Current page number |
| `PaginationTotalPages` | `19` | Total pages |

### Example

```bash
curl -u api:password "https://time.example.com/api/v1/employees?page=2&per_page=25"
```

## Filtering

Some endpoints support filtering:

```http
GET /api/v1/orders?filter[status]=active
GET /api/v1/employees?filter[department_id]=5
```

## Response Format

### Success Response

```json
{
  "data": [...],
  "meta": {
    "total_count": 42
  },
  "links": {
    "self": "/api/v1/employees?page=1",
    "next": "/api/v1/employees?page=2"
  }
}
```

### Error Response

```json
{
  "errors": [
    {
      "status": "404",
      "title": "Not Found",
      "detail": "Record not found"
    }
  ]
}
```

## HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 422 | Unprocessable Entity |
| 500 | Internal Server Error |

## OpenAPI / Swagger

PuzzleTime includes auto-generated API documentation:

| URL | Description |
|-----|-------------|
| `/api/docs` | Swagger UI |
| `/api/docs/v1` | OpenAPI specification (JSON) |

### Import to Postman

1. Open Postman
2. Import → Link
3. Enter: `https://your-domain.com/api/docs/v1`
4. Import

## Rate Limiting

The API does not currently enforce rate limits, but please be considerate:

- Batch requests where possible
- Cache responses locally
- Avoid polling; use webhooks if available

## Examples

### List All Employees

```bash
curl -u api:password https://time.example.com/api/v1/employees
```

### Get Single Order

```bash
curl -u api:password https://time.example.com/api/v1/orders/42
```

### Paginated Request

```bash
curl -u api:password \
  "https://time.example.com/api/v1/employees?page=1&per_page=50"
```

### With Headers in Response

```bash
curl -i -u api:password https://time.example.com/api/v1/employees

# Response headers include:
# PaginationTotalCount: 186
# PaginationPerPage: 10
# PaginationCurrentPage: 1
# PaginationTotalPages: 19
```

## Client Libraries

### Ruby

```ruby
require 'net/http'
require 'json'

uri = URI('https://time.example.com/api/v1/employees')
req = Net::HTTP::Get.new(uri)
req.basic_auth('api', 'password')

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
  http.request(req)
end

data = JSON.parse(res.body)
```

### Python

```python
import requests

response = requests.get(
    'https://time.example.com/api/v1/employees',
    auth=('api', 'password')
)

data = response.json()
```

### JavaScript

```javascript
const response = await fetch('https://time.example.com/api/v1/employees', {
  headers: {
    'Authorization': 'Basic ' + btoa('api:password')
  }
});

const data = await response.json();
```

## Webhooks

!!! note "Coming Soon"
    Webhooks for real-time updates are planned for a future release.

## Troubleshooting

### 401 Unauthorized

- Check API credentials in environment
- Verify Authorization header format
- Ensure API is enabled

### Empty Response

- Check filters
- Verify pagination
- Ensure data exists

### CORS Issues

For browser-based clients, configure CORS:

```ruby
# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'your-frontend.example.com'
    resource '/api/*', headers: :any, methods: [:get]
  end
end
```

