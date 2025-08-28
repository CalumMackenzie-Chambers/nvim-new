local M = {}

function M.get_fg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  if hl.fg then
    return hl.fg
  end
  if hl.link then
    return vim.api.nvim_get_hl(0, { name = hl.link }).fg
  end
end

function M.resolve_effective_hl(name)
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

function M.normalize_for_set(hl)
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

function M.blend_colors(bg, fg, alpha)
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

function M.create_derived_highlight(base_name, new_name, modifications)
  local base_hl = M.resolve_effective_hl(base_name)
  if base_hl then
    local new_hl = M.normalize_for_set(base_hl)
    for k, v in pairs(modifications) do
      new_hl[k] = v
    end
    vim.api.nvim_set_hl(0, new_name, new_hl)
  else
    local fallback_hl = { link = base_name }
    for k, v in pairs(modifications) do
      fallback_hl[k] = v
    end
    vim.api.nvim_set_hl(0, new_name, fallback_hl)
  end
end

function M.clear_sign_backgrounds(pattern)
  local groups = vim.fn.getcompletion(pattern or "", "highlight")
  for _, group in ipairs(groups) do
    if group:match("^" .. (pattern or "")) then
      local resolved = M.resolve_effective_hl(group)
      if resolved then
        local to_set = M.normalize_for_set(resolved)
        to_set.bg = "none"
        vim.api.nvim_set_hl(0, group, to_set)
      else
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
    end
  end
end

return M
