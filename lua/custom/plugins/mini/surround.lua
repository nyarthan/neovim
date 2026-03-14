local keys = {
  { "sa", op = "add", desc = "Add surrounding", mode = { "n" } },
  { "sa", op = "add", desc = "Add surrounding to selection", mode = { "v" } },
  { "sd", op = "delete", desc = "Delete surrounding", mode = { "n" } },
  { "sf", op = "find", desc = "Find surrounding (to the right)", mode = { "n" } },
  { "sF", op = "find_left", desc = "Find surrounding (to the left)", mode = { "n" } },
  { "sh", op = "highlight", desc = "Highlight surrounding", mode = { "n" } },
  { "sr", op = "replace", desc = "Replace surrounding", mode = { "n" } },
  { "sn", op = "update_n_lines", desc = "Update `n_lines`", mode = { "n" } },
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

    require("mini.surround").setup(opts)
  end,
  keys = keys_spec,
}
