require'harpoon'.setup{}

local mark = require'harpoon.mark'
local ui = require'harpoon.ui'

vim.keymap.set("n", "<C-a>", function() mark.add_file() end)
vim.keymap.set("n", "<C-o>", function() ui.toggle_quick_menu() end)

vim.keymap.set("n", "<A-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<A-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<A-g>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<A-c>", function() ui.nav_file(4) end)
