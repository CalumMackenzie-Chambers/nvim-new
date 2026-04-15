return {
  src = 'https://github.com/nvim-treesitter/nvim-treesitter',
  version = 'main',
  setup = function()
    -- Make sure $XDG_DATA_HOME/nvim/site (where treesitter installs parsers)
    -- is on the runtimepath so nvim can find newly-installed parser .so files.
    vim.opt.rtp:append(vim.fn.stdpath('data') .. '/site')

    -- Run :TSUpdate after install/update, since nvim-treesitter/main no longer
    -- accepts an `ensure_installed` setup option.
    vim.api.nvim_create_autocmd('PackChanged', {
      desc = 'Update treesitter parsers when the plugin is installed/updated',
      callback = function(ev)
        local data = ev.data
        if data.spec.name == 'nvim-treesitter'
          and (data.kind == 'install' or data.kind == 'update')
        then
          vim.schedule(function() vim.cmd('TSUpdate') end)
        end
      end,
    })

    local highlight_filetypes = {
      'css', 'html', 'astro', 'c_sharp', 'javascript', 'json', 'lua',
      'markdown', 'python', 'scss', 'sql', 'toml', 'tsx', 'typescript',
      'vim', 'yaml',
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = highlight_filetypes,
      callback = function() vim.treesitter.start() end,
    })
  end,
}
