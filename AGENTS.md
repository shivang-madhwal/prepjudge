# AGENTS.md

## Project
PrepJudge: interview prep platform with a sandboxed code judge. See docs/PLAN.md for milestones.

## Layout (monorepo)
- /api     Spring Boot 3.x, Java 21, Maven wrapper. REST API, auth, persistence.
- /runner  Separate Spring Boot app. Pulls jobs from Redis and executes code in Docker containers.
- /web     Next.js (App Router) + TypeScript + Monaco editor.
- /loadtest k6 scripts
- docker-compose.yml  postgres, redis

## Stack (do not change without asking)
PostgreSQL 16 + Flyway, Redis 7, Testcontainers, JUnit 5, Vitest/Playwright for web, GitHub Actions.

## Commands
- Dependencies: `docker compose up -d postgres redis`
- API checks: `cd api && ./mvnw verify`
- Runner checks: `cd runner && ./mvnw verify`
- Web checks: `cd web && npm run lint && npm test && npm run build`

## Rules
- ONE milestone per task. Do not build later milestones.
- Every behavior change needs a test. All relevant checks must pass before you finish.
- No new dependencies without listing them and the reason in your final message.
- NEVER execute user-submitted code in the API process or on the host. Only the runner executes code, only inside Docker with the limits in docs/PLAN.md.
- Validate all input at the boundary. Consistent JSON errors: `{ "error": "CODE", "message": "..." }`.
- No secrets in the repo. Use environment variables and an `.env.example`.
- Record design decisions in docs/DECISIONS.md (decision, why, alternatives considered).
- Finish every task by listing: files changed, commands run, what is still untested.
