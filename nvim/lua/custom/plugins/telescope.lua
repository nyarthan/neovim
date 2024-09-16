return {
	"telescope.nvim",
	dependencies = { "plenary.nvim" },
	cmd = "Telescope",
	opts = {
		defaults = {
			mappings = {
				n = {
					["<C-b>"] = function(prompt_bufnr)
						local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
						vim.g.baleia.once(picker.results_bufnr)
					end,
				},
			},
		},
	},
}
