open Core

let run_cmd =
  Command.basic ~summary:"Run a solution file and judge it"
    (let open Command.Param in
     map
       (anon ("solution.ml" %: string))
       ~f:(fun file () ->
         match Leetcaml.Submission.create file with
         | Error e ->
             eprintf "%s\n" (Error.to_string_hum e);
             exit 1
         | Ok sub -> Leetcaml.Report.print_result (Leetcaml.Judge.judge sub)))

let describe_cmd =
  Command.basic ~summary:"Print the description of a problem"
    (let open Command.Param in
     map
       (anon ("problem" %: string))
       ~f:(fun slug () ->
         match Leetcaml.Problems.find slug with
         | None ->
             eprintf "Unknown problem: %s\nAvailable: %s\n" slug
               (String.concat ~sep:", "
                  (List.map Leetcaml.Problems.all ~f:(fun p -> p.slug)));
             exit 1
         | Some p -> print_string p.description))

let () =
  Command_unix.run
    (Command.group ~summary:"LeetCaml — an OCaml problem judge"
       [ ("run", run_cmd); ("describe", describe_cmd) ])
