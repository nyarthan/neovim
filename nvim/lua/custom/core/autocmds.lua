local Job = require("plenary.Job")

local Util = require("custom.util")

local M = {}

M.check_is_in_git_repo = function(cb)
	local job = Job:new({
		command = "git",
		args = { "rev-parse", "--is-inside-worktree" },
		on_exit = function(_, exit_code)
			cb(tonumber(exit_code) == 0)
		end,
	})

	job:start()
end

M.GitCheck = {}
M.GitCheck.__index = M.GitCheck

function M.GitCheck:new(cbs)
	self.cbs = cbs
	self.enabled = false
	return self
end

function M.GitCheck:_run_callbacks(is_in_git_repo)
	vim.schedule(function()
		for _, cb in ipairs(self.cbs) do
			cb(is_in_git_repo)
		end
	end)
end

function M.GitCheck:enable()
	if self.enabled then
		return
	end
	self.enabled = true

	self.group = vim.api.nvim_create_augroup("GitCheck", { clear = true })
	vim.api.nvim_create_autocmd("DirChanged", {
		desc = "Checks if is in git repo",
		group = self.group,
		callback = Util.bind(M.check_is_in_git_repo, function(is_in_git_repo)
			self:_run_callbacks(is_in_git_repo)
		end),
	})

	M.check_is_in_git_repo(function(is_in_git_repo)
		self:_run_callbacks(is_in_git_repo)
	end)
end

function M.GitCheck:disable()
	if not self.enabled then
		return
	end
	self.enabled = false

	vim.api.nvim_del_augroup_by_id(self.group)
end

return M
