#!/usr/bin/env bash
# Points /usr/share/ublue-os/image-info.json at the Bastion image instead of
# Bazzite's, so the welcome banner and Universal Blue tools name the right image.
set -euo pipefail

OWNER="seabastien"   # GitHub username that publishes the images
INFO=/usr/share/ublue-os/image-info.json

# The NVIDIA base image's name contains "nvidia"; use that to pick our variant.
base_name=$(jq -r '."image-name"' "$INFO")
if [[ "$base_name" == *nvidia* ]]; then
    name="bastion-nvidia"
else
    name="bastion-os"
fi

tmp=$(mktemp)
jq --arg name "$name" \
   --arg vendor "$OWNER" \
   --arg ref "ostree-image-signed:docker://ghcr.io/${OWNER}/${name}" \
   '."image-name" = $name | ."image-vendor" = $vendor | ."image-ref" = $ref' \
   "$INFO" > "$tmp"
cat "$tmp" > "$INFO"
rm -f "$tmp"

echo "image-info.json now names ${OWNER}/${name} (base was ${base_name})"
