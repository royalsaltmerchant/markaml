# Markaml
This is a quick and dirty site generator that takes markdown files and produces html pages with a sidebar. 
The script is making use of Jingoo templates and the Omd markdown lib.
This is just a hobby project, if you want to add features feel free to make a PR.


## Generate

The command takes in two arguments
1. The folder location that contains all your markdown files to be generated.
2. The output directory.

Example: `dune exec markaml src/md dist`

## Hrefs
Headers are automatically populated with clickable link icons which correspond with their unique IDs. They appear when the cursor hovers over the header. Clicking them will copy the link to your clipboard as well as navigate.

## Sidebar
The script will replace characters; "-" and "_"  with " " from the title of the markdown file, as well as the suffix ".md" and capitalize each word in the title to produce each item on the sidebar. To ensure there are no issues, it is recommended to refrain from using spaces in your filenames.

