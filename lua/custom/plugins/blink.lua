return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = {
    {
      "xzbdmw/colorful-menu.nvim",
      config = function() require("colorful-menu").setup {} end,
    },
  },
  --@module 'blink.cmp'
  --@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      documentation = { auto_show = false },
      keyword = { range = "full" },
      ghost_text = {
        enabled = true,
        show_with_selection = true,
        show_without_selection = false,
        show_with_menu = true,
        show_without_menu = true,
      },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 }, { "label_description" } },
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
              label = {
                text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
        },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = {
      implementation = "rust",
      prebuilt_binaries = { download = false },
    },
    signature = {
      enabled = true,
      trigger = {
        show_on_keyword = true,
        show_on_insert = true,
      },
      window = {
        direction_priority = { "s", "n" },
      },
    },
  },
  opts_extend = { "sources.default" },
}
