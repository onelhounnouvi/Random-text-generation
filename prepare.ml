open Modules
open Gene_alea
let n_gram = 3

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

  (* 2. Concatène le contenu de tous les fichiers en une seule grande chaîne *)
  let big_text =
    List.map string_of_file files
    |> String.concat " "
  in

  (* 3. Découpe en phrases et construit une unique ptable *)
  let phrases = sentences big_text in
  let sauce_ptable =
    merge_ptables (List.map (fun s -> build_ptable s n_gram) phrases)
  in
  
  (* 4. Sauvegarde binaire *)
  let oc = open_out_bin "ptable.bin" in
  Marshal.to_channel oc sauce_ptable [];
  close_out oc
