return {
  'shortcuts/no-neck-pain.nvim',
  config = function()

    local nnp = require 'no-neck-pain'

    nnp.setup {
      autocmds = {
        enableOnVimEnter = false,
      },

      width = 120,

      buffers = {
        backgroundColor = nil,

        bo = {
          filetype = 'norg',
        }
      },

   }

  end
}
