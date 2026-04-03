(* Two Sum
   Given an int array and a target, return indices of the two numbers
   that add up to target. *)
let two_sum (nums : int array) (target : int) : int * int =
  let n = Array.length nums in
  let result = ref (0, 0) in
  (try
     for i = 0 to n - 1 do
       for j = i + 1 to n - 1 do
         if nums.(i) + nums.(j) = target then begin
           result := (i, j);
           raise Exit
         end
       done
     done
   with Exit -> ());
  !result
