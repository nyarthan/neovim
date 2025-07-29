local keys = {
  { "gh", op = "apply", desc = "Apply hunks", mode = { "n", "x" } },
  { "gH", op = "reset", desc = "Reset hunks", mode = { "n", "x" } },
  { "[H", op = "goto_first", desc = "Go to first hunk", mode = { "n", "x" } },
  { "[h", op = "goto_prev", desc = "Go to previous hunk", mode = { "n", "x" } },
  { "]h", op = "goto_next", desc = "Go to next hunk", mode = { "n", "x" } },
  { "]H", op = "goto_last", desc = "Go to last hunk", mode = { "n", "x" } },
}

local opts = {
  view = {
    style = "sign",
    priority = 199,
  },
  mappings = {
    apply = "gh",
    reset = "gH",
    textobject = "gh",
    goto_first = "[H",
    goto_prev = "[h",
    goto_next = "]h",
    goto_last = "]H",
  },
}

for _, key in ipairs(keys) do
  opts.mappings[key.op] = key[1]
end

local keys_spec = {}

for _, key in ipairs(keys) do
  table.insert(keys_spec, { key[1], desc = key.desc, mode = key.mode })
end

return {
  "echasnovski/mini.diff",
  event = "BufEnter",
  opts = opts,
  keys = keys_spec,
}
