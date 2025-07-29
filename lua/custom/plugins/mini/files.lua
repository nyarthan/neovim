return {
  "echasnovski/mini.files",
  config = function()
    local files = require "mini.files"
    files.setup {
      windows = {preview = true}
    }

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesActionRename",
    callback = function(event)
      Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
  })
  end,
  keys = {
    { "<leader>e", ":lua MiniFiles.open()<CR>", desc = "Open File [E]xplorer" },
  },
}
