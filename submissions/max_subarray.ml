module Solution = struct
  let max_subarray (nums : int array) : int =
    let current = ref nums.(0) in
    let best = ref nums.(0) in
    for i = 1 to Array.length nums - 1 do
      current := max nums.(i) (!current + nums.(i));
      best := max !best !current
    done;
    !best
end

let () =
  let module M = Leetcaml.Max_subarray.Make(Solution) in
  Leetcaml.Host.register (module M : Leetcaml.Host.Runner)
