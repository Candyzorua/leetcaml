open Core

type test_case =
  { id : int
  ; input_repr : string
  ; expected_repr : string
  }

type t =
  { slug : string
  ; title : string
  ; test_cases : test_case list
  ; harness : string
  }

(* The harness is plain OCaml (no Jane Street deps) so it can be compiled
   together with the user's submission using bare ocamlopt. *)
let two_sum_harness =
  {|let () =
  let cases =
    [ ([|2;7;11;15|], 9,  (0, 1))
    ; ([|3;2;4|],     6,  (1, 2))
    ; ([|3;3|],       6,  (0, 1))
    ]
  in
  let normalize (a, b) = if a <= b then (a, b) else (b, a) in
  List.iteri (fun i (nums, target, expected) ->
    let got = two_sum nums target in
    if normalize got = normalize expected then
      print_endline "PASS"
    else
      Printf.printf "FAIL case %d: expected (%d,%d) got (%d,%d)\n"
        (i + 1)
        (fst expected) (snd expected)
        (fst got)      (snd got)
  ) cases
|}

let two_sum : t =
  { slug = "two-sum"
  ; title = "Two Sum"
  ; test_cases =
      [ { id = 1; input_repr = "nums=[2,7,11,15], target=9"; expected_repr = "(0,1)" }
      ; { id = 2; input_repr = "nums=[3,2,4], target=6";     expected_repr = "(1,2)" }
      ; { id = 3; input_repr = "nums=[3,3], target=6";       expected_repr = "(0,1)" }
      ]
  ; harness = two_sum_harness
  }

let all : t list = [ two_sum ]

let find slug = List.find all ~f:(fun p -> String.equal p.slug slug)
