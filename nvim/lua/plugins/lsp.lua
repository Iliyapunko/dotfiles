local function set_lsp_maps()
  map('n', '<leader>ti', ':TypescriptAddMissingImports<cr>')
  map('n', '<leader>tr', ':TypescriptRenameFile<cr>')
  map('n', '<leader>td', ':TypescriptRemoveUnused<cr>')
  map('n', '<leader>to', ':TypescriptOrganizeImports<cr>')
end

local function set_lsp_symbols()
  local char = '│'

  for _, hint in ipairs { 'Error', 'Information', 'Hint', 'Warning' } do
    vim.fn.sign_define('LspDiagnosticsSign' .. hint, {
      text = char,
      numhl = 'LspDiagnosticsSign' .. hint,
    })
  end
end

local function on_attach()
  map('n', 'gd', ':lua vim.lsp.buf.definition()<cr>')
  map('n', 'ga', ':vs<cr>:lua vim.lsp.buf.definition()<cr>')
  map('n', 'K', ':lua vim.lsp.buf.hover()<cr>')
  map('n', '<leader>lk', ':lua vim.lsp.buf.signature_help()<cr>')
  map('n', '<space>le', ':lua vim.diagnostic.open_float()<cr>')
  map('n', '[d', ':lua vim.diagnostic.goto_prev()<cr>')
  map('n', ']d', ':lua vim.diagnostic.goto_next()<cr>')
  map('n', '<space>lq', ':lua vim.diagnostic.set_loclist()<cr>')
  map('n', '<space>lq', ':lua vim.diagnostic.setqflist()<cr>')
  map('n', '<space>ls', function()
    vim.diagnostic.show()
  end)
  map('n', '<space>la', ':lua vim.lsp.buf.code_action()<cr>')
  map('n', '<space>lr', ':lua vim.lsp.buf.rename()<cr>')

  -- map('n', '<space>lc', ':lua vim.lsp.codelens.run()<cr>')
  -- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'InsertLeave' }, {
  --   pattern = '*',
  --   callback = vim.lsp.codelens.refresh,
  -- })
  --
  -- vim.api.nvim_create_autocmd('LspDetach', {
  --   callback = function(opt)
  --     vim.lsp.codelens.clear(opt.data.client_id, opt.buf)
  --   end,
  -- })
end

local function get_servers(capabilities)
  return {
    typescript = {
      server = {
        on_attach = function(client)
          client.server_capabilities.semanticTokensProvider = nil
          on_attach()
        end,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      },
      disable_commands = false,
      debug = false,
    },
    cssls = {},
    sqlls = {},
    html = {},
    pylsp = {},
    lua_ls = {
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = {
              'vim',
            },
          },
          format = {
            enable = false,
          },
        },
      },
    },
    emmet_ls = {
      is_not_highlight = true,
      filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
      init_options = {
        html = {
          options = {
            ['bem.enabled'] = true,
          },
        },
      },
    },
    rust_analyzer = {
      settings = {
        ['rust-analyzer'] = {
          assist = {
            importGranularity = 'module',
            importPrefix = 'self',
          },
          diagnostics = {
            enable = true,
            enableExperimental = true,
          },
          cargo = {
            loadOutDirsFromCheck = true,
          },
          procMacro = {
            enable = true,
          },
          inlayHints = {
            chainingHints = true,
            parameterHints = true,
            typeHints = true,
          },
        },
      },
    },
  }
end

return {
  'neovim/nvim-lspconfig',
  event = 'BufReadPre',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'jose-elias-alvarez/null-ls.nvim',
    'jose-elias-alvarez/typescript.nvim',
  },
  config = function()
    local config = require 'lspconfig'
    local typescript = require 'typescript'
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    set_lsp_symbols()
    set_lsp_maps()

    -- FUNCTIONS --
    local orig_set_signs = vim.lsp.diagnostic.set_signs
    local set_signs_limited = function(diagnostics, bufnr, client_id, sign_ns, opts)
      opts = opts or {}
      opts.severity_limit = 'Error'
      orig_set_signs(diagnostics, bufnr, client_id, sign_ns, opts)
    end

    vim.lsp.diagnostic.set_signs = set_signs_limited
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      -- virtual_text = false,
      virtual_text = {
        spacing = 8,
        prefix = ' ',
        -- severity = {
        -- Specify a range of severities
        --   min = vim.diagnostic.severity.ERROR,
        -- },
      },
      signs = false,
      underline = true,
      update_in_insert = false,
    })

    vim.lsp.handlers['textDocument/definition'] = function(_, result)
      if not result or vim.tbl_isempty(result) then
        print '[LSP] Could not find definition'
        return
      end

      if vim.tbl_islist(result) then
        vim.lsp.util.jump_to_location(result[1], 'utf-8')
      else
        vim.lsp.util.jump_to_location(result, 'utf-8')
      end
    end

    for server_name, opts in pairs(get_servers(capabilities)) do
      local server

      if server_name == 'typescript' then
        server = typescript
      else
        server = config[server_name]
      end

      server.setup(merge({
        on_attach = function(client)
          client.server_capabilities.semanticTokensProvider = nil
          on_attach()
        end,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }, opts))
    end

    map('n', '<leader>lf', function()
      vim.lsp.buf.format {
        timeout_ms = 5000,
      }
    end)
  end,
}
