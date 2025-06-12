Below is a **draft backlog of API-side tasks** for the NestJS service in `project_root/api`.
Each task mirrors the markdown layout already used for the database tasks (title, goal, context, acceptance criteria, steps, DoD, references).
Create a separate file for each task under `project_root/api/tasks/` using the listed filename.

---

### Task 01 – Establish API Conventions and Base Configuration

| Field        | Value                                                           |
| ------------ | --------------------------------------------------------------- |
| **Filename** | `Task 01 – Establish API Conventions and Base Configuration.md` |
| **T-Ref**    | —                                                               |

**Goal**
Lock in code-style, linting, testing, ADR, and metadata-header rules for the backend so all subsequent tickets share one baseline.

**Context**
Root **AGENTS.md** defines global rules (metadata header, Conventional Commits, log archiving, ADRs). This task adapts them to NestJS specifics and checks them into `api/` ([github.com][1])

**Acceptance Criteria**

1. `.eslintrc.cjs` and `prettier.config.js` align with agreed style.
2. `jest.config.ts` prepared for unit + e2e layers.
3. `api/README.md` documents “how to run, test, lint.”
4. ADR template copied to `project_root/adr/`.

**Steps**

1. Add/adjust config files.
2. Write **ADR 20250611\_001\_api-base-stack.md** summarising chosen tools.
3. Update CI job to run `npm run lint && npm test`.

**Definition of Done**

* All commands run clean locally.
* CI passes on the feature branch.
* ADR merged.

---

### Task 02 – Configure Environment & PostgreSQL Connection

| Field        | Value                                                        |
| ------------ | ------------------------------------------------------------ |
| **Filename** | `Task 02 – Configure Environment & PostgreSQL Connection.md` |
| **T-Ref**    | —                                                            |

**Goal**
Provide a single source of truth (`ConfigModule` + `.env.example`) for DB credentials and other runtime settings.

**Acceptance Criteria**

* `ConfigModule.forRoot({ isGlobal: true })` set up.
* Database URL read from `process.env.DATABASE_URL`.
* Health-check endpoint `/health` returns DB connectivity status.

**Steps**

1. Install `@nestjs/config`, `@nestjs/terminus`, `pg`.
2. Create `config/database.config.ts` with validation schema.
3. Add `HealthModule` with Terminus check.

**DoD** – `GET /health` returns `{ status: 'ok' }` when DB reachable; task log committed.

---

### Task 03 – Implement Customer Domain CRUD Endpoints (*Ticket 03*)

| Field        | Value                                                   |
| ------------ | ------------------------------------------------------- |
| **Filename** | `Task 03 – Implement Customer Domain CRUD Endpoints.md` |
| **T-Ref**    | Ticket 03                                               |

**Goal**
Expose REST endpoints to Create, Read (list + single), Update, and Delete customers.

**Acceptance Criteria**

| Endpoint         | Method | Behaviour                                         |
| ---------------- | ------ | ------------------------------------------------- |
| `/customers`     | POST   | Creates customer, returns `201-Created` with body |
| `/customers`     | GET    | Returns paginated array                           |
| `/customers/:id` | GET    | Returns one or `404`                              |
| `/customers/:id` | PUT    | Full-update, idempotent                           |
| `/customers/:id` | DELETE | Soft-delete flag                                  |

* DTOs validated with `class-validator`.
* Controller annotated for Swagger.
* Unit tests cover service & controller happy-path + 400/404.

**Steps**

1. `nest g module customer && nest g controller customer && nest g service customer`.
2. Define `CreateCustomerDto`, `UpdateCustomerDto`.
3. Add mapping layer (Entity ↔ DTO).
4. Write Jest tests (use in-memory repo stub for now).

**DoD** – All tests green; OpenAPI shows the five routes.

---

### Task 04 – Persist Customer Data to PostgreSQL (*Ticket 04*)

| Field        | Value                                              |
| ------------ | -------------------------------------------------- |
| **Filename** | `Task 04 – Persist Customer Data to PostgreSQL.md` |
| **T-Ref**    | Ticket 04                                          |

**Goal**
Replace in-memory repository with Postgres persistence using the project’s ORM (TypeORM or Prisma—decide via ADR).

**Acceptance Criteria**

* Customer table mirrors DB DDL produced in db tasks.
* Repository implements CRUD with transactions.
* Integration tests spin up Postgres (Docker) and pass.

**Steps**

1. Choose ORM → write ADR.
2. Generate entity/model.
3. Implement `CustomerRepository`.
4. Add TypeORM migration or Prisma migration.
5. Extend CI with `docker-compose -f infra/db.yml up -d`.

**DoD** – `npm run test:e2e` connects to real Postgres and passes.

---

### Task 05 – Global Validation Pipe & Error Handling

### Task 06 – API Logging & Structured Request Tracing

### Task 07 – Swagger / OpenAPI Documentation Endpoint

### Task 08 – Unit-Test Coverage ≥ 80 % (Service & Controller)

### Task 09 – End-to-End Tests with Supertest

### Task 10 – Seed & Fixture Scripts for Local Dev

### Task 11 – GitHub Actions CI Pipeline (lint → unit tests → build)

### Task 12 – ADR & Changelog Automation Hook

*(Tasks 05-12 follow the same markdown layout; include Goal, Context, Acceptance Criteria, Steps, DoD, References.)*

---

#### Next Steps

1. Copy each task block above into its own markdown file under `api/tasks/`.
2. Number future tasks sequentially.
3. Remember to archive the Codex sandbox log at the end of every turn, as specified in **AGENTS.md**. ([github.com][1])

[1]: https://github.com/bobwares/full-stack-app-nextjs-nestjs-baseline/raw/dev/AGENTS.md "raw.githubusercontent.com"


Below are fully-scoped backlog items **Task 05 – Task 09** in the same markdown template you are using under `project_root/api/tasks/`.
Create one file per task, keeping the numbering sequential.

---

### Task 05 – Global Validation Pipe & Error Handling

| Field        | Value                                                  |
| ------------ | ------------------------------------------------------ |
| **Filename** | `Task 05 – Global Validation Pipe & Error Handling.md` |
| **T-Ref**    | —                                                      |

**Goal**
Guarantee every request is validated and every error is returned in a consistent JSON envelope (`statusCode`, `message`, `error`, `path`, `timestamp`).

**Context**

* Root **AGENTS.md** mandates strict input validation and clear error contracts.
* NestJS ships `ValidationPipe` and supports custom `ExceptionFilter`.
* Down-stream agents (front-end, tests, monitoring) rely on predictable error shapes.

**Acceptance Criteria**

1. `ValidationPipe` registered globally in `bootstrap()` with:

    * `whitelist: true`
    * `forbidNonWhitelisted: true`
    * `transform: true`
2. Custom `HttpExceptionFilter` extends `ExceptionFilter` and formats all thrown or unhandled errors.
3. Unknown routes return a 404 using the same envelope.
4. Unit tests:

    * 400 for bad payload (extra field, missing required).
    * 422 for validation failures (if using class-validator message map).
    * 404 for unknown route.
5. Swagger shows sample error schemas via `ApiExtraModels`.

**Steps**

1. Install `class-validator` and `class-transformer` (already present via earlier tasks).
2. Add `filters/http-exception.filter.ts`; bind via `app.useGlobalFilters()`.
3. Update `main.ts` to register `ValidationPipe`.
4. Write Jest tests for controller happy-path and error-path.
5. Add ADR **20250611\_002\_error-handling.md** to explain envelope choice.

**Definition of Done**

* `npm test` green; coverage for filter ≥ 90 %.
* `curl /unknown` returns JSON envelope.
* ADR merged.

---

### Task 06 – API Logging & Structured Request Tracing

| Field        | Value                                                   |
| ------------ | ------------------------------------------------------- |
| **Filename** | `Task 06 – API Logging & Structured Request Tracing.md` |
| **T-Ref**    | —                                                       |

**Goal**
Provide correlation-friendly, JSON-structured logs that include a per-request ID and latency.

**Context**

* Logs are copied into the repo after every Codex run; structure makes them searchable.
* Observability stack (Elastic / Grafana / CloudWatch Logs) expects JSON lines.

**Acceptance Criteria**

1. Integrate `@nestjs/pino` (or `nestjs-winston`) with pretty printing disabled in non-dev.
2. Middleware injects `X-Request-Id` header (uuid v4) if absent and attaches it to the logger context.
3. For every request, log:

    * `method`, `url`, `statusCode`, `responseTimeMs`, `requestId`.
4. Errors logged at level `error` with stack trace.
5. Configuration toggled via `LOG_LEVEL`, `PRETTY_LOGS`.
6. Unit tests assert that a log entry contains `requestId`.

**Steps**

1. `npm i @nestjs/pino pino-http pino-uuid –save`.
2. Create `LoggingModule` that registers `LoggerModule.forRootAsync()`.
3. Add `RequestIdMiddleware` and `LoggingInterceptor` for timing.
4. Update bootstrap order.
5. Extend CI to archive `./logs/api-YYYYMMDD.log`.

**DoD**

* `GET /health` produces one structured log line.
* `npm run lint` passes.
* Docs updated in `api/README.md`.

---

### Task 07 – Swagger / OpenAPI Documentation Endpoint

| Field        | Value                               |
| ------------ | ----------------------------------- |
| **Filename** | `Task 07 – Swagger OpenAPI Docs.md` |
| **T-Ref**    | —                                   |

**Goal**
Expose interactive API docs (`/docs`), downloadable JSON (`/openapi.json`), and ensure every public route is documented.

**Context**

* Consumers (front-end, Postman collection, contract tests) read the OpenAPI spec.
* **AGENTS.md** requires every endpoint be discoverable.

**Acceptance Criteria**

1. `@nestjs/swagger` configured in `main.ts` with:

    * Title: “Full-Stack API”
    * Version read from `package.json`.
    * Servers: dev (`http://localhost:3000`) & prod (`/`).
2. Swagger module guarded by basic auth in non-dev environments.
3. Swagger decorators (`@ApiTags`, `@ApiResponse`, `@ApiBearerAuth`) added to Customer controller.
4. Script `npm run openapi:export` writes `openapi.json` to `project_root/api/docs/`.
5. CI artifact upload of the JSON spec.

**Steps**

1. `npm i @nestjs/swagger swagger-ui-express`.
2. Add Swagger setup in `main.ts`.
3. Annotate DTOs and controllers.
4. Create Node script `scripts/export-swagger.ts`.
5. Update `api/README.md` with usage instructions.

**DoD**

* Visiting `/docs` shows endpoints & schemas.
* Exported file committed in PR.

---

### Task 08 – Unit-Test Coverage ≥ 80 % (Service & Controller)

| Field        | Value                                                 |
| ------------ | ----------------------------------------------------- |
| **Filename** | `Task 08 – Raise Unit-Test Coverage to 80 percent.md` |
| **T-Ref**    | —                                                     |

**Goal**
Guarantee confident refactoring by enforcing a minimum test-coverage threshold.

**Context**

* Current baseline has unit tests for Customer CRUD but overall coverage is below target.
* CI must fail if coverage slips.

**Acceptance Criteria**

1. `jest.config.ts` updated with `coverageThreshold` (lines, branches, funcs, stmts ≥ 80 %).
2. Additional unit tests written for:

    * Validation pipe behaviour.
    * Error filter mapping.
    * Service edge cases (duplicate email, soft-delete list filtering).
3. Local run of `npm test -- --coverage` prints ≥ 80 % across all metrics.
4. GitHub Actions step caches coverage report as artefact.

**Steps**

1. Identify gaps via `coverage/lcov-report/index.html`.
2. Create new tests in `test/unit/` folders.
3. Push PR and verify CI status.

**DoD**

* Coverage gate enforced in main branch protection rules.
* README badge shows latest percentage.

---

### Task 09 – End-to-End Tests with Supertest

| Field        | Value                                          |
| ------------ | ---------------------------------------------- |
| **Filename** | `Task 09 – End-to-End Tests with Supertest.md` |
| **T-Ref**    | —                                              |

**Goal**
Validate the full HTTP request-to-Postgres stack using real application wiring.

**Context**

* Tickets 03-04 added CRUD endpoints and DB persistence.
* E2E tests catch wiring mistakes that unit tests miss.

**Acceptance Criteria**

1. Test harness spins up NestJS app via `Test.createTestingModule()`.
2. `docker-compose -f infra/db.yml` starts Postgres for tests; Jest global setup waits for readiness.
3. Each Customer endpoint tested: POST-GET-PUT-DELETE happy-path and main error cases.
4. Test database rolled back between cases (use `queryRunner.startTransaction()` or truncate tables).
5. E2E tests run under `npm run test:e2e` and in CI workflow.

**Steps**

1. Install `supertest`, `@types/supertest`.
2. Add `test/e2e/customer.e2e-spec.ts`.
3. Configure Jest projects (`unit`, `e2e`) with separate ts-config.
4. Create global setup/teardown script for Docker DB.
5. Document local workflow in `api/README.md`.

**DoD**

* `npm run test:e2e` green locally and in CI.
* Coverage report includes e2e numbers (optional).
* Logs archived per **AGENTS.md** instructions.

---

#### After Task 09

With validation, logging, docs, coverage, and e2e tests in place, the API foundation is production-ready. Subsequent tasks (seed scripts, CI pipeline refinement, ADR automation, etc.) can now build on a stable, observable base.

