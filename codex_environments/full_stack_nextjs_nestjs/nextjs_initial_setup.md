# Task 00 - Initialize Next.js App 

**Prompt**

Create a new **Next 15 / React 19** application named **`client-profile-ui`** inside **`project_root/ui`**.
Use the exact *package.json* below, install dependencies, and scaffold a working TypeScript-based project that supports development, build, lint, and test workflows.

```json
{
  "name": "ui",
  "version": "0.0.1",
  "scripts": {
    "dev":   "next dev --turbopack",
    "build": "next build",
    "start": "next start",
    "test":  "jest"
  },
  "dependencies": {
    "react":      "^19.0.0",
    "react-dom":  "^19.0.0",
    "next":        "15.3.3"
  },
  "devDependencies": {
    "typescript":           "^5",
    "@types/node":          "^20",
    "@types/react":         "^19",
    "@types/react-dom":     "^19",
    "eslint":               "^9",
    "eslint-config-next":    "15.3.3",
    "@eslint/eslintrc":     "^3"
  }
}
```

---

## Guide for the AI Coding Agent — Key Sections

### 1  Prerequisites

| Tool        | Version (min) | Notes                                |
| ----------- | ------------- | ------------------------------------ |
| **Node.js** | 20.x          | Matches Next 15 support matrix.      |
| **npm**     | 10.x          | Lockfile must be committed.          |
| **Git**     | any recent    | Global user.name / email configured. |

### 2  Install Exact Dependencies

```bash
cd project_root/ui
# package.json already present (see above)
npm install           # or: npm ci
```

*Do not* add `^` or `~`; the versions are already locked.

### 3  Workspace Layout

```
project_root/ui/
├─ public/
├─ src/
│  ├─ app/
│  │  ├─ layout.tsx
│  │  └─ page.tsx
│  ├─ components/
│  ├─ hooks/
│  ├─ lib/
│  └─ tests/
├─ tsconfig.json
├─ next.config.ts
├─ .eslintrc.cjs
├─ jest.config.ts
├─ jest.setup.ts
├─ .gitignore
└─ package.json
```

### 4  TypeScript 5 Configuration (`tsconfig.json`)

* Strict mode, `noEmit: true`
* Path aliases: `@/app/*`, `@/components/*`, `@/hooks/*`, `@/lib/*`
* Target: **ES2020**; libs: **DOM**, **DOM.Iterable**, **ES2020**

### 5  Next Configuration (`next.config.ts`)

```typescript
import type { NextConfig } from 'next';

const config: NextConfig = {
  reactStrictMode: true,
  experimental: { appDir: true }
};

export default config;
```

### 6  ESLint 9

* Extend `"next"` and `"next/core-web-vitals"`.
* Zero **errors** on `npm run lint`.

### 7  Jest + React Testing Library

* Use `next/jest`, `ts-jest`, and a jsdom environment.
* Include `@testing-library/jest-dom` in `jest.setup.ts`.

### 8  Git & Continuous Integration

* `.gitignore` excludes `.next/`, `node_modules/`, `coverage/`.
* GitHub Actions workflow runs `npm run lint`, `npm test -- --coverage`, and `npm run build` on each push.

### 9  Agent Checklist

* [ ] `npm ci` completes with zero warnings.
* [ ] `npm run dev` serves **localhost:3000** successfully.
* [ ] `npm run build` finishes without errors.
* [ ] `npm test` passes a smoke test.
* [ ] ESLint reports no errors.
* [ ] CI workflow passes on GitHub.

---

### Acceptance Criteria

1. Directory structure and configuration files match the *Workspace Layout* and *Configuration* sections above.
2. All npm scripts (`dev`, `build`, `start`, `test`) work as described.
3. A placeholder landing page renders in the browser and during static build.
4. CI workflow executes successfully in GitHub Actions.

Upon completion, commit everything (including `package-lock.json`) and open a pull request titled **`feat(ui): initialise Next 15 app`** targeting the main branch.
