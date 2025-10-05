(** Liste d’associations *)
type ltable = (string * string list) list

(** Map immuable de string vers 'a *)
module STable = Map.Make(String)

(** Map immuable de string list vers 'a *)
module PTable = Map.Make(struct
    type t = string list
    let compare = compare
  end)

(** Distribution d’occurrences pour un mot donné *)
type distribution =
  { total : int ;
    amounts : (string * int) list }
    
(** Table de distributions indexée par string *)
type stable = distribution STable.t

(** Table de distributions pour les préfixes de longueur fixe *)
type ptable =
  { prefix_length : int ;
    table : distribution PTable.t }
