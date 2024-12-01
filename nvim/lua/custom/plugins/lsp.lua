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
          underline = { severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN } },
          virtual_text = {
            source = false, -- handled by format
            prefix = function(diagnostic, i, total)
              if i ~= total then return "" end
              return diagnostic_signs[diagnostic.severity] .. " "
            end,
            --[[ format = function(diagnostic)
              return vim.trim(Util.str_rm_trailing(diagnostic.message, "."))
                  .. " | "
                  .. vim.trim(Util.str_rm_trailing(diagnostic.source, "."))
            end, ]]
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
        map("<Leader>d", vim.diagnostic.open_float)

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client.name ~= "efm" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

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

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
          vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup("LspAutoformat", { clear = true }),
            callback = function() vim.lsp.buf.format { async = false } end,
          })

          -- TODO: this is for future me
          --[[ vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_formatting] = function(
            err,
            result,
            ctx
          )
            if err ~= nil or result == nil then return end

            -- Step 1: Get current cursor position and node under the cursor
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local cursor_row = cursor_pos[1] - 1 -- 0-based index
            local cursor_col = cursor_pos[2]
            local line_text =
              vim.api.nvim_buf_get_lines(ctx.bufnr, cursor_row, cursor_row + 1, false)[1]

            --- @param bufnr integer
            --- @param row integer
            --- @param col integer
            local function has_capture(bufnr, row, col)
              return not vim.tbl_isempty(vim.treesitter.get_captures_at_pos(bufnr, row, col))
            end

            local has_current_capture = has_capture(ctx.bufnr, cursor_row, cursor_col)
            local has_left_capture = has_capture(ctx.bufnr, cursor_row, cursor_col - 1)
            local has_right_capture = has_capture(ctx.bufnr, cursor_row, cursor_col + 1)

            local should_preserve_offset = false
            --- @type TSNode?
            local node

            -- cursor is on top of capture
            if has_current_capture then
              should_preserve_offset = true
              node = vim.treesitter.get_node()
              vim.lsp.util.apply_text_edits(result, ctx.bufnr, "utf-8")
            -- cursor is in between captures
            elseif not has_current_capture and has_left_capture and has_right_capture then
              should_preserve_offset = true
              node = vim.treesitter.get_node()
              vim.lsp.util.apply_text_edits(result, ctx.bufnr, "utf-8")
            -- cursor is somewhere else
            elseif not has_current_capture then
              vim.lsp.util.apply_text_edits(result, ctx.bufnr, "utf-8")
              local left_char_pos, right_char_pos = nil, nil

              for i = cursor_col, 1, -1 do
                if not line_text:sub(i, i):match "%s" then
                  left_char_pos = i - 1 -- Adjust for 0-based indexing
                  break
                end
              end

              for i = cursor_col + 1, #line_text do
                if not line_text:sub(i, i):match "%s" then
                  right_char_pos = i - 1 -- Adjust for 0-based indexing
                  break
                end
              end

              -- If both left and right characters are found, choose the nearest
              if left_char_pos and right_char_pos then
                local left_dist = cursor_col - left_char_pos
                local right_dist = right_char_pos - cursor_col

                if left_dist <= right_dist then
                  -- Get the node at the left character position
                  node = vim.treesitter.get_node {
                    bufnr = ctx.bufnr,
                    pos = { cursor_row, left_char_pos },
                  }
                  cursor_col = select(2, node:start()) -- Snap cursor to the start of the node
                else
                  -- Get the node at the right character position
                  node = vim.treesitter.get_node {
                    bufnr = ctx.bufnr,
                    pos = { cursor_row, right_char_pos },
                  }
                  cursor_col = right_char_pos
                end
              elseif left_char_pos then
                -- Only left character found
                node =
                  vim.treesitter.get_node { bufnr = ctx.bufnr, pos = { cursor_row, left_char_pos } }
                cursor_col = select(2, node:end_()) -- Move cursor to the start of the node
                should_preserve_offset = false
              elseif right_char_pos then
                -- Only right character found
                node = vim.treesitter.get_node {
                  bufnr = ctx.bufnr,
                  pos = { cursor_row, right_char_pos },
                }
                cursor_col = select(2, node:start())
                should_preserve_offset = false
              else
                -- No non-whitespace characters found, move to the start of the line or nearest node
                return
              end
            end

            -- Step 4: Calculate the offset only if necessary
            local relative_offset = 0
            if should_preserve_offset then
              local node_start_row, node_start_col = node:start()
              relative_offset = cursor_col - node_start_col
            end

            -- Step 5: Save the AST path of the node
            local node_path = Util.get_ast_path(node)

            -- Save the current view (scroll position, etc.)
            local view = vim.fn.winsaveview()

            -- Step 6: Apply formatting edits

            -- Step 7: Re-parse the buffer after formatting
            local parser = vim.treesitter.get_parser(ctx.bufnr)
            local root = parser:parse(true)[1]:root()
            local updated_node = Util.find_node_by_path(root, node_path)

            -- Step 8: Set the new cursor position based on the updated node and preserved offset
            if updated_node then
              local new_row, new_col = updated_node:start()

              if should_preserve_offset then
                -- Preserve the relative offset within the node
                local new_cursor_col = new_col + relative_offset
                view.lnum = new_row + 1 -- Adjust for 1-based indexing in Vim
                view.col = new_cursor_col
              else
                -- No offset to preserve, cursor is placed based on node selection
                view.lnum = new_row + 1
                view.col = cursor_col
              end
            else
              vim.print "Node could not be found after formatting."
            end

            -- Step 9: Restore the view (including the updated cursor position)
            vim.fn.winrestview(view)
          end ]]
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
            ignoreDir = { ".direnv" },
          },
        },
      },
      nil_ls = {},
      ts_ls = {},
      yamlls = {},
      taplo = {},
      html = {},
      cssls = {},
      jsonls = {},
      eslint = {},
      volar = {},
      denols = {},
      rust_analyzer = {}
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
    }
  end,
}
