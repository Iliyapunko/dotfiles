local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

return {
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  dependencies = {
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    cmp.setup {
      preselect = cmp.PreselectMode.None,
      -- local compare = require 'cmp.config.compare'
      -- sorting = {
      --   priority_weight = 2,
      --   comparators = {
      --     compare.offset,
      --     compare.exact,
      --     compare.recently_used,
      --     compare.locality,
      --     compare.length,
      --     compare.score,
      --     compare.scopes,
      --     compare.kind,
      --     compare.sort_text,
      --     compare.order,
      --   },
      -- },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end
      },
      duplicates = {
        nvim_lsp = 1,
        luasnip = 1,
        cmp_tabnine = 1,
        buffer = 1,
        path = 1,
      },
      window = {
        completion = {
          winhighlight = "FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          col_offset = -2,
          side_padding = 0,
        },
        documentation = {
          winhighlight = "FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }
      },
      -- formatting = {
      --   format = function(entry, vim_item)
      --     local icon = require 'sources.icons'.icons[vim_item.kind]

      --     vim_item.kind = string.format('%s %s', icon, vim_item.kind)
      --     vim_item.menu = sources[entry.source.name]

      --     return vim_item
      --   end,
      -- },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = " " .. strings[1]
          kind.menu = " " -- "    (" .. strings[2] .. ")"

          return kind
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        -- ['<C-e>'] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        -- ["<CR>"] = cmp.mapping.confirm { select = false },
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif require("luasnip").expand_or_jumpable() then
        --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s", }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      sources = cmp.config.sources {
        {
          name = 'luasnip',
          priority = 1
        },
        {
          name = 'nvim_lsp',
          priority = 9
        },
        {
          name = 'path',
          priority = 8
        },
        {
          name = 'buffer',
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          },
          priority = 7
        },
      },
      experimental = {
        ghost_text = {
          hl_group = "LspCodeLens",
        },
      }
    }
  end
}
