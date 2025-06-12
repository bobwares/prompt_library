# Ticket 02 – Create set of test data

**Description**
Leverage the task definition in `project_root/db/tasks/TASK - DB - JSON to SQL Transformation.md` to transform the **Customer Domain** JSON schema into a fully normalized PostgreSQL 16 schema. The deliverable is a timestamped migration that:

* Resides at `db/migrations/20250610120000_create_customer_tables.sql`.
* Starts with a full metadata header (title, author, date, description, tech stack).
* Produces tables in 3ⁿᵈ Normal Form with singular names (e.g., `customer`, `customer_address`, `customer_contact`).
* Infers column data types, primary and foreign keys, unique constraints, and indexes.
* Decomposes nested objects into separate tables linked by foreign keys.
* Converts any array properties into child tables with many-to-one relationships.
* Includes representative `INSERT` statements for smoke-testing.
* Ends with self-contained smoke tests that assert row counts and key integrity.

**Inputs**

* `project_root/db/tasks/TASK - DB - JSON to SQL Transformation.md`
* `project_root/schemas/customer_domain.json`

**Expected Outputs**

* `project_root/db/migrations/NN_create_customer_tables.sql`
* `project_root/db/scripts/seed/NN_customer_data.sql`
* `project_root/db/test/customer_tables_smoke.sql`
* Update to `project_root/db/README.md` under the “Migrations” section

**Workflow Outline**

1. **Review the DB task file** to confirm conventions, timestamp rules, and required header fields.
2. **Parse the customer JSON schema** to derive an entity-relationship outline (e.g., `customer`, `customer_address`, `customer_contact`, etc.).
3. **Draft SQL** with all constraints and indexes (`btree` on foreign keys, `GIN` or `btree` on heavily-queried columns).
4. **Add representative data** matching the schema for smoke testing.
5. **Append smoke-test queries** ensuring row counts and referential integrity.
6. **Validate locally** in Docker, commit, and open a pull request on branch `task-01-json-to-sql-customer-migration`.

**Acceptance Criteria**
* Expected Outputs were created.
* Each file contains a metadata header block.
* Uses `CREATE TABLE IF NOT EXISTS` statements valid for PostgreSQL 16.
* Implements all keys, constraints, and indexes required by the JSON schema.
* Naming conventions, timestamp format, and directory layout match project standards.
* `project_root/db/README.md` gains a short “Customer Domain Migration” section describing how to execute the migration and smoke tests locally.

