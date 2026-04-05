open Core

exception Failed of { case_id : int; msg : string }

(* Shared run loop used by every problem's Make functor.
   Raises [Failed] on the first wrong answer. Returns normally if all pass. *)
let run ~cases ~call =
  List.iteri cases ~f:(fun i (input, expected) ->
    let got = call input in
    if not (Sexp.equal got expected) then
      raise (Failed
        { case_id = i + 1
        ; msg = Printf.sprintf "expected %s\n     got %s"
                  (Sexp.to_string_hum expected)
                  (Sexp.to_string_hum got)
        }))
