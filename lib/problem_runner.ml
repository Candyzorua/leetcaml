open Core

exception Failed of { case_id : int; msg : string }

let run ~cases ~f ~equal ~sexp_of_output =
  List.iteri cases ~f:(fun i (input, expected) ->
    let got = f input in
    if not (equal got expected) then
      raise (Failed
        { case_id = i + 1
        ; msg = Printf.sprintf "expected %s\n     got %s"
                  (Sexp.to_string_hum (sexp_of_output expected))
                  (Sexp.to_string_hum (sexp_of_output got))
        }))
