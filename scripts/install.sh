#!/bin/bash

# curl -k -L https://teavver.xyz/conf | bash

REPO_URL="https://api.github.com/repos/teavver/config/contents"
COMMIT_HASH=${1:-main} # Default to 'main'

download_file() {
    local file="$1"
    local download_url="$2"
    echo "downloading '$file' ..."
    curl -sSL "$download_url" -o "$file"
}

files=$(curl -sSL "$REPO_URL?ref=$COMMIT_HASH" | grep '"name":' | cut -d '"' -f 4 | grep '^\.')

echo "branch/commit: $COMMIT_HASH"
while read -r file; do
    if [ -e "$file" ]; then
        echo "file '$file' exists, skipping"
        continue
    fi
    download_url=$(curl -sSL "$REPO_URL/$file?ref=$COMMIT_HASH" | grep '"download_url":' | cut -d '"' -f 4)
    download_file "$file" "$download_url"
done <<< "$files"
echo "done"