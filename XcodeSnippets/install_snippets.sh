#!/usr/bin/env bash
# Copies DesignSystem .codesnippet files to Xcode's user snippets folder.
# Run from DesignSystem/ or from XcodeSnippets/. Restart Xcode after installing.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# If run from DesignSystem/, snippets are in XcodeSnippets/; if run from XcodeSnippets/, use current dir.
if [[ -d "$SCRIPT_DIR/XcodeSnippets" ]]; then
  SOURCE_DIR="$SCRIPT_DIR/XcodeSnippets"
else
  SOURCE_DIR="$SCRIPT_DIR"
fi
DEST="${HOME}/Library/Developer/Xcode/UserData/CodeSnippets"
mkdir -p "$DEST"
count=0
for f in "$SOURCE_DIR"/*.codesnippet; do
  [[ -e "$f" ]] || continue
  cp "$f" "$DEST/"
  ((count++)) || true
done
echo "Installed $count snippet(s) to $DEST"
echo "Restart Xcode to load the new snippets."
