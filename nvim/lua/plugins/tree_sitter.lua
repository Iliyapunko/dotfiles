local languages = {
	'javascript',
	'rust',
	'typescript',
	'toml',
	'yaml',
	'vim',
	'tsx',
	'markdown',
	'json',
	'lua',
	'make',
	'css',
	'html',
	'scss',
	'dockerfile',
	'fish',
	'glimmer',
	'scheme',
	'sql',
	'python',
	'bash',
	'regex',
	'norg',
	'kdl',
	'proto',
	'markdown_inline',
	'nu',
	'graphql',
}

local add_mixins = function()
	-- vim.treesitter.language.register('fish', 'nu')
end

return {
	{
		'nvim-treesitter/nvim-treesitter-context',
		event = 'BufReadPre',
		enabled = true,
		keys = {
			{ '[c', function() require('treesitter-context').go_to_context() end },
		},
		opts = {
			max_lines = 1,
		},
	},

	{
		'nvim-treesitter/nvim-treesitter',
		version = false,
		lazy = false,
		build = ':TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		keys = {
			{ 'u', function() require('helpers.unit').select(true) end, mode = { 'x', 'o' } },
		},
		config = function()
			local install = require 'nvim-treesitter.install'
			local config = require 'nvim-treesitter.configs'
			local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

			install.compilers = { 'gcc' }

			parser_config.nu = {
				install_info = {
					url = 'https://github.com/nushell/tree-sitter-nu',
					files = { 'src/parser.c' },
					branch = 'main',
				},
				filetype = 'nu',
			}

			config.setup {
				ensure_installed = languages,
				query_linter = {
					enable = true,
					use_virtual_text = true,
					lint_events = { 'BufWrite', 'CursorHold' },
				},
				autotag = {
					enable = true,
				},
				endwise = {
					enable = true,
				},
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							['if'] = '@function.inner',
						},
					},
					move = {
						enable = true,
						goto_next_start = {
							[']]'] = '@function.outer',
							[']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
							[']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
						},
						goto_next_end = {
							[']['] = '@function.outer',
						},
						goto_previous_start = {
							['[['] = '@function.outer',
							['[s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
						},
						goto_previous_end = {
							['[]'] = '@function.outer',
						},
					},
				},
				highlight = {
					enable = true,
					use_languagetree = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
					disable = {},
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = '<Enter>',
						node_incremental = '<Enter>',
						node_decremental = '<BS>',
					},
				},
			}

			add_mixins()
		end,
	},
}
