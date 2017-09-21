require(["codemirror/keymap/sublime", "notebook/js/cell"], function(sublime_keymap, cell) {
    cell.Cell.options_default.cm_config.keyMap = 'sublime';
});
