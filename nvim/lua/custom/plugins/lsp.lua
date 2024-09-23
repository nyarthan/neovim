local Util = require "custom.util"
local Symbols = require "custom.symbols"

return {
  "neovim/nvim-lspconfig",
  dev = true,
  event = { "BufEnter" },
  dependencies = {
    {
      "j-hui/fidget.nvim",
      opts = {
        integration = {
          ["nvim-tree"] = {
            enable = false,
          },
          ["xcodebuild-nvim"] = {
            enable = false,
          },
        },
      },
    },
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
      callback = function(event)
        local diagnostic_signs = {
          [vim.diagnostic.severity.ERROR] = Symbols.nf.cod_error,
          [vim.diagnostic.severity.WARN] = Symbols.nf.cod_warning,
          [vim.diagnostic.severity.HINT] = Symbols.nf.cod_lightbulb,
          [vim.diagnostic.severity.INFO] = Symbols.nf.cod_info,
        }
        vim.diagnostic.config {
          severity_sort = true,
          signs = {
            text = diagnostic_signs,
          },
          underline = {severity = {vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN}},
          virtual_text = {
            source = false, -- handled by format
            prefix = function(diagnostic, i, total)
              if i ~= total then return "" end
              return diagnostic_signs[diagnostic.severity] .. " "
            end,
            format = function(diagnostic)
              return vim.trim(Util.str_rm_trailing(diagnostic.message, "."))
                .. " | "
                .. vim.trim(Util.str_rm_trailing(diagnostic.source, "."))
            end,
          },
        }

        local t_builtin = require "telescope.builtin"

        local map = Util.make_map { mode = "n", buffer = event.buf }

        map("gd", t_builtin.lsp_definitions)
        map("gD", vim.lsp.buf.declaration)
        map("gr", t_builtin.lsp_references)
        map("gI", t_builtin.lsp_implementations)
        map("<Leader>gd", t_builtin.lsp_type_definitions)
        map("<Leader>gs", t_builtin.lsp_document_symbols)
        map("<Leader>gws", t_builtin.lsp_dynamic_workspace_symbols)
        map("<Leader>rn", vim.lsp.buf.rename)
        map("<Leader>ca", vim.lsp.buf.code_action, { mode = { "x" } })

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if
          client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
        then
          local highlight_augroup = vim.api.nvim_create_augroup("LspHighlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if
          client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol)
        then
          require("nvim-navic").attach(client, event.buf)
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
          vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup("LspAutoformat", { clear = true }),
            callback = function() vim.lsp.buf.format() end,
          })
        end

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("LspDetach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = "LspHighlight", buffer = event2.buf }
            vim.api.nvim_clear_autocmds { group = "LspAutoformat", buffer = event2.buf }
          end,
        })
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities =
      vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local servers = {
      lua_ls = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          workspace = {
            library = {
              vim.fn.expand "~/.config/neovim",
            },
          },
        },
      },
      nil_ls = {},
      ts_ls = {},
      yamlls = {},
      taplo = {},
      rust_analyzer = {},
      html = {},
      cssls = {},
      jsonls = {},
      eslint = {},
    }

    for server, settings in pairs(servers) do
      require("lspconfig")[server].setup {
        settings = settings,
        init_options = { documentFormatting = false },
        capabilities = capabilities,
      }
    end

    require("lspconfig").efm.setup {
      capabilities = capabilities,
      init_options = { documentFormatting = true },
    }
  end,
}
