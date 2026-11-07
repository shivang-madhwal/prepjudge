# PrepJudge: Interview Prep Platform with Sandboxed Code Judge (Codex Build Plan)

A web app where users read DSA problems, write code in an editor, submit it, and get a
verdict (Accepted, Wrong Answer, Time Limit Exceeded, and so on) from a sandboxed runner.
Build it AFTER ShortLink; you will reuse its Docker, Redis, rate-limiting, load-test and CI setup.
Rough time: 5 to 6 weeks part-time. Budget: zero, so everything runs locally or on free tiers.

## How to use this file

1. Create an empty repo `prepjudge`.
2. Copy Part A into `AGENTS.md` at the repo root.
3. Save this whole file as `docs/PLAN.md`.
4. Give Codex ONE milestone at a time with the prompt shown. Review every diff, run the checks yourself,
   then merge. You must be able to explain every file in an interview.

**Safety note:** this project executes untrusted code. Never run submissions inside the API process,
and do not expose the runner to the public internet until M3 is complete and its tests pass.
For the live demo, host the web app and API publicly but keep the runner on your own machine or a
small VM you control, or restrict the public demo to a fixed set of sample submissions.

---

## Part A: AGENTS.md (copy to repo root)

```markdown
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
```

---

## Part B: Domain model and verdicts

**Tables:** `users`, `problems` (slug, title, difficulty, statement_md, tags), `test_cases`
(problem_id, input, expected_output, is_sample, position), `editorials` (problem_id, content_md,
solution_code, language), `submissions` (user_id, problem_id, language, code, status, runtime_ms,
memory_kb, failed_case_index, created_at).

**Statuses:** `QUEUED`, `RUNNING`, `ACCEPTED`, `WRONG_ANSWER`, `TIME_LIMIT_EXCEEDED`,
`MEMORY_LIMIT_EXCEEDED`, `RUNTIME_ERROR`, `COMPILATION_ERROR`, `INTERNAL_ERROR`.

**Flow:** Web -> `POST /api/v1/submissions` (API saves as QUEUED, pushes job id to Redis) ->
Runner pops job, runs code in a container per test case, writes verdict -> Web polls
`GET /api/v1/submissions/{id}`.

---

## Part C: Milestones

### M0: Scaffold
- Monorepo with `/api`, `/runner`, `/web`, Docker Compose (Postgres, Redis), health endpoints, Flyway baseline.
- GitHub Actions running all three check commands.
- README skeleton, `.env.example`, `docs/DECISIONS.md`.

**Done when:** all checks pass locally and in CI.

> **Codex prompt:** Read AGENTS.md and docs/PLAN.md. Implement M0 only. No business logic.

### M1: Problems and editor (no execution yet)
- Migrations and read APIs: `GET /api/v1/problems` (filter by difficulty and tag, paginated), `GET /api/v1/problems/{slug}`.
- Seed 10 problems (write the statements yourself, or have Codex draft them and then check every test case by hand) with at least 8 test cases each, 2 marked as samples.
- Web: problem list page, problem detail page with Monaco editor (language dropdown, starter code per language). Keep the editor simple and free: no paid services.

**Done when:** you can browse problems and type code in the editor; API tests cover filtering and pagination.

> **Codex prompt:** Implement M1 only. Do not add submission endpoints. Write API integration tests first. Keep the UI minimal and accessible.

### M2: Submission pipeline (Python only)
- `POST /api/v1/submissions` (problem slug, language, code; max code size 64 KB) returns 202 with the submission id.
- Redis list or stream as the job queue. Runner claims jobs with a visibility timeout so a crashed runner does not lose a job; jobs retry at most 3 times, then `INTERNAL_ERROR`.
- Runner: for each test case, run the code in a fresh Docker container, feed stdin, compare stdout (trim trailing whitespace), stop at the first failure, store the verdict, runtime and failed case index (hide the input and expected output of hidden cases).
- Web: submit button, status polling, verdict display.

**Done when:** a correct Python solution is ACCEPTED, and wrong output, an infinite loop and an exception produce the right verdicts.

> **Codex prompt:** Implement M2 only, Python only. Start the runner with Docker CLI invocations using the sandbox flags in M3, even if the hardening tests come later. Document the queue claim/visibility-timeout design in docs/DECISIONS.md.

### M3: Sandbox hardening (the part recruiters remember)
Every container must run with at least:
`--network none --memory 256m --memory-swap 256m --cpus 0.5 --pids-limit 64 --read-only
--tmpfs /tmp:rw,size=16m,noexec --user 65534:65534 --cap-drop ALL --security-opt no-new-privileges`,
a wall-clock timeout enforced by the runner (kill and remove the container on expiry), and a
stdout cap (e.g., 1 MB). Always remove containers, including on runner crash recovery.

Write adversarial test submissions and assert each is contained and gets the right verdict:
infinite loop, memory allocation bomb, fork bomb, huge output, network call, writing to the filesystem,
reading `/etc/passwd`-style host paths, sleeping past the timeout.

**Done when:** all adversarial tests pass, no containers are left behind after the test run, and the
runner stays healthy afterward.

> **Codex prompt:** Implement M3 only. Add the adversarial test suite first, watch it fail, then harden. In your final message list which limit stops each attack. If any attack is NOT contained, say so explicitly instead of marking it done.

### M4: More languages
- Add Java and C++ with a compile step (separate time and memory limits for compile vs run), mapped by a per-language config file (image, compile command, run command, limits, time multiplier).
- Compilation errors return `COMPILATION_ERROR` with a truncated message (no host paths).

**Done when:** the same sample problem is accepted in all three languages and compile errors are reported cleanly.

### M5: Accounts, history, Run vs Submit
- Auth: register/login with JWT (or sessions), BCrypt password hashing.
- Submission history per user and problem; basic progress page (solved count by difficulty).
- "Run" executes against sample cases only and returns full output; "Submit" runs all cases.
- Rate limit submissions per user (reuse the ShortLink approach).

**Done when:** tests cover auth failure paths, that users cannot read each other's code, and rate-limit behavior.

### M6: Editorials and content
- Editorial page per problem (markdown): approach, complexity, solution code. Show only after the user has solved it or clicks "reveal".
- Tags and a simple search.

### M7: Throughput and performance numbers
- Load-test submissions with k6 using N parallel runners (1, 2, 4). Record in `docs/PERFORMANCE.md`: submissions per minute, p50/p95 time from QUEUED to verdict, queue depth under load, failures.
- Note the bottleneck you found (container start-up time is the usual one) and what you tried.

**Done when:** `docs/PERFORMANCE.md` contains real before/after measurements. Do not invent numbers.

### M8: Deploy and polish
- Deploy web and API on free tiers (check current limits). Keep the runner on a machine you control, or limit the public demo as described in the safety note.
- README with live link, a GIF of submit-to-verdict, an architecture diagram (Mermaid), and the sandbox limits table.
- A short "Security model" section in the README: what the sandbox blocks and what it does not.

---

## Part D: Resume and interview material

**Resume bullet template** (fill with measured values):
- Built a full-stack interview-prep platform (Next.js, Spring Boot, PostgreSQL, Redis) with a sandboxed code-execution service judging Python, Java and C++ submissions in isolated Docker containers.
- Designed a queue-based judge pipeline with visibility timeouts and retries; sustained **[X] submissions/min** with **p95 [Y] s** queue-to-verdict latency across **[N]** parallel runners.
- Hardened the sandbox (no network, CPU/memory/PID limits, read-only filesystem, dropped capabilities) and verified it with an adversarial test suite covering fork bombs, memory bombs and filesystem and network access.

**Be ready to explain:**
- Why a separate runner service and why a queue instead of running code in the request.
- How you prevent job loss and double execution (visibility timeout, idempotent verdict writes).
- Each Docker flag and which attack it stops, plus what a container sandbox does NOT protect against (kernel exploits; mention gVisor/Firecracker as the next step).
- How you compare outputs fairly (whitespace, special judges for multiple valid answers).
- How you would scale runners horizontally and cut container start-up cost (warm pools).
