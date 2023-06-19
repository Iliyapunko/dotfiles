map('n', '<F1>', ':w<cr>:e ++ff=dos<cr>:w ++ff=unix<cr>')
map('n', '<F9>', ':LspRestart<cr>')

map({ 'v', 'n' }, ':', ';')
map({ 'v', 'n' }, ';', ':', { noremap = true })

map('v', 'y', 'ygv<esc>')
map('v', 'p', ':put! "0=`]<cr>')
map('v', '<', '<gv')
map('v', '>', '>gv')

map({ 'c', 'i' }, '<C-r>', '<C-r>+', { noremap = false })

map('n', '<C-h>', ':wincmd h<cr>')
map('n', '<C-j>', ':wincmd j<cr>')
map('n', '<C-k>', ':wincmd k<cr>')
map('n', '<C-l>', ':wincmd l<cr>')

map('n', 'i', function()
  if #vim.fn.getline '.' == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true })

map('n', 'H', '^')
map('n', 'L', '$')

map('n', '<C-s>', ':wa<cr>')

map('n', '<C-d>', function()
  vim.api.nvim_feedkeys('4j', 'n', true)
end)
map('n', '<C-u>', function()
  vim.api.nvim_feedkeys('4k', 'n', true)
end)

map('n', 'cl', 'ct')
map('n', 'dl', 'dt')
map('n', 'yl', 'yt')
map('n', 'vl', 'vt')
map('n', '<C-a>', function()
  vim.g.minianimate_disable = true
  vim.cmd 'normal! gg0vG$'
  vim.g.minianimate_disable = false
end)

map('n', 'x', function()
  if vim.fn.col '.' == 1 then
    local line = vim.fn.getline '.'
    if line:match '^%s*$' then
      vim.api.nvim_feedkeys('dd', 'n', false)
      vim.api.nvim_feedkeys('$', 'n', false)
    else
      vim.api.nvim_feedkeys('"_x', 'n', false)
    end
  else
    vim.api.nvim_feedkeys('"_x', 'n', false)
  end
end)

map('n', '<A-->', ':vertical resize -10<cr>')
map('n', '<A-=>', ':vertical resize +10<cr>')

map('n', '<A-J>', ':m .+1<cr>==')
map('v', '<A-J>', ':m \'>+1<cr>gv=gv')
map('v', '<A-K>', ':m \'<-2<cr>gv=gv')
map('n', '<A-K>', ':m .-2<cr>==')

map('i', 'jk', '<esc>')
map('i', 'kj', '<esc>')
map('i', 'Kj', '<esc>')
map('i', 'kJ', '<esc>')

map('i', '<C-l>', '<Right><c-h>')
map('i', '<C-d>', '<Right>')

map('n', '<esc>', ':nohl<cr>')

map('n', 'Y', 'y$')

map('n', 'J', 'Jzz')

map('n', ',,', '^')
map('n', ',s', ':split<cr>')
map('n', ',v', ':vsplit<cr>')
map('n', ',x', ':q<cr>')

map('n', 'Q', 'q')

for char in string.gmatch('w\'"`p<({[', '.') do
  for command in string.gmatch('ydvc', '.') do
    map('n', command .. char, command .. 'i' .. char)
  end
end

-- utils
map('n', '<leader>ut', function()
  vim.cmd '%s/\\s\\+$//'
end)
map('n', '<leader>uus', function() -- upper sql
  vim.cmd '%s/.*/\\=v:lua.upperSql(submatch(0))'
  vim.cmd 'nohl'
end)

local is_root = true
local root_path = get_current_path()

map('n', '<leader>ur', function()
  if is_root then
    local path = get_current_path()
    vim.cmd('lcd ' .. path)
    vim.notify 'cwd changed to current place'
    is_root = false
  else
    vim.cmd('lcd ' .. root_path)
    vim.notify 'cwd changed to root'
    is_root = true
  end
end)

-- marks
for letter in string.gmatch('abcdefghijkloqrstuvwxyz', '.') do
  map('n', 'm' .. letter, 'm' .. letter:upper())
  map('n', '\'' .. letter, '\'' .. letter:upper())
end

map('n', '<leader>lw', function()
  local ft = vim.bo.filetype

  local var = vim.fn.expand '<cword>'
  local row = get_row_col()

  local new_line
  if ft == 'typescript' or ft == 'javascript' then
    new_line = 'console.dir({ ' .. var .. ' }, { depth: 9 })'
  elseif ft == 'rust' then
    new_line = 'println!("\\x1b[36m' .. var .. ': {:?}\\x1b[0m", ' .. var .. ');'
  end

  vim.api.nvim_buf_set_lines(0, row, row, true, { new_line })
  vim.cmd.normal 'j=='
end)

-- map('n', '<leader>ld', function()
--   local ft = vim.bo.filetype
--   print(ft)
--
--   if ft == 'typescript' or ft == 'javascript' then
--     -- todo
--   end
-- end)
