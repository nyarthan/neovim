return {
  "epwalsh/obsidian.nvim",
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    workspaces = {
      {
        name = "vault",
        path = "~/vault",
      },
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    mappings = {
      ["gf"] = {
        action = function() return require("obsidian").util.gf_passthrough() end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function() return require("obsidian").util.toggle_checkbox() end,
        opts = { buffer = true },
      },
    },

    picker = {
      name = "telescope.nvim",
      note_mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
      tag_mappings = {
        tag_note = "<C-x>",
        insert_tag = "<C-l>",
      },
    },
  },
}
