open Core

let description = {|
Maximum Subarray
================

Given an integer array, find the subarray with the largest sum and return
its sum.

Example 1:  [-2,1,-3,4,-1,2,1,-5,4]  =>  6
            (the subarray [4,-1,2,1] has the largest sum)
Example 2:  [1]                       =>  1
Example 3:  [5,4,-1,7,8]             =>  23

Signature: val max_subarray : int array -> int
|}

module type S = sig
  val max_subarray : int array -> int
end

let cases =
  [ [|-2;1;-3;4;-1;2;1;-5;4|],  6
  ; [|1|],                       1
  ; [|5;4;-1;7;8|],             23
  ; [|-1|],                     -1
  ; [|-2;-1|],                  -1
  ; [|1;2;3;4|],                10
  ; [|-1;-2;-3;-4|],            -1
  ]

module Make (Sol : S) = struct
  let run () =
    Problem_runner.run ~cases
      ~f:Sol.max_subarray
      ~equal:Int.equal
      ~sexp_of_output:[%sexp_of: int]
end
