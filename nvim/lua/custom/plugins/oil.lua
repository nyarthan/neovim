local Util = require "custom.util"
local Color = require "custom.color"

return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = false,
    view_options = {
      is_always_hidden = function(name)
        if name ~= "result" then return false end

        local stat = vim.uv.fs_lstat(name)
        if stat and stat.type == "link" then
          local target = vim.uv.fs_readlink(name)
          if target and target:match "^/nix/store/" then return true end
        end

        return false
      end,
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "-",
      Util.make_cmd "Oil",
      mode = "n",
      desc = string.format("%s Open parent directory", Color.green "[OIL]"),
    },
  },
}
