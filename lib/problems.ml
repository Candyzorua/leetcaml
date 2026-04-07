open Core

type t =
  { slug        : string
  ; title       : string
  ; description : string
  }

let two_sum =
  { slug        = "two-sum"
  ; title       = "Two Sum"
  ; description = Two_sum.description
  }

let all = [ two_sum ]

let find slug = List.find all ~f:(fun p -> String.equal p.slug slug)
