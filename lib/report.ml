open Core

let print_result (result : Judge.result) =
  match result with
  | Judge.Accepted ->
    print_endline "Accepted"
  | Judge.Wrong_answer { case_id; msg } ->
    printf "Wrong Answer\n";
    printf "  Case %d: %s\n" case_id msg
  | Judge.Runtime_error msg ->
    print_endline "Runtime Error";
    if not (String.is_empty msg) then printf "%s\n" msg
  | Judge.Compile_error msg ->
    print_endline "Compile Error";
    let msg = String.strip msg in
    if not (String.is_empty msg) then printf "%s\n" msg
