return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer NeoTree", remap = true },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
  opts = {
    source_selector = {
      winbar = true,
      sources = {
        {
          source = "filesystem",
          display_name = "  Files ",
        },
        {
          source = "git_status",
          display_name = " Git ",
        },
      },
      content_layout = "center",
    },
    open_files_do_not_replace_types = { "terminal", "qf", "Outline" },
    git_status = {
      symbols = {
        added = "",
        modified = "",
        deleted = "✖",
        renamed = "",
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
    filesystem = {
      components = {
        -- harpoon_index = function(config, node)
        --   local Marked = require("harpoon.mark")
        --   local path = node:get_id()
        --   local succuss, index = pcall(Marked.get_index_of, path)
        --   if succuss and index and index > 0 then
        --     return {
        --       text = string.format("  %d ", index),
        --       highlight = config.highlight or "NeoTreeDirectoryIcon",
        --     }
        --   else
        --     return {}
        --   end
        -- end,
      },
      renderers = {
        directory = {
          { "icon" },
          { "name",        use_git_status_colors = false },
          { "diagnostics", errors_only = true,           hide_when_expanded = true },
        },
        file = {
          { "icon" },
          { "name",       use_git_status_colors = false },
          -- { "harpoon_index" },
          { "diagnostics" },
        },
      },
      filtered_items = {
        visible = true, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = false, -- only works on Windows for hidden files/directories
        hide_by_name = {
          "node_modules",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          ".gitignore",
          ".env",
          ".github",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          ".DS_Store",
          ".git",
        },
      },
      bind_to_cwd = false,
      follow_current_file = true,
      use_libuv_file_watcher = true,
    },
    window = {
      mappings = {
        ["<space>"] = "none",
      },
    },
    default_component_configs = {
      symbols = {
        added = "",
        deleted = "",
        modified = "",
        renamed = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
      name = {
        trailing_slash = false,
        use_git_status_color = false,
        highlight = "NeoTreeFileName",
      },
      indent = {
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
  end,
}
