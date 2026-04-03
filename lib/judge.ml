open Core

type result =
  | Accepted
  | Wrong_answer of { case_id : int; msg : string }
  | Runtime_error of string
  | Compile_error of string

let with_temp_dir f =
  let dir = Core_unix.mkdtemp "/tmp/leetcaml_XXXXXX" in
  Exn.protect
    ~f:(fun () -> f dir)
    ~finally:(fun () ->
      ignore (Core_unix.system (Printf.sprintf "rm -rf %s" dir)))

(* Compile the submission to a .cmxs shared library for Dynlink. *)
let compile ~submission_file ~out_dir =
  let cmxs_file = Filename.concat out_dir "solution.cmxs" in
  let err_file  = Filename.concat out_dir "compile_err.txt" in
  let root      = Core_unix.getcwd () in
  let lib_dir   = Filename.concat root "_build/default/lib" in
  let objs_dir  = Filename.concat lib_dir ".leetcaml.objs/byte" in
  let cmd =
    Printf.sprintf
      "ocamlfind ocamlopt -shared -I %s -I %s \
       -package base,core,stdio,core_unix %s -o %s > %s 2>&1"
      lib_dir objs_dir submission_file cmxs_file err_file
  in
  match Core_unix.system cmd with
  | Ok ()  -> Ok cmxs_file
  | Error _ -> Error (In_channel.read_all err_file)

(* Load the .cmxs; the solution's top-level code calls Host.register. *)
let load cmxs_file =
  Host.registered := None;
  match
    (try Dynlink.loadfile cmxs_file; `Ok
     with Dynlink.Error e -> `Err (Dynlink.error_message e))
  with
  | `Err msg -> Error msg
  | `Ok ->
    match !(Host.registered) with
    | None    -> Error "solution did not call Host.register"
    | Some r  -> Ok r

(* Run the registered runner; collect failures via callback. *)
let run_runner (module R : Host.Runner) =
  let failures = ref [] in
  match
    (try
       R.run ~on_result:(fun ~case_id ~passed ~msg ->
         if not passed then failures := (case_id, msg) :: !failures);
       `Done
     with exn -> `Exn exn)
  with
  | `Exn exn -> Runtime_error (Exn.to_string exn)
  | `Done ->
    (match List.rev !failures with
     | []                   -> Accepted
     | (case_id, msg) :: _  -> Wrong_answer { case_id; msg })

let judge ~submission_file =
  with_temp_dir (fun dir ->
    match compile ~submission_file ~out_dir:dir with
    | Error msg -> Compile_error msg
    | Ok cmxs_file ->
      match load cmxs_file with
      | Error msg -> Runtime_error msg
      | Ok runner -> run_runner runner)
