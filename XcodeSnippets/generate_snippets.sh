#!/usr/bin/env bash
# Reads snippets.txt (format: Prefix<TAB>Content) and writes .codesnippet plist files.
# Content can use <#placeholder#>; they are preserved in the plist.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
INPUT="${SCRIPT_DIR}/snippets.txt"

escape_plist_string() {
  local s="$1"
  # XML in plist: escape & first, then < and >
  s="${s//&/&amp;}"
  s="${s//</&lt;}"
  s="${s//>/&gt;}"
  s="${s//\"/&quot;}"
  # Newlines stay as newlines in <string> element
  printf '%s' "$s"
}

while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" =~ ^# ]] && continue
  prefix="${line%%	*}"
  content="${line#*	}"
  [[ -z "$prefix" || -z "$content" ]] && continue
  content_escaped=$(escape_plist_string "$content")
  id=$(uuidgen | tr '[:upper:]' '[:lower:]')
  out="${SCRIPT_DIR}/${prefix}.codesnippet"
  cat > "$out" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>IDECodeSnippetCompletionPrefix</key>
	<string>${prefix}</string>
	<key>IDECodeSnippetCompletionScopes</key>
	<array>
		<string>All</string>
	</array>
	<key>IDECodeSnippetContents</key>
	<string>${content_escaped}</string>
	<key>IDECodeSnippetIdentifier</key>
	<string>${id}</string>
	<key>IDECodeSnippetLanguage</key>
	<string>Xcode.SourceCodeLanguage.Swift</string>
	<key>IDECodeSnippetSummary</key>
	<string>DesignSystem ${prefix}</string>
	<key>IDECodeSnippetTitle</key>
	<string>${prefix}</string>
	<key>IDECodeSnippetUserSnippet</key>
	<true/>
	<key>IDECodeSnippetVersion</key>
	<integer>2</integer>
</dict>
</plist>
PLIST
  echo "Generated ${prefix}.codesnippet"
done < "$INPUT"
echo "Done. Run install_snippets.sh then restart Xcode."
