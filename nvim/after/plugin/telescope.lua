local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local theme = themes.get_dropdown({})
local diag = themes.get_dropdown({})
diag.bufnr = 0

vim.keymap.set("n", "<C-p>", function() builtin.find_files() end, {})
vim.keymap.set("n", "<leader>p", function() builtin.live_grep() end, {})
