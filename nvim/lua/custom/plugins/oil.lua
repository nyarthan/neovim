return {
	"stevearc/oil.nvim",
	opts = {
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		prompt_save_on_select_new_entry = false,
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"-",
			"<CMD>Oil<CR>",
			mode = "n",
			desc = "Open Parent Directory",
		},
	},
}
