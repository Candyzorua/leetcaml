open Core

type result =
  | Accepted
  | Wrong_answer of { case_id : int; msg : string }
  | Runtime_error of string
  | Compile_error of string

(* Create a temp dir, run [f], then remove the dir unconditionally. *)
let with_temp_dir f =
  let dir = Core_unix.mkdtemp "/tmp/leetcaml_XXXXXX" in
  Exn.protect
    ~f:(fun () -> f dir)
    ~finally:(fun () ->
      ignore (Core_unix.system (Printf.sprintf "rm -rf %s" dir)))

(* Concatenate submission + harness into one file and compile it.
   This keeps both in the same module so the harness can call the user's
   functions without any qualification.
   Returns Ok(runner_path) on success, Error(compiler_output) on failure. *)
let compile ~submission_file ~harness_src ~out_dir =
  let combined_file = Filename.concat out_dir "combined.ml" in
  let runner        = Filename.concat out_dir "runner" in
  let err_file      = Filename.concat out_dir "compile_err.txt" in
  let submission_src = In_channel.read_all submission_file in
  Out_channel.write_all combined_file ~data:(submission_src ^ "\n" ^ harness_src);
  let cmd = Printf.sprintf "ocamlopt -o %s %s > %s 2>&1" runner combined_file err_file in
  match Core_unix.system cmd with
  | Ok () -> Ok runner
  | Error _ -> Error (In_channel.read_all err_file)

(* Execute [runner]; capture stdout and stderr into separate files. *)
let run ~runner ~out_dir =
  let stdout_file = Filename.concat out_dir "stdout.txt" in
  let stderr_file = Filename.concat out_dir "stderr.txt" in
  let cmd = Printf.sprintf "%s > %s 2> %s" runner stdout_file stderr_file in
  let ok           = Result.is_ok (Core_unix.system cmd) in
  let stdout_lines = In_channel.read_lines stdout_file in
  let stderr_str   = String.strip (In_channel.read_all stderr_file) in
  (ok, stdout_lines, stderr_str)

(* Each harness line is "PASS" or "FAIL case N: …". *)
let parse_output lines =
  match List.find lines ~f:(String.is_prefix ~prefix:"FAIL") with
  | None -> Accepted
  | Some msg ->
    let case_id =
      match String.split msg ~on:' ' with
      | _ :: "case" :: n :: _ ->
        let n = String.chop_suffix_if_exists n ~suffix:":" in
        Option.value ~default:0 (Option.try_with (fun () -> Int.of_string n))
      | _ -> 0
    in
    Wrong_answer { case_id; msg }

let judge ~(problem : Problem.t) ~submission_file =
  with_temp_dir (fun dir ->
    match compile ~submission_file ~harness_src:problem.harness ~out_dir:dir with
    | Error msg -> Compile_error msg
    | Ok runner ->
      let (ok, stdout_lines, stderr_str) = run ~runner ~out_dir:dir in
      if not ok
      then Runtime_error stderr_str
      else parse_output stdout_lines)
