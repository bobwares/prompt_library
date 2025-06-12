# Problems with iteration 8


1. source code versioning starting at 0.0.1 instead of 0.1.0
2. ADR Markdown documents lacks inserted lines between sections resulting in unreadable document.
3. Multi-Environment Support is missing. should create .env files per environment.
4. Swagger Configuration should be in separate file.
5. should not import pkg from "../package.json"; in main.  
6. .http tests are not created
7. Entities do not match the SQL Tables Schema.  
8. DTOs do not contain all fields for the customer profile.  
9. The table created in the db tasks should be inside a schema matching the domain name.




Error: 

app does not run.
 

---
Error Message:

nest start

src/main.ts:66:46 - error TS6133: 'req' is declared but its value is never read.

66   app.getHttpAdapter().get("/openapi.json", (req, res) => res.json(document));


Found 1 error(s).

---

Error Message:

npm run start

> backend@0.0.1 start
> nest start

/Users/bobware/projects/0-CURRENT/full-stack-app-nextjs-nestjs-baseline/api/src/main.ts:48
    .setVersion(pkg.version)
                    ^


TypeError: Cannot read properties of undefined (reading 'version')
    at bootstrap (/Users/bobware/projects/0-CURRENT/full-stack-app-nextjs-nestjs-baseline/api/src/main.ts:48:21)
    at process.processTicksAndRejections (node:internal/process/task_queues:105:5)

Node.js v22.7.0


--- 

Error Message:

npm run start

> backend@0.1.0 start
> nest start

/Users/bobware/projects/0-CURRENT/full-stack-app-nextjs-nestjs-baseline/api/src/main.ts:56
basicAuth({
^


TypeError: (0 , express_basic_auth_1.default) is not a function
at bootstrap (/Users/bobware/projects/0-CURRENT/full-stack-app-nextjs-nestjs-baseline/api/src/main.ts:56:16)
at process.processTicksAndRejections (node:internal/process/task_queues:105:5)
