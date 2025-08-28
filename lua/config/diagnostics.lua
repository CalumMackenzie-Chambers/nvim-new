local function setup_diagnostics()
  local icons = require("util.icons")

  local function get_fg(name)
    local hl = vim.api.nvim_get_hl(0, { name = name })
    if hl.fg then
      return hl.fg
    end
    if hl.link then
      return vim.api.nvim_get_hl(0, { name = hl.link }).fg
    end
  end

  local function resolve_effective_hl(name)
    local seen = {}
    local cur = name
    while cur and not seen[cur] do
      seen[cur] = true
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = cur })
      if not ok or not hl then
        break
      end

      local has_nonlink = false
      for k, _ in pairs(hl) do
        if k ~= "link" then
          has_nonlink = true
          break
        end
      end
      if has_nonlink then
        return hl
      end

      cur = hl.link
    end

    return nil
  end

  local function normalize_for_set(hl)
    local out = {}
    for k, v in pairs(hl) do
      if k == "link" then
        goto continue
      end
      if (k == "fg" or k == "bg") and type(v) == "number" then
        out[k] = string.format("#%06x", v)
      else
        out[k] = v
      end
      ::continue::
    end
    return out
  end

  local function clear_sign_backgrounds()
    local groups = vim.fn.getcompletion("DiagnosticSign", "highlight")
    for _, group in ipairs(groups) do
      if group:match("^DiagnosticSign") then
        local resolved = resolve_effective_hl(group)
        if resolved then
          local to_set = normalize_for_set(resolved)
          to_set.bg = "none"
          vim.api.nvim_set_hl(0, group, to_set)
        else
          vim.api.nvim_set_hl(0, group, { bg = "none" })
        end
      end
    end
      
  end

  local function blend_colors()
    local normal_bg = vim.api.nvim_get_hl(0, { name = "normal" }).bg
    local error_fg = get_fg("DiagnosticError")
    local warn_fg = get_fg("DiagnosticWarn")
    local info_fg = get_fg("DiagnosticInfo")
    local hint_fg = get_fg("DiagnosticHint")

    local function blend(bg, fg, alpha)
      if not bg or not fg then
        return nil
      end

      local function hex_to_rgb(hex)
        hex = hex:gsub("#", "")
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
      end

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

    local alpha = 0.2
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

  local function safe_blend_colors()
    local error_color = get_fg("DiagnosticError")

    if not error_color then
      vim.defer_fn(safe_blend_colors, 50)
      return
    end

    blend_colors()
    clear_sign_backgrounds()
  end

  -- configure diagnostics
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
      priority = 1
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
    update_in_insert = false, -- don't update highlights in insert mode
  })

  -- auto-refresh colors when colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      safe_blend_colors()
    end,
  })
end

setup_diagnostics()
