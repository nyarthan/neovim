local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

capabilities.textDocument.formatting = nil
capabilities.textDocument.rangeFormatting = nil

vim.lsp.config("*", {
  capabilities = capabilities,
  init_options = { hostInfo = "neovim" },
  root_markers = {
    ".git/",
  },
})

vim.lsp.config("jsonls", {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = {
        { url = "https://www.schemastore.org/package.json", fileMatch = { "package.json" } },
        {
          url = "https://www.schemastore.org/tsconfig.json",
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
        },
        { url = "https://turborepo.dev/schema.json", fileMatch = { "turbo.json", "turbo.jsonc" } },
      },
    },
  },
})

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  settings = {
    yaml = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
      schemas = {
        {
          url = "https://www.schemastore.org/pnpm-workspace.json",
          fileMatch = { "pnpm-workspace.yaml" },
        },
        {
          url = "https://www.schemastore.org/github-workflow.json",
          fileMatch = { ".github/workflows/*.yaml", ".github/workflows/*.yml" },
        },
      },
    },
  },
})

vim.lsp.config("nixd", {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = {
    ".git/",
    "flake.lock",
  },
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath "config"
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

vim.lsp.config("tsgo", {
  cmd = { "tsgo", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = function(bufnr, on_dir)
    local root_markers =
      { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
    root_markers = vim.fn.has "nvim-0.11.3" == 1 and { root_markers, { ".git" } }
      or vim.list_extend(root_markers, { ".git" })

    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
    local project_root = vim.fs.root(bufnr, root_markers)
    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then return end
    if deno_root and (not project_root or #deno_root >= #project_root) then return end
    on_dir(project_root or vim.fn.getcwd())
  end,
})

vim.lsp.enable "tsgo"
vim.lsp.enable "eslint"
vim.lsp.enable "jsonls"
vim.lsp.enable "kotlin_lsp"
vim.lsp.enable "lua_ls"
vim.lsp.enable "nixd"
vim.lsp.enable "vue_ls"
vim.lsp.enable "yamlls"
