# Architecture Review

> Analysis conducted December 2024 on PuzzleTime v2.15.2

---

## Strengths

### 1. Clean Domain Layer Separation

The `app/domain/` directory (104 files) is excellent. Business logic is properly extracted from controllers and models into dedicated modules like `Billing::Report`, `Order::Cockpit`, `Plannings::Board`. This prevents fat models/controllers and makes the codebase more testable.

### 2. Well-Structured Hierarchical Model

The `WorkItem` tree pattern is clever — using a single polymorphic tree to represent Client → Category → Order → AccountingPost keeps the data model flexible while maintaining clear hierarchy. The `path_ids`, `path_shortnames`, and `path_names` denormalization is a pragmatic performance optimization.

### 3. Proper Use of STI

Using Single Table Inheritance for `Worktime` → `Ordertime`/`Absencetime` is appropriate here since they share the same table structure but have different behavior.

### 4. DRY CRUD Framework

The custom `dry_crud/` controllers with concerns like `Searchable`, `Sortable`, `Rememberable` reduce boilerplate across 60+ controllers.

---

## Areas for Improvement

### 1. Legacy Frontend Stack

- **CoffeeScript** is deprecated (34 files)
- **Bootstrap 3 Sass** is outdated (Bootstrap 5 is current)
- **jQuery/Turbolinks** vs modern alternatives (Hotwire/Stimulus which ships with Rails 7)

The frontend is stuck in 2015-era Rails conventions. A modernization to Hotwire + Stimulus + modern CSS would significantly improve maintainability.

### 2. Mixed Responsibilities in Models

Some models have a lot going on — `Employee` has 25+ attributes including personal data, auth fields, and preferences. Consider extracting `EmployeeProfile` or using concerns more aggressively.

### 3. No Service Objects Pattern

While the domain layer exists, there's no consistent service object pattern. Forms like `Forms::WorktimeEdit` exist but aren't used uniformly. Complex operations are split between controllers, domain classes, and models.

### 4. API is Underdeveloped

Only `employees#index` and `employees#show` are exposed. For a time tracking app, you'd expect full CRUD on worktimes, plannings, etc. The JSON:API setup is there but underutilized.

### 5. Configuration Complexity

`config/settings.yml` at 198 lines with heavy ERB templating is hard to reason about. Consider splitting into feature-specific config files or using Rails credentials.

### 6. Test Coverage Structure

The test directory mirrors the app structure well, but there's no obvious integration/E2E test setup beyond `test/integration/`. For a business-critical time tracking app, more comprehensive workflow tests would be beneficial.

---

## Architectural Debt Summary

| Issue | Severity | Effort |
|-------|----------|--------|
| CoffeeScript → ES6/TypeScript migration | Medium | High |
| Bootstrap 3 → 5 upgrade | Medium | Medium |
| jQuery → Stimulus migration | Low-Medium | Medium |
| No API versioning strategy beyond `/v1/` | Low | Low |
| Tight coupling to specific CRM/invoicing services | Low | Medium |

---

## Overall Assessment

**Rating: B+**

This is a mature, well-maintained Rails application that follows established patterns from its era (Rails 5 origins, now upgraded to 7). The domain layer separation shows thoughtful design. The main technical debt is frontend-related — the backend architecture is solid.

For a 19-year-old codebase (2006-2025), it's in remarkably good shape and has clearly been maintained and upgraded over time. The biggest opportunity is frontend modernization to align with Rails 7 conventions.

---

## Recommendations

### Short-term (Low effort, high impact)

1. **Expand API coverage** — Add worktime and planning endpoints for mobile/integration use cases
2. **Split settings.yml** — Break into `auth.yml`, `integrations.yml`, `defaults.yml`
3. **Add E2E tests** — Cover critical paths: time entry, invoice generation, planning

### Medium-term (Moderate effort)

1. **Migrate CoffeeScript to ES6** — Can be done incrementally, file by file
2. **Introduce Stimulus** — Start with new interactive components, gradually replace jQuery
3. **Extract Employee concerns** — `Authenticatable`, `Employable`, `Contactable`

### Long-term (Strategic)

1. **Bootstrap 5 upgrade** — Requires significant view changes but improves accessibility and mobile UX
2. **Hotwire adoption** — Replace Turbolinks + jQuery AJAX with Turbo Frames/Streams
3. **GraphQL consideration** — For complex reporting queries, may be more flexible than REST

---

## Architecture Diagrams

See also:
- `doc/architecture/05_bausteinsicht.md` — Core model diagram
- `doc/architecture/03_kontextabgrenzung.md` — System context
- Run `rake erd` to generate current database ERD

