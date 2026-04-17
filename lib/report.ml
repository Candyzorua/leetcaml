open Core

let print_result (result : Verdict.t) =
  match result with
  | Verdict.Accepted -> print_endline "Accepted"
  | Verdict.Wrong_answer { case_id; msg } ->
      printf "Wrong Answer\n";
      printf "  Case %d: %s\n" case_id msg
  | Verdict.Runtime_error msg ->
      print_endline "Runtime Error";
      if not (String.is_empty msg) then printf "%s\n" msg
  | Verdict.Time_limit_exceeded { case_id; time_limit_ms } ->
      printf "Time Limit Exceeded\n";
      printf "  Case %d exceeded %dms\n" case_id time_limit_ms
  | Verdict.Compile_error msg ->
      print_endline "Compile Error";
      let msg = String.strip msg in
      if not (String.is_empty msg) then printf "%s\n" msg
