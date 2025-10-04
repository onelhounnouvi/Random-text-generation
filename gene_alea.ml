open Modules

(* -- Part A -------------------------------------------------------------- *)

let is_letter (c : char) : bool =
  ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z')
  
let words str =
  let len = String.length str in
  let rec loop (idx : int) (mot : string) (acc: string list) =
    (*Fin de texte, on rajoute STOP + le mot courant et on renvoie la liste*)
    if idx = len then List.rev ("STOP"::mot::acc)
    else if is_letter str.[idx] 
    (*Si c'est une lettre, conversion en string et concaténation à mot*)
    then let s = String.make 1 str.[idx] in loop (idx + 1) (mot ^ s) acc 
    (*Sinon = séparateur donc ajout du mot à la liste*)
    else loop (idx+1) "" (mot::acc)
  in
  "START"::(loop 0 "" []) 
    
let build_ltable words = 
  let rec loop words acc = 
    match words with
    |[] -> List.rev acc 
    |mot::mot_suivant::t -> 
        if List.mem_assoc mot acc then
          let lmots = List.assoc mot acc in
          let acc = List.remove_assoc mot acc in
          loop (mot_suivant::t) ((mot, (mot_suivant::lmots))::acc)
            (*On ajoute mot_suivant à la liste des successeurs*)
        else
          loop (mot_suivant::t) ((mot, [mot_suivant])::acc)
            (*Sinon, on cree une liste de successeurs contenant mot_suivant*)
    | [_] -> List.rev acc
  in
  loop words []

let next_in_ltable table word =
  if List.mem_assoc word table then
    let lsucc = List.assoc word table in
    List.nth lsucc (Random.int (List.length lsucc)) (*Choix aléatoire*)
  else raise Not_found

let walk_ltable table = 
  let rec loop mot acc = 
    let new_mot = next_in_ltable table mot in
    if new_mot = "STOP" then List.rev acc 
    else loop new_mot (new_mot::acc)
  in
  loop "START" []
  

(* -- Part B -------------------------------------------------------------- *)

let compute_distribution l = 
  {total = List.length l; 
   amounts = 
     let rec loop l acc = 
       match l with
       |[] -> acc
       |mot::t -> 
           if List.mem_assoc mot acc then 
  (*Si le mot appartient déjà à la table d'assoc, maj du nombre d'occurrences*)
             let n = List.assoc mot acc in
             let acc = List.remove_assoc mot acc in
             loop t ((mot,(n+1))::acc)
           else 
  (*Sinon, nouvelle assoc avec nb_occur = 1*)
             loop t ((mot, 1)::acc)
     in loop l []
  }
    
  
let build_stable words = 
  (*Exactement comme build_ltable mais en utilisant les fonctions du module 
    STable offertes par Map*)
  let rec loop words acc =
    match words with 
    |[] -> acc
    |mot::mot_suivant::t -> 
        if STable.mem mot acc then
          let lmots = STable.find mot acc in
          let acc = STable.remove mot acc in
          loop (mot_suivant::t) (STable.add mot (mot_suivant::lmots) acc)
        else
          loop (mot_suivant::t) (STable.add mot [mot_suivant] acc)
    |[_] -> acc 
  in
  let l = loop words STable.empty in
  (*Appliquer compute_distribution à chaque liste*)
  STable.map compute_distribution l
      
    
let tirage_pondere (dist : distribution) : string =
  let total_f = float_of_int dist.total in
  let r = Random.float 1.0 in
  let rec choisir dist acc =
    match dist with
    | [] -> raise Not_found
    | (mot, nb)::t ->
        let p = float_of_int nb /. total_f in
        if r < acc +. p then mot else choisir t (acc +. p)
  in
  choisir dist.amounts 0.0
    
    
let next_in_stable (table : stable) (word : string) : string =
  (*On trouve la distribution correspondant à word et fait un tirage pondéré*)
  match STable.find_opt word table with
  | Some dist -> tirage_pondere dist
  | None -> raise Not_found

      
let walk_stable table =
  let rec loop mot acc = 
    let new_mot = next_in_stable table mot in
    if new_mot = "STOP" then List.rev acc 
    else loop new_mot (new_mot::acc)
  in
  loop "START" []

    
(* -- Part C -------------------------------------------------------------- *)

let is_in_word(c : char) : bool =
  (is_letter c) || ('0' <= c && c <= '9') || ('\128' <= c && c <= '\255')

let is_word (c : char) : bool =
  List.mem c [';'; ','; ':'; '-'; '"'; '\''; '?'; '!'; '.']
    
let end_sentence (c : char) : bool =
  List.mem c ['?'; '!'; '.']
    
    
let sentences (str : string) : string list list =
  let len = String.length str in
  let rec loop idx mot phrase acc =
    if idx = len then
      (*A la fin de la phrase, on vérifie qu'il n'y a ni phrase ni mot vides*)
      if mot = "" && phrase = [] then List.rev acc
      else List.rev ((List.rev (if mot = "" then phrase else mot::phrase))::acc)
    else
      let c = str.[idx] in
      if end_sentence c then
        (*Si on est à la fin d'une phrase, on ajoute la liste construite 
          + le mot courant (si non vide) à phrase*)
        let s = String.make 1 c in
        let new_phrase = if mot = "" then s::phrase else s::mot::phrase in
        loop (idx + 1) "" [] (List.rev new_phrase::acc)
      else if is_word c then
        (*Si c'est un mot, on l'ajoute à la phrase*)
        let s = String.make 1 c in
        let new_phrase = if mot = "" then s::phrase else s::mot::phrase in
        loop (idx + 1) "" new_phrase acc
      else if is_in_word c then
        (*Si c'est une lettre, on l'ajoute au mot*)
        let s = String.make 1 c in
        loop (idx + 1) (mot ^ s) phrase acc
      else
        (*Sinon, c'est un séparateur, on ajoute donc le mot courant 
        à phrase s'il est non vide*)
        let new_phrase = if mot = "" then phrase else mot::phrase in
        loop (idx + 1) "" new_phrase acc
  in
  loop 0 "" [] []

    
let rec start pl =
  match pl with
  |0 -> []
  |_ -> "START"::start (pl - 1)

          
let shift l x = 
  match l with 
  |[] -> [x]
  |_::ls -> ls@[x] 
 
 
let update_dist (d : distribution) (w : string) : distribution =
  let rec loop l =
    match l with
    | [] -> [(w,1)]  (*Si distribution vide, nouvelle assoc avec occur = 1*)
    | (k,n)::ls ->
        if k = w then (k,n+1)::ls (*Si assoc trouvée, maj du nb d'occurences*)
        else (k,n)::loop ls    (*Sinon, la recherche continue*)
  in
  { total = d.total + 1; amounts = loop d.amounts }


let build_ptable (words : string list) (pl : int) : ptable =
  let rec aux prefix tbl words =
    (*On récupère la distribution pour ce préfixe*)
    let dist =
      match PTable.find_opt prefix tbl with
      | Some d -> d
      | None -> { total = 0; amounts = [] }
    in
    match words with 
    (*Fin de la liste : ajoute un STOP à la table et fait une maj de dist*)
    | [] -> PTable.add prefix (update_dist dist "STOP") tbl 
    | w::ws ->
        (*Ajoute le mot w à la table et fait une maj de dist*)
        let new_tbl = PTable.add prefix (update_dist dist w) tbl in
        (*Trouve le préfixe suivant grâce à la fonction shift*)
        let pref_suiv  = shift prefix w in
        aux pref_suiv new_tbl ws
  in
  (*On part du prefixe initial start pl = [START, START,....]*)
  let tablef = aux (start pl) PTable.empty words in
  { prefix_length = pl; table = tablef }
  
  
let walk_ptable { table; prefix_length = pl } : string list =
  (*Probabilité de relancer la fonction pour avoir plusieurs phrases*)
  let p_continue = 0.7 in
  
  let rec aux prefix acc =
    match PTable.find_opt prefix table with
    | None -> List.rev acc (*Table vide -> renvoie le paragraphe construit*)
    | Some dist ->
        let w = tirage_pondere dist in (*On tire un mot suivant aléatoire*)
        if w = "STOP" then 
          if Random.float 1.0 < p_continue then    
            (*on repart sur un préfixe [START,…]*)
            aux (start pl) acc
          else
            (* on arrête vraiment *)
            List.rev acc
        else aux (shift prefix w) (w::acc)
  in
  aux (start pl) []


exception Prefix_length_mismatch 
                                 
(*Fonction ajoutée : fusion de 2 distributions*)
let merge_dist d1 d2 =
  {total = d1.total + d2.total; (*additionne les 2 totaux*)
   amounts =
     (*on parcourt chaque (mot, n2) de d2.amounts et on l'ajoute à d1.amounts*)
     List.fold_left
       (fun acc (w,n2) ->
          (*recherche l'ancienne valeur n1 dans acc, ou 0 s'il n'existe pas*)
          let n1 = try List.assoc w acc with Not_found -> 0 in
          (*MAJ acc : supprime (mot, n1) et 
                      ajoute la nouvelle paire (mot, n1 + n2)*)
          (w, n1 + n2)::List.remove_assoc w acc)
       d1.amounts
       d2.amounts
  }  
  

let merge_tables : distribution PTable.t -> distribution PTable.t -> distribution PTable.t =
  PTable.merge (fun _ d1 d2 ->
      match d1, d2 with
      | None, None -> None
      | Some d, None | None, Some d  -> Some d
      | Some d1, Some d2 -> Some (merge_dist d1 d2)
    )
    
  
let merge_ptables (tl : ptable list) : ptable =
  match tl with 
  (*aucune table → ptable vide *)
  | [] -> { prefix_length = 0; table = PTable.empty } 
  (*Sinon, on prend la première ptable comme accumulateur*)
  | pt::pts ->
      List.fold_left
        (fun acc pt -> 
           (*On vérifie la cohérence des longueurs de prefixe*)
           if pt.prefix_length <> acc.prefix_length 
           then raise Prefix_length_mismatch 
           (*fusionne les PTable.t de distributions de acc et pt*)
           else
             { prefix_length = acc.prefix_length
             ; table  = merge_tables acc.table pt.table
             }
        )
        pt
        pts
