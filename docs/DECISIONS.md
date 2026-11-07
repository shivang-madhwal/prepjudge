# Decisions

- M0 only: follow the supplied milestone boundary; no submissions or execution.
- Separate Java 21 / Spring Boot 3 services. Only API owns Flyway migrations; runner connects to Redis for health verification.
- Flyway V1 establishes migration history without prematurely creating domain tables.
- Services bind to loopback by default. Compose exposes dependencies on loopback, without any Docker socket mount.
- Health reports aggregate status only; internal dependency details are not exposed.
- No ShortLink checkout was found; infrastructure is standalone rather than copying an unknown project.
- Web uses Next.js App Router and TypeScript. Monaco and Playwright dependencies are deferred until M1 browser behaviors require them.
- The lint command runs Next.js ESLint rules and TypeScript validation.
- Runtime versions are dependency-managed and locked where supported; public deployment is deferred to M8 and requires fresh vulnerability review.

- Testcontainers' managed Docker client default was rejected by the installed Docker daemon. Test-only docker-java.properties selects API 1.44, which the daemon supports; both integration suites then passed.
