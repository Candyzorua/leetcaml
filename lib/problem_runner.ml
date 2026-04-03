open Core

(* Shared run loop used by every problem's Make functor.
   [cases]    : list of (input_sexp, expected_output_sexp)
   [call]     : deserialize input, invoke the user's function, serialize output
   [on_result]: callback provided by the judge *)
let run ~cases ~call ~on_result =
  List.iteri cases ~f:(fun i (input, expected) ->
    let got    = call input in
    let passed = Sexp.equal got expected in
    let msg    =
      if passed then ""
      else
        Printf.sprintf "expected %s\n     got %s"
          (Sexp.to_string_hum expected)
          (Sexp.to_string_hum got)
    in
    on_result ~case_id:(i + 1) ~passed ~msg)
