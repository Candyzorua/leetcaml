open Core

let description = {|
Reverse Linked List
===================

Given the head of a singly linked list, reverse the list and return it.

A node is defined as:

  type node = { val_ : int; next : node option }

Example 1:  [1, 2, 3, 4, 5]  =>  [5, 4, 3, 2, 1]
Example 2:  [1, 2]           =>  [2, 1]
Example 3:  []               =>  []

Signature: val reverse : node option -> node option
|}

type node = { val_ : int; next : node option }

let rec to_list = function
  | None -> []
  | Some n -> n.val_ :: to_list n.next

let rec of_list = function
  | [] -> None
  | x :: xs -> Some { val_ = x; next = of_list xs }

module type S = sig
  val reverse : node option -> node option
end

let cases =
  [ [1;2;3;4;5], [5;4;3;2;1]
  ; [1;2],       [2;1]
  ; [],          []
  ; [1],         [1]
  ; [1;2;3],     [3;2;1]
  ]

module Make (Sol : S) = struct
  let run () =
    Problem_runner.run ~cases
      ~f:(fun vals -> to_list (Sol.reverse (of_list vals)))
      ~equal:[%equal: int list]
      ~sexp_of_output:[%sexp_of: int list]
end
