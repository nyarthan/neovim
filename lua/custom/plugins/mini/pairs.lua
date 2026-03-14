return {
  config = function() require("mini.pairs").setup {} end,
  keys = {
    { "(", mode = "i" },
    { "[", mode = "i" },
    { "{", mode = "i" },
    { ")", mode = "i" },
    { "]", mode = "i" },
    { "}", mode = "i" },
    { "'", mode = "i" },
    { "`", mode = "i" },
    { '"', mode = "i" },
  },
}
