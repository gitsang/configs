#!/bin/bash

ADD="Add"
RESET="Reset"
DELETE="Delete"

ACTION=$(gum choose "$ADD" "$RESET" "$DELETE")

if [ "$ACTION" == "$ADD" ]; then
  git status --short | cut -c 4- | gum choose --no-limit | xargs git add
elif [ "$ACTION" == "$DELETE" ]; then
  git status --short | cut -c 4- | gum choose --no-limit | xargs git rm -r --cached
else
  git status --short | cut -c 4- | gum choose --no-limit | xargs git restore
fi
