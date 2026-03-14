local keys = {
  { "<M-h>", op = "left", desc = "Move left", mode = { "v" } },
  { "<M-l>", op = "right", desc = "Move right", mode = { "v" } },
  { "<M-k>", op = "up", desc = "Move up", mode = { "v" } },
  { "<M-j>", op = "down", desc = "Move down", mode = { "v" } },
  { "<M-h>", op = "line_left", desc = "Move line left", mode = { "n" } },
  { "<M-l>", op = "line_right", desc = "Move line right", mode = { "n" } },
  { "<M-k>", op = "line_up", desc = "Move line up", mode = { "n" } },
  { "<M-j>", op = "line_down", desc = "Move line down", mode = { "n" } },
}

local keys_spec = {}

for _, key in ipairs(keys) do
  table.insert(keys_spec, { key[1], desc = key.desc, mode = key.mode })
end

return {
  config = function()
    local opts = {
      mappings = {},
    }

    for _, key in ipairs(keys) do
      opts.mappings[key.op] = key[1]
    end

    require("mini.move").setup(opts)
  end,
  keys = keys_spec,
}
