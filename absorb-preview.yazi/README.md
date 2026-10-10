# absorb-preview.yazi

A Yazi plugin that hides the preview pane and gives its width to the current pane, so the parent pane keeps the width it had. Run it again to restore the previous layout.

Yazi's built-in `toggle-pane min-preview` drops the preview's share of the ratio instead, which widens the parent pane along with the current pane.

## Configuration

Add a key binding to your `keymap.toml`:

```toml
[[mgr.prepend_keymap]]
 on = "e"
 run = "plugin absorb-preview"
 desc = "Hide the preview and widen the file list into it"
```

If the pane ratio was changed by something else since the preview was hidden, running the plugin hides the preview again starting from the current ratio rather than restoring the old one.
