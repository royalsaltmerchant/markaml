open Jingoo

let read_file filename =
  let ic = open_in filename in
  let n = in_channel_length ic in
  let s = really_input_string ic n in
  close_in ic;
  s

let change_suffix filename =
  try
    Filename.chop_suffix filename ".md" ^ ".html"
  with Invalid_argument _ -> filename

let without_suffix filename =
  try
    Filename.chop_suffix filename ".md"
  with Invalid_argument _ -> filename (* In case the suffix does not exist *)

let with_spaces input_string = Str.global_replace (Str.regexp "[-_]") " " input_string

let capitalize_each_word str =
  let words = Str.split (Str.regexp " +") str in
  let capitalized_words = List.map String.capitalize_ascii words in
  String.concat " " capitalized_words

let get_title filename = 
  capitalize_each_word @@ with_spaces @@ without_suffix filename

let replace_spaces_with_dashes str =
  Str.global_replace (Str.regexp " ") "-" str
let extract_headings filename =
  let input_path = Sys.argv.(1) ^ "/" ^ filename in
  let raw_markdown = read_file input_path in
  let heading_regex = Str.regexp "^\\(#+\\) \\(.*\\)$" in
  let lines = Str.split (Str.regexp "\n") raw_markdown in
  let headings = List.filter_map (fun line ->
      if Str.string_match heading_regex line 0 then
        let title = Str.matched_group 2 line in
        let path = 
          let file_name str = 
            let idx = String.rindex str '/' in
            String.sub str (idx + 1) ((String.length str) - idx - 1)
          in
          let updated_path = change_suffix @@ file_name input_path in
          (updated_path ^ "#" ^ replace_spaces_with_dashes title) 
        in
        Some (Jg_types.Tobj [
          ("title", Jg_types.Tstr title);
          ("path", Jg_types.Tstr path);
        ])
      else
        None
    ) lines in

    Jg_types.Tlist headings

let handle_pages filename sidebar_items headings =
  let input_path = Sys.argv.(1) ^ "/" ^ filename in
  let raw_markdown = read_file input_path in
  let parsed_md = Omd.of_string raw_markdown in
  let html_output = Omd.to_html parsed_md in
  let jingoo_output = Jg_template.from_file "src/default.jingoo.html" ~models:[("inside", Jg_types.Tstr html_output); ("headings", Jg_types.Tarray headings); ("sidebar_items", Jg_types.Tarray sidebar_items); ("title", Jg_types.Tstr (get_title filename))] in
  let oc = open_out @@ Filename.concat Sys.argv.(2) @@ change_suffix filename in
  output_string oc jingoo_output;
  close_out oc

let handle_sidebar_items filename =   
  Jg_types.Tstr ("<a id=\"nav-item-" ^ (capitalize_each_word @@ with_spaces @@ without_suffix filename) ^ "\" href=\"./" ^ (with_spaces @@ change_suffix filename) ^ "\">" ^ (capitalize_each_word @@ with_spaces @@ without_suffix filename) ^ "</a>")



let main () =
  if Array.length Sys.argv < 3 then (
    print_endline "You must provide two arguments for input dir and ouput dir";
    None)
  else
    Some(
      try
        let files_in_dir = Sys.readdir Sys.argv.(1) in
        (*first create sidebar*)
        let sidebar_items = Array.map handle_sidebar_items files_in_dir in
        (*create searchable headings*)
        let headings =  Array.map extract_headings files_in_dir in
        (*then create pages*)
        Array.iter (fun filename -> handle_pages filename sidebar_items headings) files_in_dir;
        (*copy other assets to dist*)
        let css_file = read_file "src/style.css" in
        let oc_css = open_out @@ Filename.concat Sys.argv.(2) "style.css" in
        output_string oc_css css_file;
        close_out oc_css;

        let js_file = read_file "src/index.js" in
        let oc_js = open_out @@ Filename.concat Sys.argv.(2) "index.js" in
        output_string oc_js js_file;
        close_out oc_js
      with Sys_error e ->
        Printf.printf "There was an error: %s\n" e
    )

let () =
  match main () with
  | Some () -> exit 0
  | None ->
      print_endline "Stopped because there was not a command line arg passed"
