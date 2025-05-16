#!/bin/bash

# Repos
REPOS=("togetherwe-app" "togetherwe-backend" "togetherwe-website")
OWNER="Integritylanddevelopment"

# GitHub labels setup
declare -A LABELS
LABELS["bug"]="d73a4a|Something isn't working"
LABELS["feature"]="a2eeef|New functionality or feature request"
LABELS["documentation"]="0075ca|Improvements or additions to docs"
LABELS["good first issue"]="7057ff|Good for newcomers"
LABELS["help wanted"]="008672|Extra attention is needed"
LABELS["question"]="d876e3|Further information is requested"
LABELS["enhancement"]="a2eeef|Improvement to existing feature"
LABELS["wontfix"]="ffffff|This will not be addressed"

# Loop through each repo
for REPO in "${REPOS[@]}"; do
  echo "Applying settings to $REPO..."

  # Set default branch
  gh repo edit "$OWNER/$REPO" --default-branch main

  # Enable issues, wiki, and delete-branch-on-merge
  gh repo edit "$OWNER/$REPO" --enable-issues --enable-wiki --enable-projects
  gh api -X PATCH "repos/$OWNER/$REPO" -f delete_branch_on_merge=true

  # Add labels
  for LABEL in "${!LABELS[@]}"; do
    IFS='|' read -r COLOR DESC <<< "${LABELS[$LABEL]}"
    gh label create "$LABEL" --color "$COLOR" --description "$DESC" --repo "$OWNER/$REPO" || echo "Label $LABEL may already exist"
  done
done

echo "All settings and labels applied."