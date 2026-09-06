# start-dir.yazi

A Yazi plugin that opens Yazi in the directory specified by the `YAZI_START_DIR` environment variable.

If `YAZI_START_DIR` is unset or empty, the plugin does nothing.

## Configuration

Add a key binding to your `keymap.toml`:

```toml
[[mgr.prepend_keymap]]
 on = [ "g", "h" ]
 run = "plugin start-dir"
 desc = "Go to start directory"
```

Set `YAZI_START_DIR` before launching Yazi:

```bash
export YAZI_START_DIR="$PWD"
yazi
```

For example, to start Yazi in a project directory:

```bash
YAZI_START_DIR="$HOME/Projects/example" yazi
```

The plugin changes to the configured directory only when `YAZI_START_DIR` contains a non-empty path.
