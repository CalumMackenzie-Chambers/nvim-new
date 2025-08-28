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
          border = "rounded",
          winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:PmenuSel,Search:None',
          min_width=50,
          draw = {
            columns = {{ "kind_icon", "label", gap = 1 }, { "source_id", gap=2 }},
            treesitter = { "lsp" },
            components = {
              label = {
                width = { max =43, fill = true},
                text = function(ctx)
                  local l = ctx.label
                  local d = ctx.label_description
                  local max_width = 43

                  if d ~= "" then
                    local combined = l .. " " .. d

                    if #combined > max_width then
                      local available = max_width - #l - 4

                      if available > 0 then
                        local trunc = d:sub(1, available)
                        combined = l .. " " .. trunc .. "..."
                      else
                        combined = l:sub(1, max_width -3) .. "..."
                      end
                    end

                    return combined .. string.rep(" ", max_width - #combined)
                  else
                    if #l > max_width then
                      l = l:sub(1, max_width -3) .. "..."
                    end
                    return l .. string.rep(" ", max_width - #l)
                  end
                end,
              },
              source_id = {
                text = function(ctx)
                  return (icons.sources[ctx.source_id] or "")
                end,
              },
            }
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
            winhighlight = 'Normal:Normal,FloatBorder:Normal,EndOfBuffer:Normal',
          }
        },
        ghost_text = {
          enabled = false,
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
