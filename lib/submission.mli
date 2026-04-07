open Core

type t

val create : string -> t Or_error.t
val path : t -> string
