# Usage guide for the database layer (PostgreSQL 16).


## Overview

The `db/` directory contains everything required to stand up, evolve, and validate the project’s PostgreSQL persistence layer. With a single command you can spin up a local database identical to CI, apply migrations, and seed test data.

## 1. Prerequisites

* Docker v24+ (Engine & Compose v2)
* GNU Make v4+ (optional)
* Node.js v20+ (for cross-project scripts)

## 2. Quick Start

From project root:

```
cd db  
cp .env.example .env  
docker compose up -d  
```

*By default, the entrypoint applies all migrations in `migrations/` then runs schema and seed scripts.*

### Manual Steps

If you need to run scripts individually:

```
docker exec -it fullstack_baseline_db \
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -f /docker-entrypoint-initdb.d/migrations/20250609120000_initial_schema.sql

docker exec -it fullstack_baseline_db \
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -f /docker-entrypoint-initdb.d/schema/01_create_extensions.sql

docker exec -it fullstack_baseline_db \
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -f /docker-entrypoint-initdb.d/schema/02_create_tables.sql

docker exec -it fullstack_baseline_db \
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -f /docker-entrypoint-initdb.d/schema/03_create_indexes.sql

docker exec -it fullstack_baseline_db \
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -f /docker-entrypoint-initdb.d/seed/01_seed_reference_data.sql

docker exec -it fullstack_baseline_db \
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -f /docker-entrypoint-initdb.d/seed/02_seed_sample_users.sql
```

## 3. Directory Walk-through

| Path               | Purpose                                                       |
| ------------------ | ------------------------------------------------------------- |
| Dockerfile         | Builds PostgreSQL image and copies initialization scripts     |
| docker-compose.yml | Defines `db` service, mounts volumes, configures healthchecks |
| .env.example       | Sample environment variables—copy to `.env`                   |
| migrations/        | Forward-only, timestamped SQL migration files                 |
| scripts/schema/    | Ordered DDL scripts (extensions, tables, indexes)             |
| scripts/seed/      | Idempotent SQL seed scripts for reference and sample data     |

## 4. Regenerating the Image

```
docker compose down  
docker compose build --no-cache db  
docker compose up -d  
```

## 5. Schema Objects (snapshot)

* `user_account`
* `profile`
* *List updated via PR reviews*

## 6. Smoke Test

In `psql`, run:

```
SELECT COUNT(*) FROM user_account;
```

Expected output: number of rows inserted by `01_seed_reference_data.sql`.

---

Questions? Contact **@Bobwares** on Slack (#backend-infra).
