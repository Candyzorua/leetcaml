open Core

module type S = sig
  val two_sum : int array -> int -> int * int
end

module Make (Sol : S) = struct
  let run ~on_result =
    let cases =
      [ ([|2;7;11;15|], 9,  (0, 1))
      ; ([|3;2;4|],     6,  (1, 2))
      ; ([|3;3|],       6,  (0, 1))
      ]
    in
    let normalize (a, b) = if a <= b then (a, b) else (b, a) in
    List.iteri cases ~f:(fun i (nums, target, expected) ->
      let got    = Sol.two_sum nums target in
      let passed = [%equal: int * int] (normalize got) (normalize expected) in
      let msg    =
        if passed then ""
        else
          Printf.sprintf "expected (%d,%d) got (%d,%d)"
            (fst expected) (snd expected)
            (fst got)      (snd got)
      in
      on_result ~case_id:(i + 1) ~passed ~msg)
end
