-- vb-ls (CoolCoderSuper/visualbasic-language-server) config.
--
-- This file is only loaded when init.lua enables vb_ls, which it skips on
-- non-Windows platforms. Still, be defensive about path discovery so the
-- config works on any Windows machine, not just the one it was authored on.
--
-- Three non-obvious things handled below;
--
-- 1. vb-ls's own RoslynHelpers.findAndLoadSolutionOnDir uses the *process CWD*
--    to locate a .sln / .vbproj (it ignores the LSP rootUri). If nvim was
--    launched from anywhere other than a VB project root, the server crashes.
--    We wrap `cmd` as a function so we can set the child process's cwd to the
--    workspace root resolved by `root_dir`.
--
-- 2. Roslyn's BuildHost-net472 does
--    `MSBuildLocator.QueryVisualStudioInstances().OrderByDescending(Version).First()`
--    for classic (non-SDK) projects. If a newer VS install (e.g. VS 18) exists
--    alongside VS 2022 Build Tools, BuildHost picks the newer one and crashes
--    with a TypeInitializationException for Microsoft.Build.Shared.XMakeElements
--    (the net472 BuildHost.exe.config binding-redirects to MSBuild 15.1).
--    Fix: set VSINSTALLDIR + VSCMD_VER so MSBuildLocator yields a "DevConsole"
--    instance pointing at VS 2022 Build Tools, with VSCMD_VER higher than any
--    real installed VS so the DevConsole entry wins OrderByDescending.
--
-- 3. root_markers does NOT support globs, so a literal list like
--    { '*.sln', '*.vbproj' } never matches anything. Use a function-form
--    root_dir that matches by extension, with .git / web.config fallback.

-- Locate VS 2022 Build Tools via vswhere.exe (shipped with any VS Installer).
-- Returns the install path with forward slashes, or nil if not found.
local function find_vs_buildtools()
  local vswhere = 'C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe'
  if vim.fn.executable(vswhere) ~= 1 then
    return nil
  end
  local out = vim.fn.system({
    vswhere,
    '-products', 'Microsoft.VisualStudio.Product.BuildTools',
    '-latest',
    '-property', 'installationPath',
  })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  out = vim.trim(out or '')
  if out == '' then
    return nil
  end
  return (out:gsub('\\', '/'))
end

-- Build the env block that pins MSBuild discovery to VS 2022 Build Tools.
-- If BuildTools isn't installed, return nil — vb-ls will fall back to dotnet
-- SDK MSBuild (which works for SDK-style projects but not classic WebForms).
local function build_msbuild_env()
  local root = find_vs_buildtools()
  if not root then
    vim.notify(
      'vb-ls: VS 2022 Build Tools not found. Run :checkhealth vb_ls for details.',
      vim.log.levels.WARN
    )
    return nil
  end
  return {
    VSINSTALLDIR        = root,
    -- Higher than any real VS version so the DevConsole instance beats it
    -- in Roslyn BuildHost's OrderByDescending(Version) sort.
    VSCMD_VER           = '99.99.99',
    VisualStudioVersion = '17.0',
    MSBUILD_EXE_PATH    = root .. '/MSBuild/Current/Bin/MSBuild.exe',
  }
end

local cmd_env = build_msbuild_env()

return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ 'vb-ls' }, dispatchers, {
      cwd = config.root_dir,
      env = cmd_env,
    })
  end,

  filetypes = { 'vbnet' },

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, function(name)
      return name:match('%.sln$') or name:match('%.vbproj$')
    end) or vim.fs.root(fname, { '.git', 'web.config' })
    on_dir(root or vim.fs.dirname(fname))
  end,

  init_options = {
    AutomaticWorkspaceInit = true,
  },

  settings = {
    vb = {
      applyFormattingOptions = false,
    },
  },

  -- vb-ls is heavy; disable noisy/expensive features at the protocol level.
  capabilities = {
    textDocument = {
      formatting       = { dynamicRegistration = false },
      rangeFormatting  = { dynamicRegistration = false },
      onTypeFormatting = { dynamicRegistration = false },
      inlayHint        = { dynamicRegistration = false },
      colorProvider    = { dynamicRegistration = false },
    },
  },
}
