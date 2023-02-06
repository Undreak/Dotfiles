--[[ keys.lua ]]

-- Functional wrapper for mapping custom keybindings
-- mode (as in Vim modes like Normal/Insert mode)
-- lhs (the custom keybinds you need)
-- rhs (the commands or existing keybinds to customise)
-- opts (additional options like <silent>/<noremap>, see :h map-arguments for more info on it)
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- <leader> key is '\' key
-- FloaTerm configuration
map('n', "<leader>t", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ")
map('n', "t", ":FloatermToggle myfloat<CR>")
map('t', "<Esc>", "<C-\\><C-n>:q<CR>")

map('n', "<F5>", ":!cargo run<CR>")

map('n', "<F6>", ":lua require('dapui').open()<CR>")
map('n', "<F7>", ":lua require('dapui').close()<CR>")
map('n', "<F8>", ":lua require('dapui').toggle()<CR>")

vim.keymap.set('n', '<F9>', function() require('dap').continue() end)
vim.keymap.set('n', '<leader>s', function() require('dap').terminate() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
local widgets = require('dap.ui.widgets')
widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
local widgets = require('dap.ui.widgets')
widgets.centered_float(widgets.scopes)
end)


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

map('n', "<F3>", ":NvimTreeToggle<CR>")
map('n', "<F4>", ":NvimTreeCollapse<CR>")
