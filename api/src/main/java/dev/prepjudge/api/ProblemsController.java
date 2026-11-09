package dev.prepjudge.api;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import java.util.*;

@RestController
@RequestMapping("/api/v1/problems")
public class ProblemsController {
 private final JdbcTemplate jdbc;
 public ProblemsController(JdbcTemplate jdbc) { this.jdbc=jdbc; }
 public record Problem(long id,String slug,String title,String difficulty,List<String> tags) {}
 public record Sample(String input,String output) {}
 public record Detail(Problem problem,String statement,String constraints,List<Sample> samples) {}
 public record Page(List<Problem> items,long total,int page,int size) {}
 private Problem map(java.sql.ResultSet rs) throws java.sql.SQLException {
  return new Problem(rs.getLong("id"),rs.getString("slug"),rs.getString("title"),rs.getString("difficulty"),List.of((String[])rs.getArray("tags").getArray()));
 }
 @GetMapping public Page list(@RequestParam(defaultValue="0") int page,@RequestParam(defaultValue="20") int size,@RequestParam(required=false) String difficulty,@RequestParam(required=false) String tag) {
  if(page<0 || size<1 || size>100 || (difficulty!=null && !Set.of("EASY","MEDIUM","HARD").contains(difficulty)) || (tag!=null && !tag.matches("[a-z][a-z0-9-]{0,39}"))) throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Invalid filter or pagination value");
  String where=" WHERE true"; List<Object> args=new ArrayList<>();
  if(difficulty!=null){where+=" AND difficulty=?";args.add(difficulty);}
  if(tag!=null){where+=" AND tags @> ARRAY[?]::text[]";args.add(tag);}
  long total=Objects.requireNonNull(jdbc.queryForObject("SELECT count(*) FROM problems"+where,Long.class,args.toArray()));
  args.add(size);args.add((long)page*size);
  return new Page(jdbc.query("SELECT id,slug,title,difficulty,tags FROM problems"+where+" ORDER BY id LIMIT ? OFFSET ?",(rs,n)->map(rs),args.toArray()),total,page,size);
 }
 @GetMapping("/{slug}") public Detail detail(@PathVariable String slug) {
  if(!slug.matches("[a-z][a-z0-9-]{0,79}"))throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Invalid problem slug");
  var rows=jdbc.query("SELECT * FROM problems WHERE slug=?",(rs,n)->new Detail(map(rs),rs.getString("statement_md"),rs.getString("constraints_text"),List.of()),slug);
  if(rows.isEmpty())throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Problem not found");
  var p=rows.getFirst();
  var samples=jdbc.query("SELECT input,expected_output FROM test_cases WHERE problem_id=? AND is_sample=true ORDER BY position",(rs,n)->new Sample(rs.getString(1),rs.getString(2)),p.problem().id());
  return new Detail(p.problem(),p.statement(),p.constraints(),samples);
 }
}
@RestControllerAdvice
class ApiErrors {
 @ExceptionHandler(ResponseStatusException.class) ResponseEntity<Map<String,String>> status(ResponseStatusException e){return ResponseEntity.status(e.getStatusCode()).body(Map.of("error",e.getStatusCode().value()==404?"NOT_FOUND":"INVALID_REQUEST","message",Objects.requireNonNullElse(e.getReason(),"Request failed")));}
 @ExceptionHandler(MethodArgumentTypeMismatchException.class) ResponseEntity<Map<String,String>> invalid(){return ResponseEntity.badRequest().body(Map.of("error","INVALID_REQUEST","message","Invalid parameter type"));}
}
