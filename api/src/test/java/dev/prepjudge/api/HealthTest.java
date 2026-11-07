package dev.prepjudge.api;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import static org.assertj.core.api.Assertions.assertThat;
import org.testcontainers.containers.PostgreSQLContainer;
@Testcontainers
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class HealthTest {
 @Container static GenericContainer<?> redis = new GenericContainer<>("redis:7").withExposedPorts(6379);
 @Container @ServiceConnection static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");
 @DynamicPropertySource static void properties(DynamicPropertyRegistry r) {r.add("spring.data.redis.host", redis::getHost);r.add("spring.data.redis.port", () -> redis.getMappedPort(6379));}
 @Autowired TestRestTemplate http;
 @Autowired org.springframework.jdbc.core.JdbcTemplate jdbc;
 @Test void reportsHealthyDependencies() {var response=http.getForEntity("/actuator/health",String.class);assertThat(response.getStatusCode().value()).isEqualTo(200);assertThat(response.getBody()).contains("UP");assertThat(jdbc.queryForObject("select count(*) from flyway_schema_history where success = true", Integer.class)).isEqualTo(1);}
}
