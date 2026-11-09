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

## M1 — Problems and editor
- Public read API returns paginated summaries and two sample cases per problem. Hidden fixtures are never selected by the detail query.
- Ten original JSON-stdin/JSON-stdout tasks have eight fixed fixtures each, covering empty/minimal inputs where permitted, negative values, duplicates, ordering, and boundary conditions. This contract avoids installing third-party parsing libraries in the eventual Python runtime. Java/C++ starters identify the future parsing work; neither is executable in M1.
- Database enforces difficulty values, unique slugs, fixture position uniqueness, and foreign-key ownership; indexes support filtering. Pagination uses stable ID ordering and bounded page sizes.
- Monaco and its React adapter are new MIT-licensed editor dependencies. Assets are copied from installed packages before dev/build and served locally, with no editor CDN dependency.
- Drafts remain device-local and separated by problem/language. Reset requires confirmation. No code is sent to the API.
- Design: blue #305ec1, ink #233044, canvas #f5f7fa, white panels; Avenir/system typography. A compact library and statement/editor workspace prioritize reading and typing over dashboard metrics.
