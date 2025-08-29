return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    vim.o.laststatus = vim.g.lualine_laststatus

    local icons = require("util.icons")
    local lualine_utils = require("util.lualine")

    local colors = require("gruvbox").palette
    local gruvbox_theme = {
      normal = {
        a = { bg = "None", fg = colors.light4, gui = "bold" },
        b = { bg = "None", fg = colors.light4 },
        c = { bg = "None", fg = colors.light4 },
      },
      insert = {
        a = { bg = "None", fg = colors.bright_blue, gui = "bold" },
        b = { bg = "None", fg = colors.light4 },
        c = { bg = "None", fg = colors.light4 },
      },
      visual = {
        a = { bg = "None", fg = colors.bright_yellow, gui = "bold" },
        b = { bg = "None", fg = colors.light4 },
        c = { bg = "None", fg = colors.light4 },
      },
      replace = {
        a = { bg = "None", fg = colors.bright_red, gui = "bold" },
        b = { bg = "None", fg = colors.light4 },
        c = { bg = "None", fg = colors.light4 },
      },
      command = {
        a = { bg = "None", fg = colors.bright_green, gui = "bold" },
        b = { bg = "None", fg = colors.light4 },
        c = { bg = "None", fg = colors.light4 },
      },
      terminal = {
        a = { bg = "None", fg = colors.bright_aqua, gui = "bold" },
        b = { bg = "None", fg = colors.light4 },
        c = { bg = "None", fg = colors.light4 },
      },
      inactive = {
        a = { bg = "None", fg = colors.light4, gui = "bold" },
        b = { bg = "None", fg = colors.light4 },
        c = { bg = "None", fg = colors.light4 },
      },
    }

    return {
      options = {
        theme = gruvbox_theme,
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },

        lualine_c = {
          lualine_utils.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error .. " ",
              warn = icons.diagnostics.Warning .. " ",
              info = icons.diagnostics.Information .. " ",
              hint = icons.diagnostics.Hint .. " ",
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            "filename",
            path = 1,
          },
        },

        lualine_x = {
          lualine_utils.lsp_status(),

          lualine_utils.file_encoding(),

          {
            "diff",
            symbols = {
              added = icons.git.LineAdded,
              modified = icons.git.LineModified,
              removed = icons.git.LineRemoved,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },

        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },

        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
