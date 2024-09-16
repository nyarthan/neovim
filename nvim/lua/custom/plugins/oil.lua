local Util = require("custom.util")
local Color = require("custom.color")

local key_cmd = Util.key_cmd

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
			key_cmd("Oil"),
			mode = "n",
			desc = string.format("%s Open parent directory", Color.green("[OIL]")),
		},
	},
}
