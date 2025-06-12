# Database AI Coding Agent Context

## Purpose

This document equips AI coding agents with the context, conventions, constraints, and prompt templates needed to generate, modify, and validate code in the /db directory reliably and consistently. 

It includes specific instructions for converting JSON schemas into normalized SQL CREATE TABLE statements, ensuring database migrations, schemas, and seed scripts align with the project’s persistence layer requirements.


## Application Overview

The /db directory defines the persistence layer for the project, supporting a PostgreSQL database for the backend and frontend applications. 
   
Key components include:

- Dockerfile: Configures the PostgreSQL container.
- docker-compose.yml: Defines services for local development.
- .env: Template for environment variables.
- migrations/: Timestamped, forward-only SQL migration scripts.
- scripts/schema/: Ordered DDL scripts for base schema.
- scripts/seed/: Idempotent scripts for seeding reference and sample data.

## Technology Stack

- Container: Docker (v24+) & Docker Compose (v2.x)
- Database: PostgreSQL (v16)
- Scripting: Bash for execution scripts
- Environment: Configured via .env 
- example:
  POSTGRES_USER=postgres
  POSTGRES_PASSWORD=password
  POSTGRES_DB=customer_db


## Coding Style & Conventions

**Directory Layout**

- All database-related files reside in /db/.
- migrations/: Forward-only migration scripts (e.g., 20250610120000_add_table.sql).
- scripts/schema/: Ordered DDL scripts (e.g., 01_create_customers.sql).
- scripts/seed/: Idempotent seed scripts (e.g., 01_seed_customers.sql).


**Metadata Headers**

Every SQL and Bash script must include a metadata header.

Format:-- App: <project-name>
-- Package: db
-- File: <filename>
-- Version: 2.0.29
-- Author: AI Agent
-- Date: <YYYY-MM-DD>
-- Description: <Brief purpose of the script>


**Naming Conventions**

Migrations: YYYYMMDDHHMMSS_<slug>.sql (e.g., 20250610120000_create_customers.sql).
Schema Scripts: NN_<description>.sql (e.g., 01_create_customers.sql), where NN is a two-digit sequence.
Seed Scripts: NN_<description>.sql (e.g., 01_seed_customers.sql).
Use lowercase and underscores for slugs and descriptions.
For JSON-derived tables, use singular nouns (e.g., customer, order_item).


**Idempotency**

Seed scripts must use INSERT ... ON CONFLICT DO NOTHING.
DDL scripts must use CREATE TABLE IF NOT EXISTS or ALTER TABLE ... ADD COLUMN IF NOT EXISTS.
Migrations should check for existing objects to avoid errors.


**Testing**

Include SQL smoke tests as comments at the end of migration and seed scripts.
Example:-- Smoke test: SELECT COUNT(*) FROM customers WHERE archived = FALSE;

Validate migrations and seeds in CI using make db-test (see /db/Makefile).


**SQL Style**

Use uppercase for SQL keywords (e.g., SELECT, CREATE TABLE).
Align columns and constraints for readability.
Include indexes for frequently queried columns (e.g., CREATE INDEX ...).
For JSON-derived schemas, infer data types (e.g., VARCHAR, INT, DECIMAL) and add constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE).



## Architectural Constraints

**Environment Parity**

Local, CI, and production environments must use PostgreSQL v16.
Use the same docker-compose.yml configuration across environments.


**Forward-Only Migrations**

Never modify existing migration files; create new ones for changes.
Ensure migrations are safe to run sequentially.


**Secrets Management**

Store credentials in .env (e.g., DATABASE_URL=postgres://user:password@localhost:5432/mydb).
Never commit sensitive data to version control.


**CI Integration**

Migrations and seeds must execute non-interactively in CI pipelines.
Provide a Bash script (scripts/exec-all.sh) to run migrations and seeds sequentially.
Ensure scripts exit with appropriate status codes (0 for success, non-zero for failure).


**Isolation**

The PostgreSQL container exposes port 5432 only to localhost or Docker network.
Use environment variables to configure access (e.g., POSTGRES_HOST).


**Performance**

Add indexes for columns used in WHERE, JOIN, or ORDER BY clauses.
Normalize tables to reduce redundancy, especially for JSON-derived schemas.
Avoid complex triggers; prefer application-level logic.

## JSON to SQL Transformation

This section provides instructions for AI agents to convert JSON schemas into normalized PostgreSQL CREATE TABLE statements, inspired by AI2SQL’s JSON to SQL Transformer (https://ai2sql.io/json-to-sql-transformer). The goal is to generate robust, normalized schemas that handle nested objects, arrays, and relationships.

### Key Principles

**Automatic Schema Detection:**

Infer data types from JSON values (e.g., string → VARCHAR, number → INT or DECIMAL, boolean → BOOLEAN).
Identify primary keys (e.g., id fields) and foreign keys based on relationships.
Detect unique constraints for fields like email.


**Comprehensive JSON Support:**

Map nested objects to separate tables with foreign keys.
Convert arrays to related tables (e.g., order.items → order_items).
Handle multi-level nesting and circular references by normalizing into flat tables.


**Optimization**

Normalize to at least 3NF to reduce redundancy.
Generate indexes for frequently queried columns.
Use constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE) to ensure data integrity.


**Customization**

Use PostgreSQL v16 dialect.
Follow project naming conventions (singular table names, lowercase with underscores).
Allow denormalization for simpler schemas if specified.


## Best Practices

**Prepare JSON Input**

- Ensure consistent key names (e.g., avoid mixing camelCase and snake_case).
- Validate JSON for completeness and correct structure.


**Optimize SQL Output**

- Use appropriate data types (e.g., DECIMAL(10,2) for prices).
- Add indexes for foreign keys and queryable fields.
- Include NOT NULL constraints where applicable.


**Validate Results**

- Test schemas in a staging database using docker-compose up -d db.
- Verify data integrity with smoke tests.
- Check relationships with sample queries (e.g., SELECT * FROM orders JOIN customers ON orders.customer_id = customers.customer_id).


## Example

Convert a JSON schema for an order domain into normalized PostgreSQL tables.

JSON Schema:
```
{
    "order": {
        "id": "12345",
        "customer": {
            "id": "C789",
            "name": "John Doe",
            "email": "john@example.com"
        },
        "items": [
            {
                "product_id": "P1",
                "name": "Laptop",
                "price": 999.99,
                "quantity": 1
            },
            {
                "product_id": "P2",
                "name": "Mouse",
                "price": 24.99,
                "quantity": 2
            }
        ],
        "shipping_address": {
            "street": "123 Main St",
            "city": "Boston",
            "state": "MA",
            "zip": "02108"
        }
    }
}


```


**Expected Output**:

```sql
-- App: <project-name>
-- Package: db
-- File: 20250610120000_create_order_tables.sql
-- Version: 2.0.29
-- Author: AI Agent
-- Date: 2025-06-10
-- Description: Creates normalized tables for the order domain from JSON schema

-- Customer table
CREATE TABLE IF NOT EXISTS customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_customer_email ON customer (email);

-- Address table
CREATE TABLE IF NOT EXISTS address (
    address_id BIGSERIAL PRIMARY KEY,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip VARCHAR(20) NOT NULL
);

-- Order table
CREATE TABLE IF NOT EXISTS order (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    address_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE INDEX IF NOT EXISTS idx_order_customer_id ON order (customer_id);
CREATE INDEX IF NOT EXISTS idx_order_address_id ON order (address_id);

-- Product table
CREATE TABLE IF NOT EXISTS product (
    product_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- Order item table
CREATE TABLE IF NOT EXISTS order_item (
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_time DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES order(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Sample data insertion
INSERT INTO customer (customer_id, name, email)
VALUES ('C789', 'John Doe', 'john@example.com')
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO address (street, city, state, zip)
VALUES ('123 Main St', 'Boston', 'MA', '02108')
ON CONFLICT DO NOTHING;

INSERT INTO order (order_id, customer_id, address_id)
SELECT '12345', 'C789', address_id
FROM address
WHERE street = '123 Main St' AND city = 'Boston'
ON CONFLICT (order_id) DO NOTHING;

INSERT INTO product (product_id, name, price)
VALUES
    ('P1', 'Laptop', 999.99),
    ('P2', 'Mouse', 24.99)
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO order_item (order_id, product_id, quantity, price_at_time)
VALUES
    ('12345', 'P1', 1, 999.99),
    ('12345', 'P2', 2, 24.99)
ON CONFLICT (order_id, product_id) DO NOTHING;

-- Smoke test: Verify order relationships
-- SELECT o.order_id, c.name, a.street, COUNT(oi.product_id) as item_count
-- FROM order o
-- JOIN customer c ON o.customer_id = c.customer_id
-- JOIN address a ON o.address_id = a.address_id
-- LEFT JOIN order_item oi ON o.order_id = oi.order_id
-- WHERE o.order_id = '12345'
-- GROUP BY o.order_id, c.name, a.street;

Example 2: Add Column Migration
Prompt:
### Context
Add archiving support to the customer_preference table.
Tech: PostgreSQL 16, Plain SQL, Docker
Env: { POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, DATABASE_URL }
Project: <project-name>
Directory: /db

### Task
Create a migration in `db/migrations/20250610130000_add_archived_to_customer_preference.sql` that:
- Adds a BOOLEAN column `archived` with DEFAULT FALSE to `customer_preference`
- Backfills existing rows with FALSE
- Includes a metadata header and smoke test query

### Constraints
- Use ALTER TABLE ... ADD COLUMN IF NOT EXISTS
- Forward-only migration
- Follow SQL style conventions
- Include index if column is queryable

### Output Format
```sql
<Complete SQL file content>


**Expected Output**:
```sql
-- App: <project-name>
-- Package: db
-- File: 20250610130000_add_archived_to_customer_preference.sql
-- Version: 2.0.29
-- Author: AI Agent
-- Date: 2025-06-10
-- Description: Adds archived BOOLEAN column to customer_preference table

BEGIN TRANSACTION;

ALTER TABLE customer_preference
ADD COLUMN IF NOT EXISTS archived BOOLEAN DEFAULT FALSE;

UPDATE customer_preference
SET archived = FALSE
WHERE archived IS NULL;

CREATE INDEX IF NOT EXISTS idx_customer_preference_archived
ON customer_preference (archived);

COMMIT;

-- Smoke test: SELECT COUNT(*) FROM customer_preference WHERE archived = FALSE;

Example 3: Seed Script
Prompt:
### Context
Seed initial customer data for development.
Tech: PostgreSQL 16, Plain SQL, Docker
Env: { POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, DATABASE_URL }
Project: <project-name>
Directory: /db

### Task
Create a seed script in `db/scripts/seed/01_seed_customers.sql` that:
- Inserts 3 sample customers into the `customer` table (columns: customer_id, name, email)
- Ensures idempotency using ON CONFLICT DO NOTHING
- Includes a metadata header and smoke test query

### Constraints
- Use INSERT ... ON CONFLICT
- Follow SQL style conventions
- Include realistic sample data
- Include timestamps in UTC

### Output Format
```sql
<Complete SQL file content>


**Expected Output**:
```sql
-- App: <project-name>
-- Package: db
-- File: 01_seed_customers.sql
-- Version: 2.0.29
-- Author: AI Agent
-- Date: 2025-06-10
-- Description: Seeds initial customer data for development

INSERT INTO customer (customer_id, name, email)
VALUES
    ('C001', 'Alice Smith', 'alice@example.com'),
    ('C002', 'Bob Jones', 'bob@example.com'),
    ('C003', 'Carol White', 'carol@example.com')
ON CONFLICT (customer_id) DO NOTHING;

-- Smoke test: SELECT COUNT(*) FROM customer WHERE email LIKE '%@example.com';

```

## Best Practices for AI Agents

Context Awareness

Review existing files in /db/migrations/, /db/scripts/schema/, and /db/scripts/seed/ to avoid duplication.
Check .env.example for environment variable names.
For JSON schemas, align with schemas/ or existing tables (e.g., customer, customer_preference).


Prompt Specificity

Include exact file paths, table/column names, and JSON schema details.
Specify idempotency, constraints, and smoke tests.
For JSON-to-SQL, provide the full JSON schema and desired normalization level.


Validation

Validate SQL syntax for PostgreSQL v16 using linters or local testing.
Test JSON-derived schemas with docker-compose up -d db and npm run migrate.
Verify relationships and data integrity with sample queries.


Error Handling

Use IF NOT EXISTS for DDL operations.
Wrap migrations in BEGIN TRANSACTION and COMMIT for atomicity.
Log potential errors in comments (e.g., -- Error if table missing: ...).


Iterative Refinement

Refine prompts with specific feedback (e.g., “Add missing foreign key” or “Use DECIMAL for prices”).
Cross-check JSON-derived tables against existing migrations to avoid conflicts.


JSON to SQL Specifics

Infer data types accurately (e.g., strings → VARCHAR(255), numbers → INT or DECIMAL).
Map nested objects to separate tables with foreign keys.
Convert arrays to related tables with composite primary keys.
Add indexes for foreign keys and queryable fields.
Validate JSON structure before conversion (consistent keys, no missing values).

