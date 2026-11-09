# M0 validation

## Passed locally
- API: Java 21 `./mvnw -B -ntp verify`; Testcontainers Postgres 16 and Redis 7; health returns UP and Flyway baseline is applied once.
- Runner: Java 21 `./mvnw -B -ntp verify`; Redis integration health test.
- Web: `npm run lint && npm test && npm run build`.
- Compose: `POSTGRES_PASSWORD=validation-only docker compose config --quiet`.
- `npm audit --omit=dev`: zero reported production vulnerabilities at verification time.

## Dependencies and purpose
- Spring Boot Web/Actuator: HTTP services and aggregate health.
- Spring Data Redis: Redis connectivity and health.
- JDBC/PostgreSQL driver/Flyway: API database connectivity and migrations.
- Spring Boot Test/JUnit/Testcontainers: service tests against real isolated dependencies.
- Next.js/React/React DOM: frontend framework and rendering.
- TypeScript and type packages: static checks.
- Vitest: web health contract test.
- ESLint/eslint-config-next: framework lint rules.

## Limitations
- Full npm audit reports eight moderate development dependency findings in the ESLint/typescript-eslint/minimatch tree. The suggested top-level replacement downgrades eslint-config-next across major versions; no forced incompatible fix was applied. Review before adding untrusted content to build pipelines.
- Browser interaction, auth, domain APIs, submission execution, sandbox attacks, and deployment are not covered in M0.
- Docker client API 1.44 is selected in test resources for compatibility with the installed Docker daemon; this affects tests only.
- No paid services were provisioned. Docker Desktop was started for integration tests; temporary Testcontainers resources are cleaned up automatically.

# M1 validation
- API `./mvnw -B -ntp verify`: five tests passed, including real Postgres migration, combined filters, pagination, invalid values, unknown problems, and sample-only detail serialization.
- Web lint, three unit tests, and production build passed. Monaco assets bundle successfully.
- Local Postgres/Redis and API/web servers started for interactive review.
- Browser: selected Pair indices, inspected examples, loaded Monaco, typed a draft, switched to Java starter, switched back and observed the saved Python draft.
- Fixtures were authored and inspected against the stated contracts; adversarial judging and independent external content review remain future checks. The first pre-implementation test run was blocked by Docker connectivity; no claim of an observed endpoint-related red run is made.
