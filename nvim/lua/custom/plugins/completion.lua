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
  },
  config = function()
    local Symbols = require "custom.symbols"
    local Util = require "custom.util"
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    local border = {
      Symbols.unicode.box_drawings.light.down_and_right,
      Symbols.unicode.box_drawings.light.horizontal,
      Symbols.unicode.box_drawings.light.down_and_left,
      Symbols.unicode.box_drawings.light.vertical,
      Symbols.unicode.box_drawings.light.up_and_left,
      Symbols.unicode.box_drawings.light.horizontal,
      Symbols.unicode.box_drawings.light.up_and_right,
      Symbols.unicode.box_drawings.light.vertical,
    }

    cmp.setup {
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
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

      experimental = { ghost_text = true },

      completion = { completeopt = "menu,menuone,noinsert" },

      view = { entries = "custom" },

      window = {
        completion = {
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None",
          col_offset = -4,
          side_padding = 0,
          winblend = vim.o.winblend,
          scrolloff = 7,
          border = border,
          scrollbar = false,
        },
        documentation = {
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None",
          winblend = vim.o.winblend,
          border = border,
        },
      },

      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local source = ({
            buffer = "buf",
            nvim_lsp = "lsp",
            luasnip = "snp",
            path = "pth",
          })[entry.source.name]

          return {
            abbr = vim_item.abbr,
            kind = string.format(" %s ", Symbols.lsp.kind[vim_item.kind]),
            menu = string.format("    (%s) [%s]", vim_item.kind, string.upper(source)),
          }
        end,
      },
    }
  end,
}
