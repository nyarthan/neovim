local Util = require "custom.util"

local function is_in_git_flake(path)
  return Util.is_file_in_root(path, { root_markers = { "flake.nix", ".git/" }, match_type = "all" })
end

return {
  "stevearc/oil.nvim",
  lazy = false,
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
    git = {
      add = function(path) return is_in_git_flake(path) end,
      mv = function(src_path, des_path)
        return is_in_git_flake(src_path) and is_in_git_flake(des_path)
      end,
      rm = function(path) return is_in_git_flake(path) end,
    },
  },
  dependencies = { "echasnovski/mini.icons" },
  keys = {
    {
      "-",
      Util.make_cmd "Oil",
      mode = "n",
      desc = "Open parent directory",
    },
  },
}
