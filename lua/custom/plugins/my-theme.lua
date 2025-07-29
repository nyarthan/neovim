return {
  "eventide.nvim",
  dev = true,
  lazy = false,
  enabled = false,
  config = function() require("eventide").setup() end,
}
