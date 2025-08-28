local function setup_diagnostics()
  local icons = require("util.icons")
  local color = require("util.color")

  local function clear_sign_backgrounds()
    color.clear_sign_backgrounds("DiagnosticSign")
  end

  local function blend_colors()
    local normal_bg = vim.api.nvim_get_hl(0, { name = "normal" }).bg
    local error_fg = color.get_fg("DiagnosticError")
    local warn_fg = color.get_fg("DiagnosticWarn")
    local info_fg = color.get_fg("DiagnosticInfo")
    local hint_fg = color.get_fg("DiagnosticHint")

    local alpha = 0.2
    if error_fg then
      vim.api.nvim_set_hl(0, "DiagnosticErrorLn", {
        bg = color.blend_colors(normal_bg or 0x1d2021, error_fg, alpha),
      })
    end
    if warn_fg then
      vim.api.nvim_set_hl(0, "DiagnosticWarnLn", {
        bg = color.blend_colors(normal_bg or 0x1d2021, warn_fg, alpha),
      })
    end
    if info_fg then
      vim.api.nvim_set_hl(0, "DiagnosticInfoLn", {
        bg = color.blend_colors(normal_bg or 0x1d2021, info_fg, alpha),
      })
    end
    if hint_fg then
      vim.api.nvim_set_hl(0, "DiagnosticHintLn", {
        bg = color.blend_colors(normal_bg or 0x1d2021, hint_fg, alpha),
      })
    end
  end

  local function safe_blend_colors()
    local error_color = color.get_fg("DiagnosticError")

    if not error_color then
      vim.defer_fn(safe_blend_colors, 50)
      return
    end

    blend_colors()
    clear_sign_backgrounds()
  end

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
      priority = 1,
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
      max_width = 80,
    },
    update_in_insert = false,
  })

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = vim.tbl_deep_extend('force', {
    border = "rounded",
    winhighlight = "Normal:Normal,FloatBorder:Normal,EndOfBuffer:Normal",
    max_width = 80,
    max_height = 20,
    wrap = true,
    wrap_at = 80,
  }, opts or {})
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      safe_blend_colors()
    end,
  })

  safe_blend_colors()
end

setup_diagnostics()
