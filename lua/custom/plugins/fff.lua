return {
  'dmtrKovalenko/fff.nvim',
  opts = {
    debug = {
      enabled = false,
      show_scores = false,
    },
  },
  lazy = false,
  keys = {
    {
      "<leader>ff",
      function() require('fff').find_files() end,
      desc = 'FFFind files',
    }
  }
}
