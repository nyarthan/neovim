require("custom.core.options")
require("custom.core.keymaps")

require("lazy").setup({
	require("custom.plugins.telescope"),
	require("custom.plugins.oil"),
	require("custom.plugins.baleia"),
	require("custom.plugins.gitsigns"),

	-- TODO: dependencies should be handled by nix + lazy patch
	{ "plenary.nvim" },
	{ "telescope-fzf-native.nvim" },
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

local autocmds = require("custom.core.autocmds")

autocmds.GitCheck
	:new({
		function(is_in_git_repo)
			if not is_in_git_repo then
				return
			end

			vim.api.nvim_exec_autocmds("User", { pattern = "GitRepoDetected" })
		end,
	})
	:enable()
