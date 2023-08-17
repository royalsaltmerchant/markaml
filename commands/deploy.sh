#!/bin/bash

# Move to gh-pages branch
git checkout gh-pages

# Bring gh-pages up to date with main
git merge main --no-edit

# Remove all files and directories except the dist folder
find . -maxdepth 1 ! -name 'dist' ! -name '.git' ! -name '.gitignore' -exec rm -rf {} \;

# Move the content of the dist folder to the root directory
mv dist/* .

# Add and commit the changes to gh-pages
git add .
git commit -m "Update content from dist folder"
# Push to gh
git push origin head
