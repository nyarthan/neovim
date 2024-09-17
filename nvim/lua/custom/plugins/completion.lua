return {
	"nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"cmp-path",
		{
			"luasnip",
			opts = {},
		},
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert" },
			window = {
				completion = cmp.config.window.bordered(),
				-- documentation = cmp.config.window.bordered(),
			},
			mappings = {
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete({}),
			},
			sources = {
				{ name = "path" },
			},
		})
	end,
}
