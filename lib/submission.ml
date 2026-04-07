open Core

type t = string

let create file =
  if not (Filename.check_suffix file ".ml") then
    Or_error.error_s [%sexp "Submission must be a .ml file", (file : string)]
  else if not (Core_unix.access file [ `Exists ] |> Result.is_ok) then
    Or_error.error_s [%sexp "File not found", (file : string)]
  else
    Ok file

let path t = t
