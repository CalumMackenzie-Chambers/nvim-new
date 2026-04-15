-- Plugin loader for vim.pack (built into Neovim 0.12+).
--
-- Walks lua/plugins/*.lua, each of which returns a table:
--   {
--     src     = 'https://github.com/owner/repo',  -- required
--     name    = 'optional-name-override',         -- defaults to repo name
--     version = 'main' | 'v1.2.3' | vim.version.range('*'),
--     deps    = { 'https://github.com/foo/bar', ... },  -- extra packages
--                                                       -- installed alongside
--     setup   = function() ... end,               -- runs after install
--   }
--
-- All `src` and `deps` are batched into a single vim.pack.add() call so
-- installation/clone happens in parallel. After that, each plugin's
-- `setup` runs (errors are caught so one bad plugin doesn't break startup).

local plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins'

local modules = {}      -- list of plugin module tables, in load order
local specs   = {}      -- flat list of vim.pack specs

for _, file in ipairs(vim.fn.readdir(plugins_dir)) do
  local name = file:match('^(.+)%.lua$')
  if name then
    local ok, mod = pcall(require, 'plugins.' .. name)
    if not ok then
      vim.notify(('plugins/%s: %s'):format(name, mod), vim.log.levels.ERROR)
    elseif type(mod) == 'table' and mod.src then
      table.insert(modules, mod)
      table.insert(specs, {
        src     = mod.src,
        name    = mod.name,
        version = mod.version,
      })
      for _, dep in ipairs(mod.deps or {}) do
        if type(dep) == 'string' then
          table.insert(specs, { src = dep })
        else
          table.insert(specs, dep)
        end
      end
    else
      vim.notify(('plugins/%s did not return a spec table'):format(name),
        vim.log.levels.WARN)
    end
  end
end

vim.pack.add(specs, { confirm = false })

for _, mod in ipairs(modules) do
  if type(mod.setup) == 'function' then
    local ok, err = pcall(mod.setup)
    if not ok then
      vim.notify(('plugin setup failed (%s): %s')
        :format(mod.name or mod.src, err), vim.log.levels.ERROR)
    end
  end
end
