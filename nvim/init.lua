require("custom.core.options")
require("custom.core.keymaps")

require("lazy").setup({
	require("custom.plugins.telescope"),
	require("custom.plugins.oil"),
	require("custom.plugins.baleia"),
	require("custom.plugins.gitsigns"),

	-- TODO: dependencies should be handled by nix + lazy patch
	{ "plenary.nvim" },
	{ "nvim-web-devicons" },
}, {
	defaults = {
		lazy = true,
	},
	install = {
		missing = false,
	},
	performance = {
		rtp = {
			reset = false,
		},
	},
})
