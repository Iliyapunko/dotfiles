return {
  {
    'echasnovski/mini.align',
    config = function()
      local align = require 'mini.align'

      align.setup {}
    end,
  },

  {
    'echasnovski/mini.splitjoin',
    config = function()
      local m = require 'mini.splitjoin'

      m.setup {}
    end,
  },

  {
    'echasnovski/mini.surround',
    config = function()
      local m = require 'mini.surround'

      m.setup {}
    end,
  },

  {
    'echasnovski/mini.trailspace',
    config = function()
      local trail = require 'mini.trailspace'

      trail.setup {}
    end,
  },

  {
    'echasnovski/mini.comment',
    config = function()
      local comment = require 'mini.comment'

      comment.setup {
        mappings = {
          comment = 'gc',
          comment_line = 'gcc',
          textobject = 'gc',
        },
      }
    end,
  },

  {
    'echasnovski/mini.indentscope',
    enabled = false,
    config = function()
      local symbols = {
        '▏',
        '│',
        '⏐',
        '┊',
        '¦',
      }

      local indent = require 'mini.indentscope'

      indent.setup {

        draw = {
          delay = 100,
        },

        mappings = {},

        options = {
          border = 'both',
          indent_at_cursor = true,
          try_as_border = false,
        },

        symbol = symbols[1],
      }
    end,
  },
}
