open Core

(* ---- Leetcaml.Problem_runner unit tests ---- *)

let%test_unit "Leetcaml.Problem_runner: all pass" =
  Leetcaml.Problem_runner.run
    ~cases:[ 1, 2; 3, 6; 5, 10 ]
    ~f:(fun x -> x * 2)
    ~equal:Int.equal
    ~sexp_of_output:[%sexp_of: int]
    ~time_limit_ms:1000

let%test_unit "Leetcaml.Problem_runner: wrong answer raises Failed" =
  match
    (try
       Leetcaml.Problem_runner.run
         ~cases:[ 1, 99 ]
         ~f:(fun x -> x * 2)
         ~equal:Int.equal
         ~sexp_of_output:[%sexp_of: int]
         ~time_limit_ms:1000;
       `No_exn
     with Leetcaml.Problem_runner.Failed { case_id; _ } -> `Failed case_id)
  with
  | `Failed 1 -> ()
  | `Failed n -> failwithf "expected case_id=1, got %d" n ()
  | `No_exn -> failwith "expected Failed exception"

let%test_unit "Leetcaml.Problem_runner: timeout raises Time_limit_exceeded" =
  match
    (try
       Leetcaml.Problem_runner.run
         ~cases:[ (), () ]
         ~f:(fun () -> while true do () done)
         ~equal:Unit.equal
         ~sexp_of_output:[%sexp_of: unit]
         ~time_limit_ms:100;
       `No_exn
     with Leetcaml.Problem_runner.Time_limit_exceeded { case_id; time_limit_ms } ->
       `Tle (case_id, time_limit_ms))
  with
  | `Tle (1, 100) -> ()
  | `Tle (c, t) -> failwithf "expected (1,100), got (%d,%d)" c t ()
  | `No_exn -> failwith "expected Time_limit_exceeded exception"

(* ---- Report expect tests ---- *)

let%expect_test "report Accepted" =
  Leetcaml.Report.print_result Leetcaml.Verdict.Accepted;
  [%expect {| Accepted |}]

let%expect_test "report Wrong Answer" =
  Leetcaml.Report.print_result
    (Leetcaml.Verdict.Wrong_answer { case_id = 2; msg = "expected 5\n     got 3" });
  [%expect {|
    Wrong Answer
      Case 2: expected 5
         got 3 |}]

let%expect_test "report Time Limit Exceeded" =
  Leetcaml.Report.print_result
    (Leetcaml.Verdict.Time_limit_exceeded { case_id = 1; time_limit_ms = 5000 });
  [%expect {|
    Time Limit Exceeded
      Case 1 exceeded 5000ms |}]

let%expect_test "report Compile Error" =
  Leetcaml.Report.print_result
    (Leetcaml.Verdict.Compile_error "  Error: Unbound value foo  ");
  [%expect {|
    Compile Error
    Error: Unbound value foo |}]

let%expect_test "report Runtime Error" =
  Leetcaml.Report.print_result
    (Leetcaml.Verdict.Runtime_error "(Failure \"not implemented\")");
  [%expect {|
    Runtime Error
    (Failure "not implemented") |}]
