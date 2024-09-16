return {
	"baleia.nvim",
	lazy = false,
	config = function()
		vim.g.baleia = require("baleia").setup({})
	end,
}
