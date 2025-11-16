local FILETYPES = {
  javascriptLike = {
    "javascript",
    "javascriptReact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.jsx",
  },
  jsonLike = {
    "json",
    "jsonc",
  },
  yaml = {
    "yaml",
    "yml",
  },
}

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

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = FILETYPES.javascriptLike,
  root_markers = {
    ".git/",
    "pnpm-lock.yaml",
    "yarn.lock",
    "deno.lock",
    "bun.lock",
    "bun.lockb",
  },
})

vim.lsp.config("jsonls", {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = FILETYPES.jsonLike,
  settings = {
    json = {
      schemas = {
        { url = "https://www.schemastore.org/package.json", fileMatch = { "package.json" } },
      },
    },
  },
})

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = FILETYPES.yaml,
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

local efm_prettier = {
  formatCanRange = true,
  formatCommand = "./node_modules/.bin/prettier --stdin --stdin-filepath '${INPUT}' ${--range-start:charStart} ${--range-end:charEnd} --config-precedence prefer-file",
  formatStdin = true,
  rootMarkers = {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.js",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.mjs",
    ".prettierrc.cjs",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
  },
}

local efm_capabilities = vim.deepcopy(capabilities)
efm_capabilities.textDocument.formatting = true
efm_capabilities.textDocument.rangeFormatting = true

vim.lsp.config("ts_ls", {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        -- TODO: pass location from nix
        location = "/nix/store/582wpl6ml9rin36ilzzi4srahmf9c3kq-vue-language-server-2.2.8/lib/node_modules/@vue/language-server",
        languages = { "vue" },
      },
    },
  },
  filetypes = { table.unpack(FILETYPES.javascriptLike), "vue" },
})

vim.lsp.config("efm", {
  filetypes = { "typescript", "typescriptreact" },
  capabilities = efm_capabilities,
  initi_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      javascript = { efm_prettier },
      javascriptreact = { efm_prettier },
      ["javascript.jsx"] = { efm_prettier },
      typescript = { efm_prettier },
      typescriptreact = { efm_prettier },
      ["typescripot.jsx"] = { efm_prettier },
    },
  },
})

vim.lsp.enable "efm"
vim.lsp.enable "eslint"
vim.lsp.enable "jsonls"
vim.lsp.enable "kotlin_lsp"
vim.lsp.enable "lua_ls"
vim.lsp.enable "nixd"
vim.lsp.enable "ts_ls"
vim.lsp.enable "vue_ls"
vim.lsp.enable "yamlls"
