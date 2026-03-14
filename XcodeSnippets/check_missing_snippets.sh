#!/usr/bin/env bash
# Checks which DS components are missing Xcode snippets.
# Scans all public structs/enums in Components/ and compares with snippets.txt

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPONENTS_DIR="${SCRIPT_DIR}/../Sources/DesignSystem/Components"
SNIPPETS_FILE="${SCRIPT_DIR}/snippets.txt"

echo "🔍 Scanning for DS components (Views only)..."
echo ""

# Extract all public struct names that start with DS and are Views
# We look for "public struct DSXxx: View" or "public struct DSXxx<...>: View"
components=$(find "$COMPONENTS_DIR" -name "*.swift" -type f -exec grep -h "^public struct DS.*: View" {} \; | \
  sed -E 's/^public struct (DS[A-Za-z0-9]+).*/\1/' | \
  sort -u)

# Extract snippet prefixes from snippets.txt (first column before TAB)
snippets=$(grep -v "^#" "$SNIPPETS_FILE" 2>/dev/null | grep -v "^$" | cut -f1 | sort -u)

echo "📦 Found $(echo "$components" | wc -l | xargs) DS components"
echo "📝 Found $(echo "$snippets" | wc -l | xargs) snippets in snippets.txt"
echo ""

missing=()
while IFS= read -r component; do
  if ! echo "$snippets" | grep -q "^${component}$"; then
    missing+=("$component")
  fi
done <<< "$components"

if [ ${#missing[@]} -eq 0 ]; then
  echo "✅ All DS components have snippets!"
else
  echo "⚠️  Missing snippets for ${#missing[@]} component(s):"
  echo ""
  for comp in "${missing[@]}"; do
    echo "  - $comp"
  done
  echo ""
  echo "💡 To add them, edit snippets.txt with format:"
  echo "   ComponentName<TAB>ComponentName(param: <#value#>)"
  echo ""
  echo "   Then run: ./generate_snippets.sh"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check for orphaned snippets (snippets that don't have a corresponding component)
orphaned=()
while IFS= read -r snippet; do
  if ! echo "$components" | grep -q "^${snippet}$"; then
    orphaned+=("$snippet")
  fi
done <<< "$snippets"

if [ ${#orphaned[@]} -eq 0 ]; then
  echo "✅ No orphaned snippets (all snippets have matching components)"
else
  echo "🗑️  Orphaned snippets (${#orphaned[@]}) — component no longer exists:"
  echo ""
  for snip in "${orphaned[@]}"; do
    echo "  - $snip"
  done
  echo ""
  echo "💡 Consider removing these from snippets.txt"
fi
