open Core

let () =
  Command.basic
    ~summary:"Run an OCaml solution and judge it"
    (let open Command.Param in
     map
       (anon ("solution.ml" %: string))
       ~f:(fun submission_file () ->
         let result = Leetcaml.Judge.judge ~submission_file in
         Leetcaml.Report.print_result result))
  |> Command_unix.run
