local bracketed = require "custom.plugins.mini.bracketed"
local diff = require "custom.plugins.mini.diff"
local files = require "custom.plugins.mini.files"
local hipatterns = require "custom.plugins.mini.hipatterns"
local icons = require "custom.plugins.mini.icons"
local indentscope = require "custom.plugins.mini.indentscope"
local jump = require "custom.plugins.mini.jump"
local move = require "custom.plugins.mini.move"
local pairs = require "custom.plugins.mini.pairs"
local pick = require "custom.plugins.mini.pick"
local sessions = require "custom.plugins.mini.sessions"
local starter = require "custom.plugins.mini.starter"
local statusline = require "custom.plugins.mini.statusline"
local surround = require "custom.plugins.mini.surround"

local all_keys = {}

for _, t in ipairs {
  bracketed.keys,
  diff.keys,
  jump.keys,
  move.keys,
  pairs.keys,
  pick.keys,
  surround.keys,
} do
  for _, v in ipairs(t) do
    table.insert(all_keys, v)
  end
end

return {
  "nvim-mini/mini.nvim",
  lazy = false,
  config = function()
    bracketed.config()
    diff.config()
    files.config()
    hipatterns.config()
    icons.config()
    indentscope.config()
    jump.config()
    move.config()
    pairs.config()
    pick.config()
    sessions.config()
    starter.config()
    statusline.config()
    surround.config()
  end,
  keys = all_keys,
}
