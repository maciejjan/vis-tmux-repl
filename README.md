# vis-tmux-repl

This plugin can be used to send selected snippets of code to a specified
pane inside tmux, where presumably an interpreter (Read-Eval-Print Loop)
is running.

A demo can be seen here:
![vis-tmux-repl demo](http://macjanicki.eu/misc/vis-tmux-repl-demo.gif)

## Usage

To use the plugin, include:
```
require('tmux-repl')
```
in your `visrc.lua`.

### Setting the target pane

First, you need to specify the *target pane* for the current window,
to which the selected snippets will be sent. You can do it by either of
the two commands:

* `repl-set [PANE_ID]` -- set an existing pane identified by `PANE_ID`
as the target pane; if no `PANE_ID` is provided, the **marked** pane is used,
* `repl-new [CMD]` -- open a new pane in vertical split and set it to
the target pane; optionally, the command `CMD` will be run inside the new pane.

For example you can use commands like `:repl-new python` or `:repl-new R`
to open the interpreter for the respective language.

### Sending text to the target pane

* `repl-send` -- sends the current selection to the target pane,
* `repl-sendln [TEXT]` -- sends `TEXT` to the target pane.

The latter is useful e.g. for calling `:repl-sendln make` to a shell to
recompile your project - you can set a keybinding for that.

## Recommended keybindings

Setting some keybindings in `visrc.lua` will allow you to use the
interpreters efficiently:

```
vis.events.subscribe(vis.events.INIT, function()
    -- ... (other initial settings)

    vis:command("map! normal <C-r> :repl-new")
    vis:command("map! normal <C-e> :repl-set<Enter>")
    vis:command("map! visual <C-e> :repl-send<Enter><vis-mode-normal>")
end)
```

## Possible bugs

The script relies on tmux's `send-keys` command called from the
shell. Although it tries to correctly escape all whitespace and special
characters and has been tested with several languages (Python, R,
Haskell), there might still be bugs related to that.

## See also

The implementation of a similar solution for Vim was described step by
step here:
[Executing code chunks from Vim](http://macjanicki.eu/2020/09/26/executing-code-chunks-from-vim.html)
