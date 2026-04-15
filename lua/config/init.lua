require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.diagnostics')
require('config.plugins')

-- VB.NET / vb-ls FileType tweaks are only useful when vb-ls actually runs.
if vim.fn.has('win32') == 1 then
  require('config.vb')
end
