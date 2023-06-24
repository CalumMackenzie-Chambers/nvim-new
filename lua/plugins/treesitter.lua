return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  event = { "BufReadPost", "BufNewFile" },
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })
  end,
  cmd = { "TSUpdateSync" },
  opts = {
    highlight = { enable = true },
    ensure_installed = {
      "bash",
      "c_sharp",
      "comment",
      "css",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "scss",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
  },

  config = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      local added = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if added[lang] then
          return false
        end
        added[lang] = true
        return true
      end, opts.ensure_installed)
    end
    require("nvim-treesitter.configs").setup(opts)
  end,
}
