open Core

module type S = sig
  val two_sum : int array -> int -> int * int
end

let cases =
  [%of_sexp: (Sexp.t * Sexp.t) list] (Sexp.of_string
    {| ( (((2 7 11 15) 9) (0 1))
         (((3 2 4)     6) (1 2))
         (((3 3)        6) (0 1)) ) |})

module Make (Sol : S) = struct
  let call sexp =
    let nums, target = [%of_sexp: int array * int] sexp in
    [%sexp_of: int * int] (Sol.two_sum nums target)

  let run ~on_result = Problem_runner.run ~cases ~call ~on_result
end
