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

let valid_parentheses =
  { slug        = "valid-parentheses"
  ; title       = "Valid Parentheses"
  ; description = Valid_parentheses.description
  }

let max_subarray =
  { slug        = "max-subarray"
  ; title       = "Maximum Subarray"
  ; description = Max_subarray.description
  }

let all = [ two_sum; reverse_linked_list; valid_parentheses; max_subarray ]

let find slug = List.find all ~f:(fun p -> String.equal p.slug slug)
