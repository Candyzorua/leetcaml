open Core
open Async

exception Failed of { case_id : int; msg : string }
exception Time_limit_exceeded of { case_id : int; time_limit_ms : int }

let run_with_timeout ~time_limit_ms ~f input =
  Thread_safe.block_on_async_exn (fun () ->
      match%bind
        Clock.with_timeout
          (Time_float.Span.of_ms (Float.of_int time_limit_ms))
          (In_thread.run (fun () -> f input))
      with
      | `Timeout -> return `Timeout
      | `Result v -> return (`Result v))

let run ~cases ~f ~equal ~sexp_of_output ~time_limit_ms =
  List.iteri cases ~f:(fun i (input, expected) ->
      let case_id = i + 1 in
      match run_with_timeout ~time_limit_ms ~f input with
      | `Timeout -> raise (Time_limit_exceeded { case_id; time_limit_ms })
      | `Result got ->
          if not (equal got expected) then
            raise
              (Failed
                 {
                   case_id;
                   msg =
                     Printf.sprintf "expected %s\n     got %s"
                       (Sexp.to_string_hum (sexp_of_output expected))
                       (Sexp.to_string_hum (sexp_of_output got));
                 }))
