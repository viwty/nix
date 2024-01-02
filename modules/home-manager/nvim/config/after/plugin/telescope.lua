local telescope = require('telescope')
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local diag = themes.get_dropdown({})
diag.bufnr = 0

vim.keymap.set("n", "<C-t>", function() builtin.find_files() end, {})
vim.keymap.set("n", "<leader>t", function() builtin.live_grep() end, {})
vim.keymap.set('n', '<leader>p', function() telescope.extensions.projects.projects {} end, {})
