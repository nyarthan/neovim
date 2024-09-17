local Util = require("custom.util")
local Symbols = require("custom.symbols")
local Color = require("custom.color")

local function key_desc(desc)
	return string.format("%s " .. desc, Color.green("[GITSIGNS]"))
end

local function bind_gs_fn(fn_name, ...)
	local args = { ... }
	return function()
		local gitsigns = require("gitsigns")
		gitsigns[fn_name](unpack(args))
	end
end

return {
	"gitsigns.nvim",
	event = "User GitRepoDetected",
	opts = {
		signs = {
			add = { text = Symbols.nf.oct_diff_added },
			change = { text = Symbols.nf.oct_diff_modified },
			delete = { text = Symbols.nf.oct_diff_removed },
			topdelete = { text = Symbols.nf.oct_diff_renamed },
			changedelete = { text = Symbols.nf.oct_diff_modified },
			untracked = { text = Symbols.nf.oct_question },
		},
		signs_staged = {
			add = { text = Symbols.nf.oct_diff_added },
			change = { text = Symbols.nf.oct_diff_modified },
			delete = { text = Symbols.nf.oct_diff_removed },
			topdelete = { text = Symbols.nf.oct_diff_renamed },
			changedelete = { text = Symbols.nf.oct_diff_modified },
			untracked = { text = Symbols.nf.oct_question },
		},
	},
	keys = {
		{
			"]c",
			mode = "n",
			desc = key_desc("Jump to next hunk"),
			function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					require("gitsigns").nav_hunk("next")
				end
			end,
		},
		{
			"[c",
			mode = "n",
			desc = key_desc("Jump to previous hunk"),
			function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					require("gitsigns").nav_hunk("prev")
				end
			end,
		},
		{
			"<Leader>hs",
			mode = { "n", "v" },
			desc = key_desc("Stage hunk"),
			bind_gs_fn(
				"stage_hunk",
				({
					n = nil,
					v = {
						vim.fn.line("."),
						vim.fn.line("v"),
					},
				})[Util.get_mode()]
			),
		},
		{
			"<Leader>hr",
			mode = "n",
			desc = key_desc("Reset hunk"),
			bind_gs_fn(
				"reset_hunk",
				({
					n = nil,
					v = {
						vim.fn.line("."),
						vim.fn.line("v"),
					},
				})[Util.get_mode()]
			),
		},
		{
			"<Leader>hS",
			mode = "n",
			desc = key_desc("Stage buffer"),
			bind_gs_fn("stage_buffer"),
		},
		{
			"<Leader>hu",
			mode = "n",
			desc = key_desc("Undo stage hunk"),
			bind_gs_fn("undo_stage_hunk"),
		},
		{
			"<Leader>hR",
			mode = "n",
			desc = key_desc("Reset buffer"),
			bind_gs_fn("reset_buffer"),
		},
		{
			"<Leader>hp",
			mode = "n",
			desc = key_desc("Preview hunk"),
			bind_gs_fn("preview_hunk"),
		},
		{
			"<Leader>hb",
			mode = "n",
			desc = key_desc("Blame line"),
			bind_gs_fn("blame_line", { full = true }),
		},
		{
			"<Leader>tb",
			mode = "n",
			desc = key_desc("Toggle current line blame"),
			bind_gs_fn("toggle_current_line_blame"),
		},
		{
			"<Leader>hd",
			mode = "n",
			desc = key_desc("Diff this"),
			bind_gs_fn("diffthis"),
		},
		{
			"<Leader>hD",
			mode = "n",
			desc = key_desc("Diff this (~)"),
			bind_gs_fn("diffthis", "~"),
		},
		{
			"<Leader>td",
			mode = "n",
			desc = key_desc("Toggle deleted"),
			bind_gs_fn("toggle_deleted"),
		},
		{
			"ih",
			mode = { "o", "x" },
			desc = key_desc("Select inside hunk"),
			Util.make_ex_cmd("Gitsigns select_hunk"),
		},
	},
}
