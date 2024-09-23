local Color = require "custom.color"

local function key_desc(desc) return string.format("%s " .. desc, Color.green "[TELESCOPE]") end

local function bind_builtins_fn(fn_name, ...)
  local args = { ... }
  return function()
    local builtin = require "telescope.builtin"
    builtin[fn_name](unpack(args))
  end
end

return {
  "telescope.nvim",
  dependencies = { "plenary.nvim", "telescope-fzf-native.nvim" },
  cmd = "Telescope",
  opts = function()
    return {
      defaults = {
        mappings = {
          n = {
            ["<C-b>"] = function(prompt_bufnr)
              print(prompt_bufnr)
              local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              vim.g.baleia.once(picker.results_bufnr)
            end,
            ["<C-t>"] = function(bufnr)
              print(bufnr)
              require("trouble.sources.telescope").open(bufnr)
            end,
          },
          i = {
            ["<C-t>"] = require("trouble.sources.telescope").open,
          },
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require "telescope"
    telescope.setup(opts)
    telescope.load_extension "fzf"
  end,
  keys = {
    {
      "<Leader>ff",
      mode = "n",
      desc = key_desc "Find files",
      bind_builtins_fn "find_files",
    },
    {
      "<Leader>fg",
      mode = "n",
      desc = key_desc "Live grep",
      bind_builtins_fn "live_grep",
    },
    {
      "<Leader>fs",
      mode = "n",
      desc = key_desc "String grep",
      bind_builtins_fn "grep_string",
    },
    {
      "<Leader>fb",
      mode = "n",
      desc = key_desc "Buffers",
      bind_builtins_fn "buffers",
    },
    {
      "<Leader>fh",
      mode = "n",
      desc = key_desc "Help tags",
      bind_builtins_fn "help_tags",
    },
    {
      "<Leader>fk",
      mode = "n",
      desc = key_desc "Keymaps",
      bind_builtins_fn "keymaps",
    },
    {
      "<Leader>fr",
      mode = "n",
      desc = key_desc "Resume",
      bind_builtins_fn "resume",
    },
  },
}
