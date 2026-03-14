local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

capabilities.textDocument.formatting = false
capabilities.textDocument.rangeFormatting = true

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

vim.lsp.enable "eslint"
vim.lsp.enable "jsonls"
vim.lsp.enable "kotlin_lsp"
vim.lsp.enable "lua_ls"
vim.lsp.enable "nixd"
vim.lsp.enable "vue_ls"
vim.lsp.enable "yamlls"
