return {
  "echasnovski/mini.files",
  lazy = false,
  config = function()
    local files = require "mini.files"
    files.setup {
      windows = { preview = true },
    }

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
    })
  end,

  vim.keymap.set(
    "n",
    "<leader>e",
    function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end,
    { desc = "Open File [E]xplorer" }
  ),
}
