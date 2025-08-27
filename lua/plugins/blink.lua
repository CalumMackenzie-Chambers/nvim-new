return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  lazy = false,

  opts = function()
    local icons = require("util.icons")

    return {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        kind_icons = {
          Text = icons.kind.Text,
          Method = icons.kind.Method,
          Function = icons.kind.Function,
          Constructor = icons.kind.Constructor,
          Field = icons.kind.Field,
          Variable = icons.kind.Variable,
          Class = icons.kind.Class,
          Interface = icons.kind.Interface,
          Module = icons.kind.Module,
          Property = icons.kind.Property,
          Unit = icons.kind.Unit,
          Value = icons.kind.Value,
          Enum = icons.kind.Enum,
          Keyword = icons.kind.Keyword,
          Snippet = icons.kind.Snippet,
          Color = icons.kind.Color,
          File = icons.kind.File,
          Reference = icons.kind.Reference,
          Folder = icons.kind.Folder,
          EnumMember = icons.kind.EnumMember,
          Constant = icons.kind.Constant,
          Struct = icons.kind.Struct,
          Event = icons.kind.Event,
          Operator = icons.kind.Operator,
          TypeParameter = icons.kind.TypeParameter,
        },
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = false, -- No AI completion
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
    }
  end,

  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
}
