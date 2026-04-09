type t =
  | Accepted
  | Wrong_answer of { case_id : int; msg : string }
  | Time_limit_exceeded of { case_id : int; time_limit_ms : int }
  | Runtime_error of string
  | Compile_error of string
