vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable bundled plugins we don't use. Must run before runtime/plugin/*
-- is sourced, hence they live at the top of init.lua.
local disabled_builtins = {
  'gzip',
  'matchit',
  'matchparen',
  'netrw', 'netrwPlugin',
  'tar', 'tarPlugin',
  'tutor',
  'zip', 'zipPlugin',
}
for _, plugin in ipairs(disabled_builtins) do
  vim.g['loaded_' .. plugin] = 1
end
-- nvim.tohtml is opt-in in 0.12 (no need to disable).

vim.filetype.add({
  extension = {
    templ = 'templ',
    aspx = 'html',
    ascx = 'html',
    Master = 'html',
    master = 'html',
    postcss = 'css',
    vb = 'vbnet',
  },
})

local is_windows = vim.fn.has('win32') == 1

require('config')

vim.lsp.config('*', { root_markers = { '.git' } })

local servers = { 'luals' }
if is_windows then
  -- vb-ls is a .NET tool wired to Visual Studio's MSBuild for loading classic
  -- WebForms .vbproj/.sln; it is only useful on Windows.
  table.insert(servers, 'vb_ls')
end
vim.lsp.enable(servers)
-- roslyn is enabled by lua/plugins/roslyn.lua after the plugin loads (it
-- registers its own vim.lsp.config and calls vim.lsp.enable('roslyn')).

vim.cmd.packadd('nvim.undotree')
vim.keymap.set('n', '<leader>u', '<cmd>Undotree<cr>', { desc = 'Undo tree' })
