return {
  "comment.nvim",
  dependencies = { { "nvim-ts-context-commentstring", opts = { enable_autocmd = false } } },
  opts = function()
    return {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }
  end,
  keys = {
    { "gc", mode = { "n", "v", "x" } },
    { "gb", mode = { "n", "v", "x" } },
  },
}
