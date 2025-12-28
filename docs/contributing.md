# Contributing

Thank you for your interest in contributing to PuzzleTime!

## Getting Started

### Prerequisites

- Ruby 3.2+
- PostgreSQL 14+
- Node.js 18+
- Docker (optional, for containerized development)

### Development Setup

#### Option 1: Docker (Recommended)

```bash
git clone https://github.com/puzzle/puzzletime.git
cd puzzletime
./bin/dev
```

This starts:

- Rails app on http://localhost:3000
- PostgreSQL database
- Memcached
- Background job worker

#### Option 2: Local Setup

```bash
git clone https://github.com/puzzle/puzzletime.git
cd puzzletime

# Install dependencies
bin/setup

# Start the server
bin/rails server
```

### Default Users

After seeding the database:

| User | Password | Role |
|------|----------|------|
| MW | a | Admin |
| PZ | a | User |

## Making Changes

### Branch Naming

```
feature/short-description
fix/issue-number-description
improve/area-description
```

### Code Style

Follow the existing code style:

- Ruby: Rubocop rules in `.rubocop.yml`
- JavaScript: CoffeeScript conventions
- CSS: SCSS with BEM-like naming

Run linting:

```bash
bin/rubocop
```

### Testing

Run the test suite:

```bash
bin/rails test
```

Run specific tests:

```bash
bin/rails test test/models/employee_test.rb
bin/rails test test/controllers/ordertimes_controller_test.rb
```

## Pull Requests

### Before Submitting

- [ ] Tests pass locally
- [ ] Linting passes
- [ ] Migrations are reversible
- [ ] Documentation updated (if applicable)
- [ ] Changelog entry added (for significant changes)

### PR Description

Include:

- **What**: Brief description of changes
- **Why**: Motivation or issue reference
- **How**: Implementation approach
- **Testing**: How you verified it works

### Review Process

1. Create PR against `master`
2. Automated checks run
3. Maintainer reviews code
4. Address feedback
5. Merge when approved

## Development Guidelines

### Database Migrations

```bash
# Create migration
bin/rails generate migration AddFieldToTable field:type

# Run migrations
bin/rails db:migrate

# Rollback
bin/rails db:rollback
```

### Adding Gems

1. Add to `Gemfile`
2. Run `bundle install`
3. Commit both `Gemfile` and `Gemfile.lock`

### Translations

Translations are in `config/locales/`:

```yaml
# config/locales/en.yml
en:
  activerecord:
    models:
      employee: Employee
    attributes:
      employee:
        firstname: First name
```

## Documentation

### User Documentation

Add to `docs/docs/`:

```bash
docs/
├── getting-started/
├── guide/
├── admin/
└── reference/
```

### Code Documentation

Use YARD-style comments:

```ruby
# Calculates the total hours for the given period.
#
# @param start_date [Date] the start of the period
# @param end_date [Date] the end of the period
# @return [Float] total hours
def total_hours(start_date, end_date)
  # ...
end
```

## Architecture

### Domain Layer

Business logic lives in `app/domain/`:

```ruby
# app/domain/reports/time_report.rb
module Reports
  class TimeReport
    def initialize(employee, period)
      @employee = employee
      @period = period
    end

    def generate
      # Business logic here
    end
  end
end
```

### Controllers

Use DRY CRUD patterns:

```ruby
class MyController < CrudController
  self.permitted_attrs = [:name, :description]
end
```

### Views

Use HAML for templates:

```haml
%h1= @order.name
%table
  %thead
    %tr
      %th Position
      %th Hours
  %tbody
    - @order.accounting_posts.each do |post|
      %tr
        %td= post.name
        %td= post.total_hours
```

## Issue Reporting

### Bug Reports

Include:

- PuzzleTime version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if UI related)

### Feature Requests

Include:

- Use case description
- Proposed solution
- Alternatives considered

## Community

### Communication

- GitHub Issues: Bug reports, feature requests
- GitHub Discussions: Questions, ideas

### Code of Conduct

Be respectful and constructive. See [CODE_OF_CONDUCT.md](https://github.com/puzzle/puzzletime/blob/master/CODE_OF_CONDUCT.md).

## License

By contributing, you agree that your contributions will be licensed under the GNU Affero General Public License v3.

## Acknowledgments

Thank you to all contributors! See [AUTHORS](https://github.com/puzzle/puzzletime/blob/master/AUTHORS).

