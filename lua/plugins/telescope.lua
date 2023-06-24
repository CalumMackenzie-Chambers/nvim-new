return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim",
  },
  cmd = "Telescope",
  version = false,
  keys = {
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find Grep" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Find Git Commits" },
    { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Find Git Status" },
    { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Find Document diagnostics" },
    { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Find Workspace diagnostics" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find Help Pages" },
    { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Find Options" },
    {
      "<leader>fu",
      function()
        require("telescope").load_extension("undo")
        vim.cmd("Telescope undo")
      end,
      desc = "Undo tree",
    },
    {
      "<leader>vs",
      function()
        vim.cmd("vsplit")
        require('telescope.builtin').find_files()
      end,
      desc = "VSplit Find Files",
    },
    {
      "<leader>hs",
      function()
        vim.cmd("split")
        require('telescope.builtin').find_files()
      end,
      desc = "HSplit Find Files",
    },
  },
  config = function()
    local opts = {
      defaults = {
        layout_config = {
          preview_width = 0.7
        },
      },
      extensions = {
        undo = {
          mappings = {
            i = {
              ["<s-cr>"] = require("telescope-undo.actions").yank_additions,
              ["<c-cr>"] = require("telescope-undo.actions").yank_deletions,
              ["<cr>"] = require("telescope-undo.actions").restore,
            },
          },
        },
      },
    }

    require("telescope").setup(opts)
    require("telescope").load_extension("undo")
  end,
}
