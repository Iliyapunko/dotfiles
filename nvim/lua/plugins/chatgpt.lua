local M = {}

M.key = os.getenv 'CHATGPT_API_KEY'

M.set_mappings = function()
  local chat = require 'chatgpt'

  map('n', '<leader>ac', function()
    vim.cmd 'ChatGPT'
  end)

  map('v', '<leader>ac', function()
    chat.run_action {
      fargs = { 'complete_code' },
    }
  end)

  map('v', '<leader>ao', function()
    chat.run_action {
      fargs = { 'optimize_code' },
    }
  end)
end

return {
  {
    'jackmort/chatgpt.nvim',
    enabled = false,
    config = function()
      local chat = require 'chatgpt'

      M.set_mappings()

      chat.setup {
        api_key_cmd = 'echo ' .. M.key,

        popup_window = {
          win_options = {
            foldcolumn = '0',
          },
        },

        chat = {
          loading_text = '',
        },

        popup_layout = {
          center = {
            width = '60%',
            height = '90%',
          },
        },

        system_window = {
          win_options = {
            foldcolumn = '0',
          },
        },

        openai_params = {
          model = 'gpt-3.5-turbo',
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 2000,
          temperature = 0,
          top_p = 1,
          n = 1,
        },

        openai_edit_params = {
          model = 'code-davinci-edit-001',
          temperature = 0,
          top_p = 1,
          n = 1,
        },
      }
    end,
  },
}
