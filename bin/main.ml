open Core

let judge_cmd =
  Command.basic
    ~summary:"Judge an OCaml submission against a problem"
    (let open Command.Param in
     map
       (both
          (anon ("problem" %: string))
          (anon ("submission.ml" %: string)))
       ~f:(fun (problem_slug, submission_file) () ->
         match Leetcaml.Problem.find problem_slug with
         | None ->
           eprintf "Unknown problem: %s\nAvailable: %s\n"
             problem_slug
             (String.concat ~sep:", "
                (List.map Leetcaml.Problem.all ~f:(fun p -> p.slug)));
           exit 1
         | Some problem ->
           let result = Leetcaml.Judge.judge ~problem ~submission_file in
           Leetcaml.Report.print_result result))

let () = Command_unix.run judge_cmd
