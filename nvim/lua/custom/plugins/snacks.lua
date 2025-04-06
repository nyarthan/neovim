return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    rename = {enabled = true}
  },
}
