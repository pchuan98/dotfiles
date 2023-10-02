require "core.options"
require "core.keybinds"

require "core.bootstrap"

require("core.valuebox").load_theme()

vim.keymap.set("n", "<c-n>", ":lua vim.notify(\"hello\")<cr>", { noremap = true, silent = true })