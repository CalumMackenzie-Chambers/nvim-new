local function setup_diagnostics()
  local icons = require("util.icons")

  -- Function to blend colors (90% background, 10% foreground)
  local function blend_colors()
    -- Get current colorscheme colors
    local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    local error_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg
    local warn_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg
    local info_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg
    local hint_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg

    -- Helper function to blend two colors
    local function blend(bg, fg, alpha)
      if not bg or not fg then
        return nil
      end

      -- Convert hex to RGB
      local function hex_to_rgb(hex)
        hex = hex:gsub("#", "")
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
      end

      -- Convert RGB to hex
      local function rgb_to_hex(r, g, b)
        return string.format("#%02x%02x%02x", math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
      end

      local bg_r, bg_g, bg_b = hex_to_rgb(string.format("#%06x", bg))
      local fg_r, fg_g, fg_b = hex_to_rgb(string.format("#%06x", fg))

      local blended_r = bg_r * (1 - alpha) + fg_r * alpha
      local blended_g = bg_g * (1 - alpha) + fg_g * alpha
      local blended_b = bg_b * (1 - alpha) + fg_b * alpha

      return rgb_to_hex(blended_r, blended_g, blended_b)
    end

    -- Set line highlight colors (90% background, 10% diagnostic color)
    local alpha = 0.1
    if error_fg then
      vim.api.nvim_set_hl(0, "DiagnosticErrorLn", { bg = blend(normal_bg or 0x1d2021, error_fg, alpha) })
    end
    if warn_fg then
      vim.api.nvim_set_hl(0, "DiagnosticWarnLn", { bg = blend(normal_bg or 0x1d2021, warn_fg, alpha) })
    end
    if info_fg then
      vim.api.nvim_set_hl(0, "DiagnosticInfoLn", { bg = blend(normal_bg or 0x1d2021, info_fg, alpha) })
    end
    if hint_fg then
      vim.api.nvim_set_hl(0, "DiagnosticHintLn", { bg = blend(normal_bg or 0x1d2021, hint_fg, alpha) })
    end
  end

  -- Configure diagnostics
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      },
      linehl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticErrorLn",
        [vim.diagnostic.severity.WARN] = "DiagnosticWarnLn",
        [vim.diagnostic.severity.INFO] = "DiagnosticInfoLn",
        [vim.diagnostic.severity.HINT] = "DiagnosticHintLn",
      },
    },
    virtual_text = {
      prefix = "●",
      spacing = 4,
    },
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
    update_in_insert = false, -- Don't update highlights in insert mode
  })

  -- Set sign column background to transparent
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })

  -- Set up line highlights
  blend_colors()

  -- Auto-refresh colors when colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      vim.defer_fn(blend_colors, 100) -- Small delay to ensure colors are loaded
    end,
  })
end

-- Call the setup function
setup_diagnostics()
