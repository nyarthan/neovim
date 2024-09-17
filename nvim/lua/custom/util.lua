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
		for _, v in ipairs({ ... }) do
			table.insert(new_args, v)
		end
		return fn(unpack(new_args))
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
M.make_cmd = function(cmd)
	return string.format("<Cmd> %s <Cr>", cmd)
end

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
M.get_mode = function()
	return vim.api.nvim_get_mode().mode
end

return M
