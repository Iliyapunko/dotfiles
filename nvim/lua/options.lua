local o = vim.opt
local wo = vim.wo
local g = vim.g

g.mapleader = ' '

if vim.fn.has 'nvim-0.10' == 1 then o.smoothscroll = true end

local TAB_SIZE = 4

o.background = ''
o.guicursor = 'a:blinkon1,i-ci-ve:ver25-blinkon1'
o.selection = 'old'
o.tabstop = TAB_SIZE
o.softtabstop = TAB_SIZE
o.shiftwidth = TAB_SIZE
o.expandtab = true
o.fileencoding = 'utf-8'
o.wildmenu = true
o.wildignorecase = true
o.wildmode = 'longest,full'
o.wildoptions = 'pum'
o.pumblend = 0
o.pumheight = 15
o.mouse = 'a'
o.wrap = true
o.title = true
o.hidden = true
o.cmdheight = 1
o.scrolloff = 10
o.sidescrolloff = 8 -- Columns of context
o.shiftround = true -- Round indent
o.numberwidth = 3
o.number = false
o.relativenumber = false
o.showcmd = false
o.showmode = false
o.undofile = true
o.virtualedit = 'insert'
o.writebackup = false
o.backup = false
o.history = 1000
o.autoread = true
o.autowrite = true
o.infercase = true
o.timeoutlen = 1000
o.updatetime = 300
o.incsearch = true
o.showmatch = true
o.linebreak = true
o.showmode = false
o.swapfile = false
o.undolevels = 5000
o.modifiable = true
o.autoindent = true
o.smartindent = true
o.copyindent = false
o.ignorecase = true
o.ruler = false
o.cursorline = false
o.cursorcolumn = false
o.lazyredraw = false
o.ttyfast = true
o.splitright = true
o.splitbelow = true
o.breakindent = true
o.fixendofline = false
o.termguicolors = true
o.splitkeep = 'screen'
o.signcolumn = 'yes'
o.colorcolumn = '99999'
o.encoding = 'utf-8'
o.list = false
o.listchars:append {
    -- eol ='↲',
    trail = '·',
    nbsp = '␣',
}
o.fillchars = {
	-- horiz = "━",
	-- horizup = "┻",
	-- horizdown = "┳",
	-- vert = '┃',
	-- vertleft = "┫",
	-- vertright = "┣",
	-- verthoriz = "╋",
	eob = ' ',
	fold = ' ',
	foldopen = '',
	foldclose = '',
	diff = '╱',
	lastline = ' ',
    stl = ' ',
    stlnc = ' ',
}
o.inccommand = 'split'
o.showbreak = '  ↳ '
o.completeopt = 'menuone,preview,noselect'
o.complete = '.,w,b,u,t,U,s,k,d,i'
o.langmap =
	'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,'..
    'фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
o.imsearch = 0
o.iminsert = 0
o.laststatus = 2
o.grepprg = 'rg --vimgrep'
o.fileformat = 'unix'
o.fileformats = { 'unix', 'dos' }
o.binary = false
o.joinspaces = false -- No double spaces with join after a dot
o.clipboard:prepend { 'unnamedplus' }
o.shortmess:append 'sI'
o.whichwrap:append '<>hl'

wo.foldcolumn = '0'
wo.foldmethod = 'expr'
wo.foldexpr = 'nvim_treesitter#foldexpr()'
wo.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]
wo.foldminlines = 1
wo.foldlevel = 99
wo.conceallevel = 2
