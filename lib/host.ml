module type Runner = sig
  val run : on_result:(case_id:int -> passed:bool -> msg:string -> unit) -> unit
end

let registered : (module Runner) option ref = ref None

let register m = registered := Some m
