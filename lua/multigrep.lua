local M = {}

function M.multigrep()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local make_entry = require 'telescope.make_entry'
  local conf = require('telescope.config').values

  pickers
    .new({}, {
      prompt_title = 'Multi Grep',
      finder = finders.new_async_job {
        command_generator = function(prompt)
          if not prompt or prompt == '' then
            return nil
          end

          local pieces = vim.split(prompt, '  ')
          local args = { 'rg' }
          if pieces[1] then
            table.insert(args, '-e')
            table.insert(args, pieces[1])
          end

          if pieces[2] then
            table.insert(args, '-e')
            table.insert(args, pieces[2])
          end

          return vim.list_extend(args, {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          })
        end,
        entry_maker = make_entry.gen_from_vimgrep({}),
        cwd = vim.fn.getcwd(),
      },
      sorter = require('telescope.sorters').empty(),
      previewer = conf.grep_previewer({}),
    })
    :find()
end

return M