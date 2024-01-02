local c = vim.api.nvim_create_autocmd
vim.cmd 'autocmd BufNewFile,BufRead *.urn :set filetype=clojure'

c({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.urn' },
  callback = function()
    vim.o.filetype = 'clojure'
    vim.keymap.set('n', '<C-t>', function()
      local file = vim.api.nvim_buf_get_name(0)
      local out = file:gsub('urn$', 'lua')
      vim.cmd((':!urn %s -o %s -O3 -O+inline'):format(file, out))
    end)
  end
})

c({ "BufWritePre" }, {
  callback = function() vim.lsp.buf.format { async = false } end,
})
