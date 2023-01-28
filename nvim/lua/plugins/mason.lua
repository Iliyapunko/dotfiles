local tools = {
  'stylua',
  'lua-language-server',
  'prettierd',
  'rust-analyzer',
  'typescript-language-server',
  'json-lsp',
}

return {
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()

      local mason = require 'mason'
      local mr = require 'mason-registry'
      local mason_lspconfig = require 'mason-lspconfig'

      mason.setup()

      for _, tool in ipairs(tools) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end

      mason_lspconfig.setup {
        automatic_installation = true,
      }

    end,
  }
}
