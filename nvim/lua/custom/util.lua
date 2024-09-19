local M = {}

--- Bind arguments to a function, returning a new function with partially applied arguments.
--- This is a generic function that allows partially applying arguments to a given function.
--- The returned function will append additional arguments passed to it when invoked.
---
--- @param fn function The function to partially apply arguments to.
--- @param ... any Initial arguments to bind to the function.
---
--- @return function # A new function that takes additional arguments.
M.bind = function(fn, ...)
  local args = { ... }
  return function(...)
    local new_args = { unpack(args) }
    for _, v in ipairs { ... } do
      table.insert(new_args, v)
    end
    return fn(unpack(new_args))
  end
end

--- @generic T
--- @param list T[] List of items to be deduplicated
--- @return T[] A new list with duplicate items removed
M.dedupe = function(list)
  local seen = {}
  local result = {}

  for _, item in ipairs(list) do
    if not seen[item] then
      seen[item] = true
      table.insert(result, item)
    end
  end

  return result
end

--- @generic T
--- @param item T|T[] A single item or a list of items
--- @return T[] A list of items, ensuring that a single item is wrapped in a list
M.to_list = function(item)
  if type(item) == "table" then
    return item
  else
    return { item }
  end
end

--- @generic T
--- @param list1 T[] The first list of items
--- @param list2 T[] The second list of items
--- @return T[] A new list containing all items from list1 followed by all items from list2
M.list_concat = function(list1, list2)
  local result = {}

  for _, item in ipairs(list1) do
    table.insert(result, item)
  end

  for _, item in ipairs(list2) do
    table.insert(result, item)
  end

  return result
end

--- @class M.make_cmp.Opts: vim.keymap.set.Opts
--- @inlinedoc
---
--- Mode short-name, see |nvim_set_keymap()|.
--- Can also be list of modes to create mapping on multiple modes.
--- @field mode? string|string[]

--- @param initial_opts? M.make_cmp.Opts
M.make_map = function(initial_opts)
  initial_opts = initial_opts or {}
  local initial_mode = M.to_list(initial_opts.mode --[[ @as string ]])
  initial_opts.mode = nil

  --- @param lhs string           Left-hand side |{lhs}| of the mapping.
  --- @param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
  --- @param opts? M.make_cmp.Opts
  return function(lhs, rhs, opts)
    opts = opts or {}
    local mode = M.to_list(opts.mode --[[ @as string ]])
    opts.mode = nil

    local final_mode = M.dedupe(M.list_concat(initial_mode, mode))

    vim.keymap.set(final_mode, lhs, rhs, vim.tbl_extend("force", initial_opts or {}, opts or {}))
  end
end

--- Create a normal mode keymap by binding a function and passing the mode "n" (normal mode).
---
--- @type fun(lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts): boolean
M.nmap = M.bind(vim.keymap.set, "n")

--- Create a command in `<Cmd> ... <Cr>` format for use in key mappings.
--- This function returns a command-mode string that executes the given command and appends `<Cr>`.
---
--- @param cmd string The command to wrap with `<Cmd>` and `<Cr>`.
---
--- @return string # A string formatted as `<Cmd> <command> <Cr>`.
M.make_cmd = function(cmd) return string.format("<Cmd> %s <Cr>", cmd) end

--- Create an Ex command in `:<C-U> ... <Cr>` format for use in key mappings.
--- This function returns an Ex command string that clears the command-line and executes the given command.
---
--- @param ex_cmd string The Ex command to wrap with `:<C-U>` and `<Cr>`.
---
--- @return string # A string formatted as `:<C-U> <ex_command> <Cr>`.
M.make_ex_cmd = function(ex_cmd)
  -- <C-E> : move to end of the command-line
  -- <C-U> : clear all text to the left of the cursor
  return string.format(":<C-E><C-U> %s <Cr>", ex_cmd)
end

--- Get the current mode of Neovim.
--- This function returns the mode Neovim is currently in (e.g., "n" for normal mode).
---
--- @return string # The current mode as a string (e.g., "n" for normal mode, "i" for insert mode).
M.get_mode = function() return vim.api.nvim_get_mode().mode end

return M
