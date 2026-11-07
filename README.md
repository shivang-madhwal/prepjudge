# PrepJudge

M0 scaffold for the attached [build plan](docs/PLAN.md). No code execution or business endpoints are implemented.

## Prerequisites
Java 21, Node 22+, Docker with a running daemon. Maven wrappers are provided for each service.

## Local setup
Copy `.env.example` to `.env`, choose a local password, and run `docker compose up -d postgres redis`.
Export the variables from `.env` into your shell before starting Java services (Compose does not export them).

- API: `cd api && ./mvnw spring-boot:run` — http://localhost:8080/actuator/health
- Runner: `cd runner && ./mvnw spring-boot:run` — http://localhost:8081/actuator/health
- Web: `cd web && npm ci && npm run dev` — http://localhost:3000
- Web health: http://localhost:3000/api/health

## Checks
`cd api && ./mvnw verify`

`cd runner && ./mvnw verify`

`cd web && npm run lint && npm test && npm run build`

Java integration tests start isolated Postgres/Redis containers with Testcontainers. Docker must be available; tests are not silently skipped.

## Security boundary
M0 never runs submitted code. The eventual runner must remain private until M3 hardening tests pass. Docker alone does not eliminate kernel escape risk. Domain features, auth, judging, and public hosting are future milestones.

On Homebrew macOS, if the Maven wrapper cannot locate Java, export `JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home`.
