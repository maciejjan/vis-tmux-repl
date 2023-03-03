-- Set the REPL target pane for the current window to the given pane ID.
-- If no pane ID is supplied, the command will look for the marked pane
-- and try to use it. It prints an error message if there is no marked pane.
vis:command_register("repl-set", function(argv, _, win)
    local pane = argv[1]
    if not pane then
        local f = io.popen("tmux lsp -a -F \"#D #{pane_marked}\" \\;" ..
                           "     select-pane -M " ..
                           "| awk '$2 == 1 { print $1; }'")
        for line in f:lines() do
            pane = line
        end
        f:close()
    end
    if pane then
        win.repl_target_pane = pane
    else
        vis:message("repl-set: No pane ID given and no marked pane!")
    end
end)

-- Open a new pane and set it to the REPL target pane of the current window.
-- Optionally, a command can be provided, which is then executed
-- in the opened pane. E.g.:
--   :repl-new python3
vis:command_register("repl-new", function(argv, _, win)
    local pane;
    local cmd = (argv[1] or "")
    local f = io.popen("tmux splitw -d -l 10 -P -F '#D' " .. cmd)
    for line in f:lines() do
        pane = line
    end
    f:close()
    win.repl_target_pane = pane
end)

-- Sends the selected text to the REPL target pane. (use in visual mode)
vis:command_register("repl-send", function(argv, _, win)
    if win.repl_target_pane then
        vis:command('> sed \'s/;$/\\\\\\;/g; s/\\(.*\\)/\\1\\\\nEnter/\' ' ..
                    '  | tr "\\\\n" "\\0" ' ..
                    '  | xargs -0 tmux send-keys -t ' .. win.repl_target_pane)
    end
end)

-- Sends the given line of text to the REPL target pane.
-- Can be used to call a command in the other pane, for example to recompile
-- your project, you can open a shell in the target pane and use:
--   :repl-send make
vis:command_register("repl-sendln", function(argv, _, win)
    if win.repl_target_pane then
        vis:command('! tmux send-keys -t '.. win.repl_target_pane ..
                    ' ' .. argv[1] .. ' Enter')
    end
end)

