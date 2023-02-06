require('impatient')
-- IMPORTS
require('opts') -- Options
require('keys') -- Keymaps
require('plug') -- Plugins
vim.wo.number = true
require("mason").setup()
vim.cmd("set clipboard+=unnamedplus")
-- Color theme
require('kanagawa').setup({
	transparent = true,
})
vim.cmd("colorscheme kanagawa")

local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}

local dap = require('dap')
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}

-- If you want to use this for Rust and C, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require'lspconfig'.clangd.setup{}

-- Python debug and LSP config
local dap = require('dap')
dap.adapters.python = {
  type = 'executable';
  command = '/home/alexandre/.virtualenvs/debugpy/bin/python';
  args = { '-m', 'debugpy.adapter' };
}


local dap = require('dap')
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end;
  },
}
require'lspconfig'.pyright.setup{}


-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

require('rust-tools').setup(opts)

require("dapui").setup()

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
--vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- Todo Comments Setup
require('todo-comments').setup {
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE", -- The gui style to use for the fg highlight group.
    bg = "BOLD", -- The gui style to use for the bg highlight group.
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    multiline = true, -- enable multine todo comments
    multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of highlight groups or use the hex color if hl not found as a fallback
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
    test = { "Identifier", "#FF00FF" }
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
} 
-- TODO: this is a todo;
-- FIXME: ;
-- ERROR: ;
-- WARNING: ;
-- WARN: ;
-- HACK: ;
-- INFO: ;
-- HINT: ;
-- NOTE: ;
--

local neogit = require('neogit')

neogit.setup {}

local status_ok, galaxyline = pcall(require, 'galaxyline')
if not status_ok then
  return
end

local colors = require('kanagawa.colors').setup {
	fg = oldWhite,
	bg = sumInk0
}
local condition = require('galaxyline.condition')
local gls = galaxyline.section
galaxyline.short_line_list = { 'NvimTree', 'vista', 'dbui', 'packer', 'lspsagaoutline' }

gls.left[1] = {
  RainbowRed = {
    provider = function()
      return '▊ '
    end,
    highlight = { colors.crystalBue, colors.bg },
  },
}

gls.left[2] = {
  ViMode = {
    provider = function()
      return '  '
    end,
    highlight = { colors.samuraiRed, colors.bg },
  },
}

gls.left[3] = {
  FileSize = {
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg },
    provider = 'FileSize',
  },
}

gls.left[4] = {
  FileIcon = {
    condition = condition.buffer_not_empty,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.bg },
    provider = 'FileIcon',
  },
}

gls.left[5] = {
  FileName = {
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg, 'bold' },
    provider = 'FileName',
  },
}

gls.left[6] = {
  LineInfo = {
    highlight = { colors.fg, colors.bg },
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.left[7] = {
  PerCent = {
    highlight = { colors.fg, colors.bg, 'bold' },
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.left[8] = {
  DiagnosticError = {
    highlight = { colors.samuraiRed, colors.bg },
    icon = '  ',
    provider = 'DiagnosticError',
  },
}

gls.left[9] = {
  DiagnosticWarn = {
    highlight = { colors.roninYellow, colors.bg },
    icon = '  ',
    provider = 'DiagnosticWarn',
  },
}

gls.left[10] = {
  DiagnosticHint = {
    highlight = { colors.dragonBlue, colors.bg },
    icon = '  ',
    provider = 'DiagnosticHint',
  },
}

gls.left[11] = {
  DiagnosticInfo = {
    highlight = { colors.waveAqua1, colors.bg },
    icon = '  ',
    provider = 'DiagnosticInfo',
  },
}

gls.left[12] = {
  ShowLspClient = {
    condition = function()
      local tbl = { ['dashboard'] = true, [''] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
    highlight = { colors.carpYellow, colors.bg, 'bold' },
    icon = ' LSP:',
    provider = 'GetLspClient',
  },
}

gls.right[1] = {
  FileEncode = {
    condition = condition.hide_in_width,
    highlight = { colors.springGreen, colors.bg, 'bold' },
    provider = 'FileEncode',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[2] = {
  FileFormat = {
    condition = condition.hide_in_width,
    highlight = { colors.springGreen, colors.bg, 'bold' },
    provider = 'FileFormat',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[3] = {
  GitIcon = {
    provider = function()
      return '  '
    end,
    condition = condition.check_git_workspace,
    highlight = { colors.springViolet1, colors.bg, 'bold' },
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[4] = {
  GitBranch = {
    condition = condition.check_git_workspace,
    highlight = { colors.springViolet1, colors.bg, 'bold' },
    provider = 'GitBranch',
  },
}

gls.right[5] = {
  Separator = {
    highlight = { colors.fg, colors.bg, 'bold' },
    provider = function()
      return ' '
    end,
  },
}

gls.right[6] = {
  DiffAdd = {
    condition = condition.hide_in_width,
    highlight = { colors.autumnGreen, colors.bg },
    icon = '  ',
    provider = 'DiffAdd',
  },
}

gls.right[7] = {
  DiffModified = {
    condition = condition.hide_in_width,
    highlight = { colors.autumnYellow, colors.bg },
    icon = ' 柳',
    provider = 'DiffModified',
  },
}

gls.right[8] = {
  DiffRemove = {
    condition = condition.hide_in_width,
    highlight = { colors.autumnRed, colors.bg },
    icon = '  ',
    provider = 'DiffRemove',
  },
}

gls.right[9] = {
  RainbowBlue = {
    provider = function()
      return ' ▊'
    end,
    highlight = { colors.waveAqua1, colors.bg },
  },
}

gls.short_line_left[1] = {
  BufferType = {
    highlight = { colors.springBlue, colors.bg, 'bold' },
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.short_line_left[2] = {
  SFileName = {
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg, 'bold' },
    provider = 'SFileName',
  },
}

gls.short_line_right[1] = {
  BufferIcon = {
    highlight = { colors.fg, colors.bg },
    provider = 'BufferIcon',
  },
}
