require "custom.core.startup"
require "custom.core.options"
require "custom.core.keymaps"

local lazy = require "lazy"

lazy.setup {
  spec = { import = "custom.plugins" },
  root = os.getenv "PLUGIN_PATH",
  defaults = {
    lazy = true,
  },
  install = {
    missing = false,
  },
  dev = {
    path = "~/dev/nvim-plugins",
  },
  performance = {
    rtp = {
      reset = false,
    },
  },
}

local autocmds = require "custom.core.autocmds"

autocmds.GitCheck
  :new({
    function(is_in_git_repo)
      if not is_in_git_repo then return end

      vim.api.nvim_exec_autocmds("User", { pattern = "GitRepoDetected" })
    end,
  })
  :enable()

-- TODO: efm + stylua inserts \n at EOF - styla cli does not
-- possibly related:
-- - https://github.com/mattn/efm-langserver/issues/241
-- - https://github.com/mattn/efm-langserver/issues/181
-- - https://github.com/neovim/neovim/issues/16842
-- stylua: ingore

local client = vim.lsp.start {
  name = "anyls",
  cmd = { "/Users/jannis/dev/anyls/target/debug/anyls" },
}

if not client then
  vim.notify_once("anyls not started", vim.log.levels.INFO)
else
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function() vim.lsp.buf_attach_client(0, client) end,
  })
end
