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

-- Check if a file or directory exists
M.file_exists = function(path) return vim.uv.fs_lstat(path) ~= nil end

-- Check if the given directory contains any of the root markers
M.has_root_marker = function(dir, root_markers)
  for _, root_marker in ipairs(root_markers) do
    if M.file_exists(dir .. "/" .. root_marker) then return true end
  end
  return false
end

-- Check if a directory contains the specified root markers based on match type ("any" or "all")
M.match_root_markers = function(found_root_markers, total_root_markers, match_type)
  if match_type == "all" then return #found_root_markers == #total_root_markers end
  return #found_root_markers > 0 -- Default behavior is "any"
end

-- Traverse the directories upwards from the path and check for root markers
M.has_root_marker_in_path = function(path, root_markers, match_type)
  -- Resolve the real path, or use the provided path if it's not yet on disk
  local real_path = vim.uv.fs_realpath(path)
  local dir = real_path and vim.fs.dirname(real_path) or vim.fs.dirname(path)
  dir = dir or path

  -- Traverse upwards through the directories
  while dir do
    local found_markers = {}

    -- Check if the current directory contains the root markers
    for _, root_marker in ipairs(root_markers) do
      if M.file_exists(dir .. "/" .. root_marker) then table.insert(found_markers, root_marker) end
    end

    -- Return true if the root markers satisfy the match condition
    if M.match_root_markers(found_markers, root_markers, match_type) then return true end

    -- Move up to the parent directory
    local parent_dir = vim.uv.fs_realpath(vim.fs.dirname(dir))
    if parent_dir == dir then break end
    dir = parent_dir
  end

  return false
end

-- Entry function that checks if a file is in a directory with specified root markers
M.is_file_in_root = function(path, opts)
  local match_type = opts.match_type or "any" -- Default to "any"
  return M.has_root_marker_in_path(path, opts.root_markers, match_type)
end

return M
