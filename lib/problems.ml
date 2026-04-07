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

let reverse_linked_list =
  { slug        = "reverse-linked-list"
  ; title       = "Reverse Linked List"
  ; description = Reverse_linked_list.description
  }

let all = [ two_sum; reverse_linked_list ]

let find slug = List.find all ~f:(fun p -> String.equal p.slug slug)
