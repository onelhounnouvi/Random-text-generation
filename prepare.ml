open Modules
open Gene_alea

let string_of_file filename =
	(* ouvre le canal en lecture *)
	let ic = open_in filename in
	let len = in_channel_length ic in
	(* lit len octets *)
	let content = really_input_string ic len in
	close_in ic;
	content

let () =
  Random.self_init ();

  (* 1. Récupère tous les livres du dossier books *)
  let files =
    Sys.readdir "books"
    |> Array.to_list
    |> List.map (Filename.concat "books")
  in

  (* 2. Construit une ptable par fichier *)
  let ptables =
    List.map (fun f ->
      let phrases = sentences (string_of_file f) in
      merge_ptables (List.map (fun s -> build_ptable s 2) phrases)
    ) files
  in

  (* 3. Fusionne toutes les ptables en une seule *)
  let sauce_ptable = merge_ptables ptables in
  
  (* 4. Sauvegarde binaire *)
  let oc = open_out_bin "ptable.bin" in
  Marshal.to_channel oc sauce_ptable [];
  close_out oc
