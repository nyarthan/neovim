local M = {}

function M.bind(fn, ...)
	local args = { ... }
	return function(...)
		local new_args = { unpack(args) }
		for _, v in ipairs({ ... }) do
			table.insert(new_args, v)
		end
		return fn(unpack(new_args))
	end
end


M.nmap = M.bind(vim.keymap.set, "n")

return M
