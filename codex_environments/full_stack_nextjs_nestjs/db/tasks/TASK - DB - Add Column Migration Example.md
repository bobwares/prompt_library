
**Context**:
Add archiving support to the `customer_preference` table.
Tech: PostgreSQL 16, Plain SQL, Docker
Env: { POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, DATABASE_URL }
Project: <project-name>
Directory: /db

**Task**:
Create a migration in
`db/migrations/20250610130000_add_archived_to_customer_preference.sql` that:
- Adds a BOOLEAN column `archived` with `DEFAULT FALSE` to `customer_preference`
- Backfills existing rows with `FALSE`
- Includes a metadata header and smoke test query

**Constraints**:
- Use `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`
- Forward-only migration
- Follow SQL style conventions
- Include index if column is queryable

**Output**:
A complete SQL file with metadata header, `BEGIN TRANSACTION`/`COMMIT`, DDL, backfill, index creation, and smoke test.
