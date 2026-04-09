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

(* ---- Leetcaml.Verdict unit tests ---- *)

let%test "Leetcaml.Verdict: constructors" =
  match (Leetcaml.Verdict.Accepted : Leetcaml.Verdict.t) with
  | Accepted -> true
  | _ -> false

let%test "Leetcaml.Verdict: TLE carries metadata" =
  match (Leetcaml.Verdict.Time_limit_exceeded { case_id = 3; time_limit_ms = 5000 } : Leetcaml.Verdict.t) with
  | Time_limit_exceeded { case_id = 3; time_limit_ms = 5000 } -> true
  | _ -> false
