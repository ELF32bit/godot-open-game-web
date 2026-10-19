#!/bin/bash

gh auth login
REPO="ELF32bit/godot-open-game-web"

IDS=$(gh api --method GET \
	"/repos/$REPO/deployments?per_page=100" | jq -r '.[] | .id')

if [ -z "$IDS" ]; then
	exit 0
fi

for ID in $IDS; do
	gh api --method POST /repos/$REPO/deployments/$ID/statuses \
		-H "Accept: application/vnd.github+json" \
		-f "state=inactive" > /dev/null 2>&1

	echo "Deleting: $ID..."
	gh api --method DELETE /repos/$REPO/deployments/$ID \
		-H "Accept: application/vnd.github+json" > /dev/null 2>&1
done

gh api --method POST \
	"/repos/$REPO/pages/builds"
