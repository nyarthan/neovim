local ops = {
  { suffix = "b", target = "buffer" },
  { suffix = "c", target = "comment" },
  { suffix = "x", target = "conflict" },
  { suffix = "d", target = "diagnostic" },
  { suffix = "f", target = "file" },
  { suffix = "i", target = "indent" },
  { suffix = "j", target = "jump" },
  { suffix = "l", target = "location" },
  { suffix = "o", target = "oldfile" },
  { suffix = "p", target = "quickfix" },
  { suffix = "t", target = "treesitter" },
  { suffix = "u", target = "undo" },
  { suffix = "w", target = "window" },
  { suffix = "y", target = "yank" },
}

local opts = {}

for _, op in ipairs(ops) do
  opts[op.target] = { suffix = op.suffix, options = {} }
end

local keys = {}

for _, op in ipairs(ops) do
  table.insert(
    keys,
    { "[" .. string.upper(op.suffix), desc = "Go to first " .. op.target, mode = { "n" } }
  )
  table.insert(keys, { "[" .. op.suffix, desc = "Go to previous " .. op.target, mode = { "n" } })
  table.insert(keys, { "]" .. op.suffix, desc = "Go to next " .. op.target, mode = { "n" } })
  table.insert(
    keys,
    { "[" .. string.upper(op.suffix), desc = "Go to last " .. op.target, mode = { "n" } }
  )
end

return {
  "echasnovski/mini.bracketed",
  opts = opts,
  keys = keys,
}
