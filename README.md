# LeetCaml

A local LeetCode simulator for OCaml.

## Usage

```bash
# See a problem description
dune exec leetcaml -- describe two-sum

# Run your solution
dune exec leetcaml -- run submissions/two_sum.ml
```

### Writing a Solution

Each submission is a standalone `.ml` file with a `Solution` module, in which your solution should be added. Do not modify the functor call at the bottom of the file.

```ocaml
module Solution = struct
  let two_sum (nums : int array) (target : int) : int * int =
    (* your solution here *)
end

let () =
  let module M = Leetcaml.Two_sum.Make(Solution) in
  Leetcaml.Host.register (module M : Leetcaml.Host.Runner)
```

## Verdicts

| Verdict | Meaning |
|---------|---------|
| **Accepted** | All test cases passed |
| **Wrong Answer** | Output didn't match expected for a test case |
| **Runtime Error** | Exception raised during execution |
| **Compile Error** | Solution failed to compile |

## How It Works

1. Your solution is compiled to a shared library (`.cmxs`)
2. The host binary loads it via `Dynlink`
3. The solution registers itself through a functor that wires up test cases
4. The judge runs the tests and reports results

## Setup

Requires OCaml 5.x and opam packages: `base`, `core`, `core_unix`, `ppx_jane`.

```bash
opam install base core core_unix ppx_jane
dune build
```

## Available Problems

| Slug | Problem |
|------|---------|
| `two-sum` | Two Sum |
| `reverse-linked-list` | Reverse Linked List |
| `valid-parentheses` | Valid Parentheses |
| `max-subarray` | Maximum Subarray |

More problems to be added soon.