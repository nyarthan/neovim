vim.g.mapleader = " "

local lazy = require("lazy")

lazy.setup({
	{
		"lazy.nvim",
	},
	{
		"telescope.nvim",
		lazy = true,
		config = function() end,
		dependencies = { "plenary.nvim" },
		cmd = "Telescope",
	},
	{
		"nvim-treesitter",
		main = "nvim-treesitter.configs",
		opts = {},
	},
	{ "plenary.nvim", lazy = true },
	{ "folke/todo-comments.nvim", lazy = false },
}, {
	install = {
		missing = false,
	},
	performance = {
		rtp = {
			reset = false,
		},
	},
})

-- require('theme')
-- require('nvim-treesitter')
