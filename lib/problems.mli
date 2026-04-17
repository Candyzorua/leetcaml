type t = { slug : string; title : string; description : string }

val all : t list
val find : string -> t option
