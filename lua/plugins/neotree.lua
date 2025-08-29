return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer NeoTree" },
  },
  config = function()
    local icons = require("util.icons")

    require("neo-tree").setup({
      source_selector = {
        winbar = true,
        sources = {
          {
            source = "filesystem",
            display_name = icons.ui.Files .. "Files ",
          },
          {
            source = "git_status",
            display_name = icons.git.Branch .. "Git",
          },
        },
        content_layout = "center",
      },
      open_files_do_not_replace_types = { "terminal", "qf", "Outline", "trouble" },

      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = false,
          hide_by_name = {
            "node_modules",
          },
          always_show = {
            ".gitignore",
            ".env",
            ".github",
          },
          never_show = {
            ".DS_Store",
            ".git",
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "disabled",
        renderers = {
          directory = {
            { "icon" },
            { "name", use_git_status_colors = false },
            { "diagnostics", errors_only = true, hide_when_expanded = true },
          },
          file = {
            { "icon" },
            { "name", use_git_status_colors = true },
            { "diagnostics" },
          },
        },
      },

      window = {
        position = "left",
        width = 40,
        mappings = {
          ["<space>"] = "none",
        },
      },

      default_component_configs = {
        name = {
          trailing_slash = false,
          use_git_status_colors = false,
          highlight = "NeoTreeFileName",
        },
        diagnostics = {
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warning,
            info = icons.diagnostics.Information,
            hint = icons.diagnostics.Hint,
          }
        },
        indent = {
          with_expanders = true,
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            added = icons.git.LineAdded,
            modified = icons.git.LineModified,
            deleted = icons.git.FileDeleted,
            renamed = icons.git.FileRenamed,
            untracked = icons.git.FileUntracked,
            ignored = icons.git.FileIgnored,
            unstaged = icons.git.FileUnstaged,
            staged = icons.git.FileStaged,
            conflict = icons.git.FileUnmerged,
          },
        },
      },
    })
  end,
}
