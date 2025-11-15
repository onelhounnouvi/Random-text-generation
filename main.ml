open Modules
open Gene_alea

let () =
  Random.self_init ();
	
  (* 1. Récupérer les arguments passés par Streamlit *)
  let n_gram = 
    if Array.length Sys.argv > 1 then int_of_string Sys.argv.(1) else 2
  in
  let num_sentences = 
    if Array.length Sys.argv > 2 then int_of_string Sys.argv.(2) else 5
  in
  
  (* 2. Lecture de la ptable correspondant depuis le fichier binaire*)
  let filename = Printf.sprintf "bin/ptable%d.bin" n_gram in
  let ic = open_in_bin filename in
  let sauce_ptable = Marshal.from_channel ic in
  close_in ic;
  
  (* 3. Génère une phrase aléatoire *)
  
  let sentence = walk_ptable sauce_ptable num_sentences in
  print_endline (String.concat " " sentence)
