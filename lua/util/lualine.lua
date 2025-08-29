local M = {}

-- Get foreground color from a highlight group
local function fg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  local fore = hl and hl.fg
  return fore and { fg = string.format("#%06x", fore) } or nil
end

-- Root directory component
function M.root_dir()
  return {
    function()
      local root = vim.fn.getcwd()
      return vim.fn.fnamemodify(root, ":t")
    end,
    icon = " ",
    color = fg("Comment"),
  }
end

-- LSP status component
function M.lsp_status()
  return {
    function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return ""
      end
      local names = {}
      local has_starting = false
      local has_ready = false
      for _, client in pairs(clients) do
        table.insert(names, client.name)
        if client.is_stopped then
          has_starting = true
        else
          has_ready = true
        end
      end
      local icon
      if has_starting and not has_ready then
        icon = "󰌗"
      elseif has_ready then
        icon = "󰒋"
      else
        icon = "󰌘"
      end

      return icon .. " " .. table.concat(names, ", ")
    end,
    color = function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return fg("Comment")
      end

      local has_ready = false
      for _, client in pairs(clients) do
        if not client.is_stopped then
          has_ready = true
          break
        end
      end

      if has_ready then
        return fg("Special")
      else
        return fg("DiagnosticWarn")
      end
    end,
  }
end

function M.file_encoding()
  return {
    function()
      local encoding = vim.bo.fileencoding or vim.bo.encoding
      local format = vim.bo.fileformat
      local bom = vim.bo.bomb and "BOM" or ""

      if encoding == "utf-8" and format == "unix" and not vim.bo.bomb then
        return ""
      end

      local parts = {}
      if bom ~= "" then
        table.insert(parts, bom)
      end
      if encoding ~= "utf-8" then
        table.insert(parts, encoding:upper())
      end
      if format ~= "unix" then
        table.insert(parts, format:upper())
      end

      return table.concat(parts, " ")
    end,
    color = function()
      local encoding = vim.bo.fileencoding or vim.bo.encoding
      local format = vim.bo.fileformat
      local bom = vim.bo.bomb

      if bom or encoding ~= "utf-8" or format ~= "unix" then
        return fg("DiagnosticWarn")
      end
      return fg("Comment")
    end,
    on_click = function()
      vim.ui.select({
        "utf-8 unix (no BOM)",
        "utf-8 dos (CRLF)",
        "utf-8 unix (with BOM)",
        "Custom...",
      }, {
        prompt = "Fix encoding/format:",
      }, function(choice)
        if choice == "utf-8 unix (no BOM)" then
          vim.bo.fileencoding = "utf-8"
          vim.bo.fileformat = "unix"
          vim.bo.bomb = false
        elseif choice == "utf-8 dos (CRLF)" then
          vim.bo.fileencoding = "utf-8"
          vim.bo.fileformat = "dos"
          vim.bo.bomb = false
        elseif choice == "utf-8 unix (with BOM)" then
          vim.bo.fileencoding = "utf-8"
          vim.bo.fileformat = "unix"
          vim.bo.bomb = true
        elseif choice == "Custom..." then
          vim.cmd("setlocal fileencoding? fileformat? bomb?")
        end
      end)
    end,
  }
end

return M
