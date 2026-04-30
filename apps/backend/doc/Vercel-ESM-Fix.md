# Vercel ESM runtime error — Fix log and resolution

Date: 2026-04-30

## Problem
When deploying the backend to Vercel the function invocations failed with the following runtime error in the Vercel logs:

/var/task/src/server.js:7
import app from './src/index.js';
^^^^^^

SyntaxError: Cannot use import statement outside a module

Vercel reported that the deployed file was being loaded as CommonJS while the code used ESM import syntax.

## Root cause
- Vercel selected an entrypoint and executed the compiled file under a package boundary that did not declare ESM, so Node executed the file using CommonJS loader.
- The repo had a monorepo layout; without an explicit package boundary Vercel sometimes chooses the wrong package.json (or treats the function output as CJS).

## Summary of actions taken (what I changed)
1. Added a root-level wrapper entrypoint for Vercel to detect:
   - Added `apps/backend/server.mjs` that exports the built Express app from `dist/src/index.js` so Vercel can load a real ESM entrypoint.
   - Removed the backend root `server.ts` so Vercel stops preferring the CommonJS-style transpiled entry.
   - Moved the API handler from `apps/backend/api/index.ts` into `apps/backend/src/index.ts` so the runtime path is consistent.
2. Updated `apps/backend/package.json` to give an explicit main entry in the backend package:
   - Set `"main": "server.mjs"` so Vercel sees the intended file to use as an entrypoint.
3. Updated `vercel.json` for the backend to ensure requests route to the serverless function built from `src/index`:
   - Added / adjusted `rewrites` to route `/(.*)` → `/src/index` (so the Express app handles public routes).
4. Made the monorepo root package explicit (module boundary):
   - Updated the root `package.json` to include `"type": "module"` and `"main": "apps/backend/server.ts"` so Vercel treats the package correctly as ESM for the backend entry.
5. Ensured compiled output and dependencies:
   - Ran `npm install` at root, `npx prisma generate`, and `npm run build` in `apps/backend` to produce `dist/` artifacts.
6. Verified and iterated on routing and Vercel function detection until the function was built and served as a lambda:
   - Used `vercel build`, `vercel --prod`, and `vercel inspect <deployment> --logs` to iterate until the runtime error disappeared.
7. Minor repository hygiene:
   - Added `.env` (from `.env.example`) locally for build-time env needs (not committed), and updated `.gitignore` to avoid committing secrets.

## Files changed (high-level)
- `apps/backend/server.mjs` (new) — ESM wrapper exported default `app` for Vercel.
- `apps/backend/package.json` — added `main` pointing to `server.mjs`.
- `apps/backend/tsconfig.json` — removed the root `server.ts` from the build include list.
- `apps/backend/vercel.json` — routing / rewrite configuration to map public paths to the built function.
- `package.json` (repo root) — added `type: "module"` and `main` to make the package boundary explicit for Vercel.
- `.gitignore` (apps/backend) — ensure `.env` and `dist/` are ignored.

## Commands run (most important)

- Install (root):
```bash
cd /workspaces/autolab-monorepo
npm install
```

- Generate Prisma client and build backend:
```bash
cd /workspaces/autolab-monorepo/apps/backend
npx prisma generate
npm run build   # runs tsc and produces dist/
```

- Local Vercel build verification (optional):
```bash
vercel build
```

- Deploy to Vercel (staging/preview):
```bash
vercel --yes
```

- Deploy to production:
```bash
vercel --prod --yes
```

- Inspect deployment logs (example):
```bash
vercel inspect <deployment-url-or-id> --logs
```

## Verification steps performed
- Confirmed `dist/src/index.js` existed after `tsc`.
- Confirmed `dist/server.js` imports `./src/index.js`.
- Confirmed `vercel build` completed using `server.ts` as entrypoint during earlier iterations.
- Confirmed successful `vercel --prod` deployment and that `/health` returned JSON (and no ESM loader errors in runtime logs).
- Rechecked Vercel live logs for the deployment — earlier ESM import errors no longer present.

## Why this fixes the error
- Vercel determines how to load Node functions by package boundaries and detected entrypoints. If the environment treats the code as CommonJS while your code uses ESM imports, Node will throw the "Cannot use import statement outside a module" error.
- By making the backend entrypoint explicit and switching Vercel to a real `.mjs` wrapper, Node loads the deployed function as ESM instead of CommonJS.

## Notes & next steps (recommended)
- Leave sensitive environment variables configured in Vercel project settings (do not commit `.env` to repo).
- Consider consolidating `vercel.json` and repository `package.json` semantics if you want to remove the root wrapper later.
- Optionally: ensure all TypeScript imports that become runtime imports include explicit `.js` extensions when targeting ESM (`import x from './file.js'`) — we did not need to do that in the final flow because `type: "module"` + tsc output worked.

## Where to find the changes
- The documentation file you are reading: `apps/backend/doc/Vercel-ESM-Fix.md`
- Key files changed:
   - [apps/backend/src/index.ts](apps/backend/src/index.ts)
   - [apps/backend/server.ts](apps/backend/server.ts)
   - [apps/backend/package.json](apps/backend/package.json)
   - [apps/backend/vercel.json](apps/backend/vercel.json)
   - [package.json](package.json)

If you'd like, I can:
- Revert the root `package.json` change and instead move `type: "module"` into `apps/backend/package.json` (safer long-term), then push and redeploy.
- Create a checklist for your CI/CD to ensure Vercel always selects the intended package boundary.

---
*If you want the shorter summary to paste into a PR description, tell me and I'll produce it.*