-- Disables builtin external providers
-- See `:help provider`
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- System Clipboard Provider
-- See `:help clipboard`
vim.opt.clipboard = "unnamedplus"
