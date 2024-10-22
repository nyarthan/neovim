local ops = {
  { "f", target = "forward", desc = "Jump forward", mode = { "n", "v", "x" } },
  { "F", target = "backward", desc = "Jump backwards", mode = { "n", "v", "x" } },
  { "t", target = "forward_till", desc = "Jump forward till", mode = { "n", "v", "x" } },
  { "T", target = "backward_till", desc = "Jump backwards till", mode = { "n", "v", "x" } },
  { ";", target = "repeat_jump", desc = "Repeat jump", mode = { "n", "v", "x" } },
}

local opts = { mappings = {} }
for _, op in ipairs(ops) do
  opts.mappings[op.target] = op[1]
end

local keys = {}
for _, op in ipairs(ops) do
  table.insert(keys, { op[1], desc = op.desc, mode = op.mode })
end

return {
  "echasnovski/mini.jump",
  opts = opts,
  keys = keys,
}
