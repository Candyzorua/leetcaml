open Leetcaml.Reverse_linked_list

module Solution = struct
  let reverse (head : node option) : node option =
    let rec go acc = function
      | None -> acc
      | Some n -> go (Some { val_ = n.val_; next = acc }) n.next
    in
    go None head
end

let () =
  let module M = Make(Solution) in
  Leetcaml.Host.register (module M : Leetcaml.Host.Runner)
