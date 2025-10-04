open Modules
open Gene_alea

let () =
  Random.self_init ();
	
  (* 1. Lecture de la ptable depuis le fichier binaire*)
  let ic = open_in_bin "ptable.bin" in
  let sauce_ptable = Marshal.from_channel ic in
  close_in ic;

  (* 2. Génère une phrase aléatoire *)
  let sentence = walk_ptable sauce_ptable in
  print_endline (String.concat " " sentence)
