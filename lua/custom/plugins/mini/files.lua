return {
  "echasnovski/mini.files",
  config = function()
    local files = require "mini.files"
    files.setup {
      windows = {preview = true}
    }
  end,
  keys = {
    { "-", ":lua MiniFiles.open()<CR>", desc = "Open File Picker" },
  },
}
