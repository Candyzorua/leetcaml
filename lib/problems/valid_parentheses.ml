open Core

let description =
  {|
Valid Parentheses
=================

Given a string containing only the characters '(', ')', '{', '}', '[' and ']',
determine if the input string is valid.

A string is valid if:
  - Open brackets are closed by the same type of brackets.
  - Open brackets are closed in the correct order.
  - Every close bracket has a corresponding open bracket.

Example 1:  "()"     =>  true
Example 2:  "()[]{}" =>  true
Example 3:  "(]"     =>  false
Example 4:  "([])"   =>  true

Signature: val is_valid : string -> bool
|}

module type S = sig
  val is_valid : string -> bool
end

let cases =
  [
    ("()", true);
    ("()[]{}", true);
    ("(]", false);
    ("([])", true);
    ("", true);
    ("([)]", false);
    ("{[]}", true);
    ("(((", false);
    ("({[]})", true);
  ]

module Make (Sol : S) = struct
  let run () =
    Problem_runner.run ~cases ~f:Sol.is_valid ~equal:Bool.equal
      ~sexp_of_output:[%sexp_of: bool] ~time_limit_ms:5000
end
