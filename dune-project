(lang dune 3.21)

(name leetcaml)

(generate_opam_files true)

(package
 (name leetcaml)
 (synopsis "A local LeetCode-style judge for OCaml submissions")
 (depends
  ocaml
  base
  stdio
  core
  core_unix
  async
  ppx_jane))
