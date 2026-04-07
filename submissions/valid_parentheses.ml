module Solution = struct
  let is_valid (s : string) : bool =
    let rec go stack i =
      if i >= String.length s then stack = []
      else
        match s.[i] with
        | '(' | '[' | '{' -> go (s.[i] :: stack) (i + 1)
        | ')' -> (match stack with '(' :: rest -> go rest (i + 1) | _ -> false)
        | ']' -> (match stack with '[' :: rest -> go rest (i + 1) | _ -> false)
        | '}' -> (match stack with '{' :: rest -> go rest (i + 1) | _ -> false)
        | _ -> false
    in
    go [] 0
end

let () =
  let module M = Leetcaml.Valid_parentheses.Make(Solution) in
  Leetcaml.Host.register (module M : Leetcaml.Host.Runner)
