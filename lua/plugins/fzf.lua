return {
  "ibhagwan/fzf-lua",
  lazy = false,
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Find Grep" },
    { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Find Word Under Cursor" },
    { "<leader>fad", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Find All Diagnostics" },
    { "<leader>fbd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Find Buffer Diagnostics" },
    { "<leader>fas", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Find All Symbols" },
    { "<leader>fbs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Find Buffer Symbols" },
  },
  opts = {
    winopts = {
      width = 0.8,
      height = 0.8,
      preview = {
        scrollchars = { "┃", "" },
      },
    },
    keymap = {
      fzf = {
        ["ctrl-u"] = "half-page-up",
        ["ctrl-d"] = "half-page-down",
        ["ctrl-f"] = "preview-page-down",
        ["ctrl-b"] = "preview-page-up",
      },
      builtin = {
        ["<c-f>"] = "preview-page-down",
        ["<c-b>"] = "preview-page-up",
      },
    },
    files = {
      cwd_prompt = false,
    },
    grep = {
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
    },
  },
  config = function(_, opts)
    require("fzf-lua").setup(opts)
  end,
}
