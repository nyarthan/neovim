local Job = require "plenary.Job"

local Util = require "custom.util"

local M = {}

M.check_is_in_git_repo = function(cb)
  local job = Job:new {
    command = "git",
    args = { "rev-parse", "--is-inside-worktree" },
    on_exit = function(_, exit_code) cb(tonumber(exit_code) == 0) end,
  }

  job:start()
end

M.check_is_in_dir = function(path, directory)
  if not directory:match "/$" then directory = directory .. "/" end

  local abs_path = vim.fn.fnamemodify(path, ":p")
  local abs_directory = vim.fn.fnamemodify(directory, ":p")

  return abs_path:sub(1, #abs_directory) == abs_directory
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
  if self.enabled then return end
  self.enabled = true

  self.group = vim.api.nvim_create_augroup("GitCheck", { clear = true })
  vim.api.nvim_create_autocmd("DirChanged", {
    desc = "Checks if is in git repo",
    group = self.group,
    callback = Util.bind(
      M.check_is_in_git_repo,
      function(is_in_git_repo) self:_run_callbacks(is_in_git_repo) end
    ),
  })

  M.check_is_in_git_repo(function(is_in_git_repo) self:_run_callbacks(is_in_git_repo) end)
end

function M.GitCheck:disable()
  if not self.enabled then return end
  self.enabled = false

  vim.api.nvim_del_augroup_by_id(self.group)
end

M.ObsidianCheck = {}
M.ObsidianCheck.__index = M.ObsidianCheck

function M.ObsidianCheck:new(cbs, vault_dir)
  self.vault_dir = vault_dir
  self.cbs = cbs
  self.enabled = false
  return self
end

function M.ObsidianCheck:_run_callbacks(is_in_obsidian_dir)
  vim.schedule(function()
    for _, cb in ipairs(self.cbs) do
      cb(is_in_obsidian_dir)
    end
  end)
end

function M.ObsidianCheck:enable()
  if self.enabled then return end
  self.enabled = true

  self.group = vim.api.nvim_create_augroup("ObsidianCheck", { clear = true })
  vim.api.nvim_create_autocmd("DirChanged", {
    desc = "Checks if is in git repo",
    group = self.group,
    callback = function() self:_run_callbacks(M.check_is_in_dir(vim.loop.cwd(), self.vault_dir)) end,
  })

  self:_run_callbacks(M.check_is_in_dir(vim.loop.cwd(), self.vault_dir))
end

function M.ObsidianCheck:disable()
  if not self.enabled then return end
  self.enabled = false

  vim.api.nvim_del_augroup_by_id(self.group)
end

return M
