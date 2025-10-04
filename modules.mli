(** Liste d’associations *)
type ltable = (string * string list) list

(** Map immuable de string vers 'a *)
module STable : Map.S with type key = String.t

(** Map immuable de string list vers 'a *)
module PTable : Map.S with type key = string list

(** Distribution d’occurrences pour un mot donné *)
type distribution = {
  total   : int;
  amounts : (string * int) list;
}

(** Table de distributions indexée par string *)
type stable = distribution STable.t

(** Table de distributions pour les préfixes de longueur fixe *)
type ptable = {
  prefix_length : int;
  table         : distribution PTable.t;
}

val multi_3 : string
