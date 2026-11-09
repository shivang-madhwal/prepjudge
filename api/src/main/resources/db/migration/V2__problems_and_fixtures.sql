CREATE TABLE problems (
 id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 slug varchar(80) NOT NULL UNIQUE,
 title varchar(160) NOT NULL,
 difficulty varchar(10) NOT NULL CHECK (difficulty IN ('EASY','MEDIUM','HARD')),
 statement_md text NOT NULL,
 constraints_text text NOT NULL,
 tags text[] NOT NULL
);
CREATE INDEX problems_difficulty_id_idx ON problems(difficulty,id);
CREATE INDEX problems_tags_idx ON problems USING gin(tags);
CREATE TABLE test_cases (
 id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 problem_id bigint NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
 input text NOT NULL,
 expected_output text NOT NULL,
 is_sample boolean NOT NULL DEFAULT false,
 position integer NOT NULL CHECK(position >= 0),
 UNIQUE(problem_id,position)
);
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('pair-indices','Pair indices','MEDIUM','Given {"nums": integer array, "target": integer}, return the two distinct indices whose values sum to target, in increasing order. Exactly one pair exists. Read one JSON value from stdin and write one JSON result to stdout.','2 ≤ length ≤ 10000; values and target between -100000 and 100000.',ARRAY['hash-map']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[2,7,11],"target":9}','[0,1]',true,0 FROM problems WHERE slug='pair-indices';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[3,2,4],"target":6}','[1,2]',true,1 FROM problems WHERE slug='pair-indices';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[3,3],"target":6}','[0,1]',false,2 FROM problems WHERE slug='pair-indices';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[-2,4,9],"target":7}','[0,2]',false,3 FROM problems WHERE slug='pair-indices';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[0,5],"target":5}','[0,1]',false,4 FROM problems WHERE slug='pair-indices';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[1,8,3],"target":11}','[1,2]',false,5 FROM problems WHERE slug='pair-indices';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[-4,-1,-7],"target":-5}','[0,1]',false,6 FROM problems WHERE slug='pair-indices';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[10,20,30],"target":40}','[0,2]',false,7 FROM problems WHERE slug='pair-indices';
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('duplicate-check','Duplicate check','EASY','Given an integer array, return true if any value appears more than once; otherwise return false. Read one JSON value from stdin and write one JSON result to stdout.','0 ≤ length ≤ 10000; values between -100000 and 100000.',ARRAY['hash-map']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[1,2,1]','true',true,0 FROM problems WHERE slug='duplicate-check';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[1,2,3]','false',true,1 FROM problems WHERE slug='duplicate-check';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[]','false',false,2 FROM problems WHERE slug='duplicate-check';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[0]','false',false,3 FROM problems WHERE slug='duplicate-check';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[0,0]','true',false,4 FROM problems WHERE slug='duplicate-check';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[-1,2,-1]','true',false,5 FROM problems WHERE slug='duplicate-check';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[4,4,4]','true',false,6 FROM problems WHERE slug='duplicate-check';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[-3,-2,-1]','false',false,7 FROM problems WHERE slug='duplicate-check';
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('mirror-word','Mirror word','EASY','Given a lowercase English string, return true when it reads identically forward and backward. The empty string is a palindrome. Read one JSON value from stdin and write one JSON result to stdout.','0 ≤ length ≤ 10000; lowercase a–z only.',ARRAY['two-pointers']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"level"','true',true,0 FROM problems WHERE slug='mirror-word';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"hello"','false',true,1 FROM problems WHERE slug='mirror-word';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'""','true',false,2 FROM problems WHERE slug='mirror-word';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"a"','true',false,3 FROM problems WHERE slug='mirror-word';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"aa"','true',false,4 FROM problems WHERE slug='mirror-word';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"ab"','false',false,5 FROM problems WHERE slug='mirror-word';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"racecar"','true',false,6 FROM problems WHERE slug='mirror-word';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"abca"','false',false,7 FROM problems WHERE slug='mirror-word';
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('best-trade','Best single trade','EASY','Given daily nonnegative prices, return the largest profit from buying once then selling on a later day. Return 0 if no profitable trade exists. Read one JSON value from stdin and write one JSON result to stdout.','0 ≤ length ≤ 10000; 0 ≤ price ≤ 100000.',ARRAY['sliding-window']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[7,1,5,3,6,4]','5',true,0 FROM problems WHERE slug='best-trade';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[7,6,4,3,1]','0',true,1 FROM problems WHERE slug='best-trade';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[]','0',false,2 FROM problems WHERE slug='best-trade';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[5]','0',false,3 FROM problems WHERE slug='best-trade';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[1,2]','1',false,4 FROM problems WHERE slug='best-trade';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[2,1]','0',false,5 FROM problems WHERE slug='best-trade';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[0,0,4]','4',false,6 FROM problems WHERE slug='best-trade';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[2,9,1,10]','9',false,7 FROM problems WHERE slug='best-trade';
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('bracket-balance','Bracket balance','EASY','Given a string containing only ()[]{}, return true if all brackets are correctly nested and matched. Read one JSON value from stdin and write one JSON result to stdout.','0 ≤ length ≤ 10000.',ARRAY['stack']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"([])"','true',true,0 FROM problems WHERE slug='bracket-balance';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"([)]"','false',true,1 FROM problems WHERE slug='bracket-balance';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'""','true',false,2 FROM problems WHERE slug='bracket-balance';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"("','false',false,3 FROM problems WHERE slug='bracket-balance';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"]"','false',false,4 FROM problems WHERE slug='bracket-balance';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"{}[]()"','true',false,5 FROM problems WHERE slug='bracket-balance';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"((()))"','true',false,6 FROM problems WHERE slug='bracket-balance';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"(()"','false',false,7 FROM problems WHERE slug='bracket-balance';
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('sorted-position','Sorted position','EASY','Given {"nums": strictly increasing integer array, "target": integer}, return its index or -1 when absent. Read one JSON value from stdin and write one JSON result to stdout.','0 ≤ length ≤ 10000; values and target between -100000 and 100000.',ARRAY['binary-search']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[1,3,8],"target":3}','1',true,0 FROM problems WHERE slug='sorted-position';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[1,3,8],"target":4}','-1',true,1 FROM problems WHERE slug='sorted-position';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[],"target":1}','-1',false,2 FROM problems WHERE slug='sorted-position';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[2],"target":2}','0',false,3 FROM problems WHERE slug='sorted-position';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[2],"target":3}','-1',false,4 FROM problems WHERE slug='sorted-position';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[-5,0,4],"target":-5}','0',false,5 FROM problems WHERE slug='sorted-position';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[1,4,9],"target":9}','2',false,6 FROM problems WHERE slug='sorted-position';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'{"nums":[1,4,9],"target":0}','-1',false,7 FROM problems WHERE slug='sorted-position';
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('step-count','Step count','EASY','Given n steps, return the number of distinct ways to climb them using moves of 1 or 2 steps. There is one way to climb zero steps: take no moves. Read one JSON value from stdin and write one JSON result to stdout.','0 ≤ n ≤ 40.',ARRAY['dynamic-programming']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'2','2',true,0 FROM problems WHERE slug='step-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'3','3',true,1 FROM problems WHERE slug='step-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'0','1',false,2 FROM problems WHERE slug='step-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'1','1',false,3 FROM problems WHERE slug='step-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'4','5',false,4 FROM problems WHERE slug='step-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'5','8',false,5 FROM problems WHERE slug='step-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'6','13',false,6 FROM problems WHERE slug='step-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'10','89',false,7 FROM problems WHERE slug='step-count';
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('merge-spans','Merge spans','MEDIUM','Given closed integer intervals [start,end], merge overlapping or touching intervals. Return intervals ordered by start. Input order is arbitrary. Read one JSON value from stdin and write one JSON result to stdout.','0 ≤ length ≤ 10000; -100000 ≤ start ≤ end ≤ 100000.',ARRAY['intervals']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[1,3],[2,6],[8,10]]','[[1,6],[8,10]]',true,0 FROM problems WHERE slug='merge-spans';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[1,4],[4,5]]','[[1,5]]',true,1 FROM problems WHERE slug='merge-spans';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[]','[]',false,2 FROM problems WHERE slug='merge-spans';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[2,2]]','[[2,2]]',false,3 FROM problems WHERE slug='merge-spans';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[5,7],[1,2]]','[[1,2],[5,7]]',false,4 FROM problems WHERE slug='merge-spans';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[1,10],[2,3]]','[[1,10]]',false,5 FROM problems WHERE slug='merge-spans';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[-3,0],[-1,4]]','[[-3,4]]',false,6 FROM problems WHERE slug='merge-spans';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[1,2],[1,2]]','[[1,2]]',false,7 FROM problems WHERE slug='merge-spans';
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('unique-window','Longest unique window','MEDIUM','Given a lowercase string, return the length of its longest contiguous substring with no repeated character. Read one JSON value from stdin and write one JSON result to stdout.','0 ≤ length ≤ 10000; lowercase a–z only.',ARRAY['sliding-window']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"abcabcbb"','3',true,0 FROM problems WHERE slug='unique-window';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"bbbbb"','1',true,1 FROM problems WHERE slug='unique-window';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'""','0',false,2 FROM problems WHERE slug='unique-window';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"a"','1',false,3 FROM problems WHERE slug='unique-window';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"abba"','2',false,4 FROM problems WHERE slug='unique-window';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"pwwkew"','3',false,5 FROM problems WHERE slug='unique-window';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"abcdef"','6',false,6 FROM problems WHERE slug='unique-window';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'"dvdf"','3',false,7 FROM problems WHERE slug='unique-window';
INSERT INTO problems(slug,title,difficulty,statement_md,constraints_text,tags) VALUES ('island-count','Island count','MEDIUM','Given a rectangular grid of integers 0 and 1, return the number of connected land components. Land is 1; only vertical and horizontal neighbors connect. An empty grid has zero islands. Read one JSON value from stdin and write one JSON result to stdout.','0 ≤ rows, columns ≤ 100; all rows have equal length.',ARRAY['graphs']);
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[1,1,0],[0,1,0],[0,0,1]]','2',true,0 FROM problems WHERE slug='island-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[1,1],[1,1]]','1',true,1 FROM problems WHERE slug='island-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[]','0',false,2 FROM problems WHERE slug='island-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[0]]','0',false,3 FROM problems WHERE slug='island-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[1]]','1',false,4 FROM problems WHERE slug='island-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[1,0],[0,1]]','2',false,5 FROM problems WHERE slug='island-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[0,0],[0,0]]','0',false,6 FROM problems WHERE slug='island-count';
INSERT INTO test_cases(problem_id,input,expected_output,is_sample,position) SELECT id,'[[1,0,1,0,1]]','3',false,7 FROM problems WHERE slug='island-count';
