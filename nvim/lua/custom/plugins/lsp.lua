local Util = require "custom.util"

return {
  "neovim/nvim-lspconfig",
  event = "BufEnter",
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

        --- @see [test](https://github.com/hrsh7th/nvim-cmp/issues/1699#issuecomment-1738132283)
        local md_namespace = vim.api.nvim_create_namespace "custom/lsp-flat"

        --- Adds extra inline highlights to the given buffer.
        ---@param buf integer
        local function add_inline_highlights(buf)
          for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
            for pattern, hl_group in pairs {
              ["@%S+"] = "@parameter",
              ["^%s*(Parameters:)"] = "@text.title",
              ["^%s*(Return:)"] = "@text.title",
              ["^%s*(See also:)"] = "@text.title",
              ["{%S-}"] = "@parameter",
              ["|%S-|"] = "@text.reference",
            } do
              local from = 1 ---@type integer?
              while from do
                local to
                from, to = line:find(pattern, from)
                if from then
                  vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
                    end_col = to,
                    hl_group = hl_group,
                  })
                end
                from = to and to + 1 or nil
              end
            end
          end
        end

        original_stylize_markdown = vim.lsp.util.stylize_markdown
        --- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
        ---@param bufnr integer
        ---@param contents string[]
        ---@param opts table
        ---@return string[]
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
          contents = vim.lsp.util._normalize_markdown(contents, {
            width = vim.lsp.util._make_floating_popup_size(contents, opts),
          })
          vim.bo[bufnr].filetype = "markdown"
          vim.treesitter.start(bufnr)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

          add_inline_highlights(bufnr)

          return contents
        end

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("LspDetach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = "LspHighlight", buffer = event2.buf }
            vim.api.nvim_clear_autocmds { group = "LspAutoformat", buffer = event2.buf }
            vim.lsp.util.stylize_markdown = original_stylize_markdown
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
