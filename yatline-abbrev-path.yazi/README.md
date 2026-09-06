# yatline-abbrev-path.yazi

A [yatline.yazi](https://github.com/imsi32/yatline.yazi) add-on that replaces the `tab_path` component with one that abbreviates long pathnames by shortening intermediate directory names to their first letter, e.g. `~/Research/Documents/timetabling/AY2026/final` → `~/R/D/t/A/final`.

## Configuration

In your `init.lua`, require it after yatline's setup:

```lua
require("yatline"):setup({ ... })
require("yatline-abbrev-path"):setup()
```

Add the component to your yatline header or status line configuration:

```lua
-- Full path, no abbreviation
{ type = "string", custom = false, name = "abbrev_tab_path" },

-- Abbreviate if path exceeds 30 characters
{ type = "string", custom = false, name = "abbrev_tab_path", params = { 30 } },
```

## Examples

Given the path `~/Research/Documents/timetabling/AY2026/final`:

| `max_len` | Result |
|---|---|
| none | `~/Research/Documents/timetabling/AY2026/final` |
| 40 | `~/R/D/t/AY2026/final` |
| 25 | `~/R/D/t/A/final` |
| 15 | `~/R/D/t/A/f` |

