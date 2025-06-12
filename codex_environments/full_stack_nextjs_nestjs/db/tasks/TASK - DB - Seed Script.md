**Context**:
Seed initial customer data for development.
Tech: PostgreSQL 16, Plain SQL, Docker
Env: { POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, DATABASE_URL }
Project: <project-name>
Directory: /db

**Task**:
Create a seed script in `db/scripts/seed/01_seed_<resource>.sql` that:
- Inserts 10 sample customers into the `customer` table (columns: `customer_id`, `name`, `email`)
- Ensures idempotency using `ON CONFLICT DO NOTHING`
- Includes a metadata header and smoke test query

**Constraints**:
- Use `INSERT ... ON CONFLICT`
- Follow SQL style conventions
- Include realistic sample data
- Include timestamps in UTC

**Inputs**



**Output**:
A complete SQL file with metadata header, `INSERT` statements, and smoke test.