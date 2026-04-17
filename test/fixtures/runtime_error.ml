module Solution = struct
  let two_sum (_nums : int array) (_target : int) : int * int =
    failwith "broken"
end

let () =
  let module M = Leetcaml.Two_sum.Make (Solution) in
  Leetcaml.Host.register (module M : Leetcaml.Host.Runner)
