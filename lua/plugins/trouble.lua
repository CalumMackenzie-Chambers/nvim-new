return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
  keys = {
    { "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>", desc = "All Diagnostics" },
    { "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    { "<leader>lq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    { "<leader>ll", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
    { "<leader>ss", "<cmd>Trouble symbols toggle<cr>", desc = "Document Symbols" },
    { "<leader>sl", "<cmd>Trouble lsp toggle<cr>", desc = "LSP References/Definitions" },
    {
      "[d",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Previous Diagnostic/Quickfix Item",
    },
    {
      "]d",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Next Diagnostic/Quickfix Item",
    },
  },
}
