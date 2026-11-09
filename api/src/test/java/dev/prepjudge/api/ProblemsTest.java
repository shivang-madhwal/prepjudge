package dev.prepjudge.api;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.jdbc.core.JdbcTemplate;
import com.fasterxml.jackson.databind.JsonNode;
import static org.assertj.core.api.Assertions.assertThat;

@Testcontainers
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ProblemsTest {
 @Container @ServiceConnection static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");
 @Container static GenericContainer<?> redis = new GenericContainer<>("redis:7").withExposedPorts(6379);
 @DynamicPropertySource static void properties(DynamicPropertyRegistry r) {
  r.add("spring.data.redis.host",redis::getHost);r.add("spring.data.redis.port",()->redis.getMappedPort(6379));
 }
 @Autowired TestRestTemplate http;
 @Autowired JdbcTemplate jdbc;
 @Test void paginatesDeterministically() {
  var first=http.getForObject("/api/v1/problems?page=0&size=3",JsonNode.class);
  var second=http.getForObject("/api/v1/problems?page=1&size=3",JsonNode.class);
  assertThat(first.path("total").asInt()).isEqualTo(10);
  assertThat(first.path("items").size()).isEqualTo(3);
  assertThat(first.path("items").get(0).path("slug")).isNotEqualTo(second.path("items").get(0).path("slug"));
 }
 @Test void combinesFiltersAndReturnsEmptyPages() {
  var result=http.getForObject("/api/v1/problems?difficulty=EASY&tag=hash-map",JsonNode.class);
  assertThat(result.path("total").asInt()).isEqualTo(1);
  assertThat(result.path("items").get(0).path("slug").asText()).isEqualTo("duplicate-check");
  assertThat(http.getForObject("/api/v1/problems?page=100",JsonNode.class).path("items").size()).isZero();
 }
 @Test void detailNeverExposesHiddenCases() {
  var result=http.getForObject("/api/v1/problems/pair-indices",JsonNode.class);
  assertThat(result.path("samples").size()).isEqualTo(2);
  assertThat(result.has("testCases")).isFalse();
  assertThat(result.toString()).doesNotContain("expected_output", "is_sample");
  assertThat(jdbc.queryForObject("SELECT count(*) FROM test_cases WHERE problem_id=(SELECT id FROM problems WHERE slug='pair-indices')",Integer.class)).isEqualTo(8);
  assertThat(jdbc.queryForObject("SELECT count(*) FROM problems p WHERE (SELECT count(*) FROM test_cases t WHERE t.problem_id=p.id)=8 AND (SELECT count(*) FROM test_cases t WHERE t.problem_id=p.id AND t.is_sample)=2",Integer.class)).isEqualTo(10);
 }
 @Test void rejectsInvalidParametersWithConsistentErrors() {
  for(String query:new String[]{"page=-1","size=0","size=101","page=no","difficulty=IMPOSSIBLE","tag=bad!"}) {
   var response=http.getForEntity("/api/v1/problems?"+query,JsonNode.class);
   assertThat(response.getStatusCode().value()).isEqualTo(400);
   assertThat(response.getBody().path("error").asText()).isEqualTo("INVALID_REQUEST");
  }
  assertThat(http.getForEntity("/api/v1/problems/missing",JsonNode.class).getStatusCode().value()).isEqualTo(404);
 }
}
