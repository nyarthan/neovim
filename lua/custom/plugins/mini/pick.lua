return {
  config = function()
    require("mini.pick").setup {
      mappings = {
        choose_marked = "<C-q>",
      },
    }
  end,
  keys = {
    { "<leader>ff", function() MiniPick.builtin.files() end, desc = "Find Files" },
    { "<leader>fg", function() MiniPick.builtin.grep_live() end, desc = "Find Grep" },
    { "<leader>fr", function() MiniPick.builtin.resume() end, desc = "Find Resume" },
  },
}
