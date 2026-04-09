Accepted solution:

  $ leetcaml run fixtures/accepted.ml
  Accepted

Wrong answer:

  $ leetcaml run fixtures/wrong_answer.ml
  Wrong Answer
    Case 1: expected (0 1)
       got (0 0)

Runtime error:

  $ leetcaml run fixtures/runtime_error.ml 2>&1 | head -1
  Runtime Error

Nonexistent file:

  $ leetcaml run nonexistent.ml
  ("File not found" nonexistent.ml)
  [1]

Bad extension:

  $ leetcaml run fixtures/accepted.txt
  ("Submission must be a .ml file" fixtures/accepted.txt)
  [1]

Describe command:

  $ leetcaml describe two-sum | head -2
  
  Two Sum


Unknown problem:

  $ leetcaml describe nonexistent
  Unknown problem: nonexistent
  Available: two-sum, reverse-linked-list, valid-parentheses, max-subarray
  [1]
