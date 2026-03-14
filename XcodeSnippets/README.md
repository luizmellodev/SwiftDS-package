# Xcode Snippets for SwiftDS

**OPTIONAL FEATURE** - SwiftDS components are already available in Xcode's Library (⌘⇧L) without any setup!

These autocomplete snippets provide an **alternative workflow** for faster typing with Tab navigation between placeholders.

## Do You Need This?

**NO** - All SwiftDS components automatically appear in Xcode's Library (⌘⇧L) when you install the package. You can drag and drop them without any configuration.

**Install snippets only if you want:**
- Faster autocomplete (type `dsbadge` + Tab)
- Editable placeholders with Tab navigation
- Snippets in projects that don't use SwiftDS

## Installation

```bash
./install_snippets.sh
```

Then **restart Xcode**. Now you can type `DSButton`, `DSChip`, etc. and Xcode will autocomplete!

## Check Missing Snippets

See which components don't have snippets yet:

```bash
./check_missing_snippets.sh
```

This script:
- Lists all DS components (Views) without snippets
- Shows orphaned snippets (snippet exists but component doesn't)
- Filters out enums/types (only shows actual View components)

## Adding New Snippets

1. Edit `snippets.txt` with format:
   ```
   ComponentName<TAB>ComponentName(param: <#value#>)
   ```

2. Generate `.codesnippet` files:
   ```bash
   ./generate_snippets.sh
   ```

3. Install to Xcode:
   ```bash
   ./install_snippets.sh
   ```

4. Restart Xcode

## Example Entry

```
DSChip	DSChip("<#Title#>", variant: .<#filled#>, isSelected: <#false#>) { <#action#> }
```

- First column: completion prefix (what you type)
- Second column: the code to insert (use `<#placeholder#>` for tab stops)
- Separator: **TAB character** (not spaces!)

## Current Status

Run `./check_missing_snippets.sh` to see the latest count.

As of last check:
- 103 DS View components
- 59 snippets created
- 46 components missing snippets
- 2 orphaned snippets

## Cleaning Up

If `check_missing_snippets.sh` shows orphaned snippets, remove them from `snippets.txt` and re-run `./generate_snippets.sh`.
