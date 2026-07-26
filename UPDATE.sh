#!/usr/bin/env bash

set -euo pipefail

branch="${1:-main}"
remote="${2:-origin}"

product_name="Dideban Platform"
repository_url="https://github.com/hamedpourheydari/dideban-platform"

echo "Updating ${product_name}..."
echo "Remote: ${remote}"
echo "Branch: ${branch}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: This directory is not a Git repository."
    exit 1
fi

if ! git remote get-url "${remote}" >/dev/null 2>&1; then
    echo "Error: Git remote '${remote}' does not exist."
    exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: Local changes were detected."
    echo "Commit or stash your changes before updating."
    exit 1
fi

current_branch="$(git branch --show-current)"

if [ "${current_branch}" != "${branch}" ]; then
    echo "Switching from '${current_branch}' to '${branch}'..."
    git checkout "${branch}"
fi

echo "Fetching latest changes..."
git fetch "${remote}" "${branch}"

echo "Applying updates..."
git pull --ff-only "${remote}" "${branch}"

git_version_number="$(git rev-parse HEAD)"
current_date="$(date --iso-8601=seconds 2>/dev/null || date)"

cat > version.json <<EOF
{
    "Product": "${product_name}",
    "Branch": "${branch}",
    "Version": "${git_version_number}",
    "Date": "${current_date}",
    "Repository": "${repository_url}"
}
EOF

chmod 644 version.json

echo "${product_name} was updated successfully."
echo "Restart Dideban for the changes to take effect."