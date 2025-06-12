**Context**:  
<Brief summary of the database task>  
Tech: PostgreSQL 16, Plain SQL, Docker  
Env: { POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, DATABASE_URL }  
Project: <project-name>  
Directory: /db

**Task**:  
<Specific instruction, e.g.,>  
Generate a migration to add a BOOLEAN column `archived` to the `customer_preference` table.

**Constraints**:
- File path: db/migrations/YYYYMMDDHHMMSS_<slug>.sql
- Include metadata header with App, Package, File, Version, Author, Date, Description
- Use idempotent SQL (e.g., ADD COLUMN IF NOT EXISTS)
- Include a smoke test query as a comment
- Do not modify existing migrations
- Follow SQL style conventions (uppercase keywords, aligned columns)

**Output Format**:
```
<Complete SQL file content>
````