#!/usr/bin/env bash

lastdate=$(git show -s --format=%ad "$(git rev-list --tags --max-count=1)")
git log --oneline --pretty=format:"%ad: %s" --date=short --since="$lastdate"

