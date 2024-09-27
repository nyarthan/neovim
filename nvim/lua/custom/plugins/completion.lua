return {
  "nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "cmp-path",
    "cmp-buffer",
    {
      "luasnip",
      opts = {},
    },
    "lspkind.nvim",
  },
  config = function()
    local Symbols = require "custom.symbols"
    local Util = require "custom.util"
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local lspkind = require "lspkind"

    cmp.setup {
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },
      window = {
        completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping(Util.bind_strict(cmp.select_next_item), { "i", "c", "s" }),
        ["<C-p>"] = cmp.mapping(Util.bind_strict(cmp.select_prev_item), { "i", "c", "s" }),
        ["<C-b>"] = cmp.mapping(Util.bind_strict(cmp.scroll_docs, -4), { "i", "c", "s" }),
        ["<C-f>"] = cmp.mapping(Util.bind_strict(cmp.scroll_docs, 4), { "i", "c", "s" }),
        ["<C-y>"] = cmp.mapping(
          Util.bind_strict(cmp.confirm, { select = true }),
          { "i", "c", "s" }
        ),
        ["<C-Space>"] = cmp.mapping(Util.bind_strict(cmp.complete), { "i", "c", "s" }),
      },
      sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp" },
        { name = "path" },
      }, { { name = "buffer" } }),
      formatting = {
        format = lspkind.cmp_format {
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = Symbols.nf.cod_ellipsis,
          show_labelDetails = true,
        },
      },
    }
  end,
}
