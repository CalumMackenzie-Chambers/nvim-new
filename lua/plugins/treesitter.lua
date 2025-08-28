return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local highlight_filetypes = {
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "scss",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml"
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = highlight_filetypes,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
