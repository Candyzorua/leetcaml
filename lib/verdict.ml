type t =
  | Accepted
  | Wrong_answer of { case_id : int; msg : string }
  | Runtime_error of string
  | Compile_error of string
