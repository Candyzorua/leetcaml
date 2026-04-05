module type Runner = sig
  val run : unit -> unit
end

let registered : (module Runner) option ref = ref None

let register m = registered := Some m
