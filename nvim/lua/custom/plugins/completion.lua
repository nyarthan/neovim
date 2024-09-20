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
    "lspkind-nvim",
  },
  config = function()
    local Symbols = require "custom.symbols"
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
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<C-Space>"] = cmp.mapping.complete {},
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
