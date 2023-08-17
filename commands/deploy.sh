#!/bin/bash

# Check for uncommitted changes in the main branch
if ! git diff-index --quiet HEAD --; then
    echo "You have uncommitted changes. Please commit or stash them first."
    exit 1
fi

# Make sure we're in the main (or master) branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "You are not in the 'main' branch. Please switch to the main branch before running this script."
    exit 1
fi

# Build the project (assuming you have a build script to generate/refresh the /dist folder)
dune exec markaml

# Commit any potential changes after the build (Optional)
git add .
git commit -m "Committing changes before updating gh-pages"

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

# Return to the main branch
git checkout main

# Inform the user to push both main and gh-pages
echo "Update complete. Please push changes: git push --all"
