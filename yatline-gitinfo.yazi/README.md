# yatline-gitinfo.yazi

A [yatline.yazi](https://github.com/imsi32/yatline.yazi) add-on that displays git status information for the current directory, including branch name, commits ahead/behind remote, and dirty file count.

Example output: ` main ⇡2 ⇣1 ~3`

When the current directory is not a git repo, the component shows nothing.

## Requirements

- [yatline.yazi](https://github.com/imsi32/yatline.yazi)
- Git

## Configuration

Register it as a fetcher in `yazi.toml`:

```toml
[plugin]
fetchers = [
  { group = "yatline-gitinfo", url = "*", run = "yatline-gitinfo", prio = "low" },
]
```

Then in your `init.lua`, require it after yatline's setup:

```lua
require("yatline"):setup({ ... })
require("yatline-gitinfo"):setup()
```

Add the component to your yatline header or status line configuration:

```lua
{ type = "coloreds", custom = false, name = "gitinfo" },
```

## Display

The component displays the following, omitting any element that is zero or unavailable:

| Element | Meaning |
|---|---|
|  `main` | Current branch name |
| `⇡2` | Commits ahead of remote |
| `⇣1` | Commits behind remote |
| `~3` | Dirty files (staged + unstaged + untracked) |

## Notes

- Ahead/behind counts are omitted if the current branch has no upstream configured.
- Git info is cached per directory and updated whenever Yazi fetches files in that directory.

