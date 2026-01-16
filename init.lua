vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse= "a"
vim.g.have_nerd_font = true
vim.o.showmode = false
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.confirm = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Key Mapping for clearing the highlights after searching
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

--Key Binding for moving around different buffers 
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking txt',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank',{clear = true}),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.g.mapleader = " "
-- lazy vim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git","clone","--filter=blob:none","--branch=stable",lazyrepo,lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            {"Failed to clone lazy.nvim:\n", "ErrorMsg"},
            {out, "WarningMsg"},
            {"\nPress any key to exit..."},
        }, true,{})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        -- color theme setup
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme tokyonight-night")
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons'}
    },
    {
        'nvim-tree/nvim-tree.lua',
        version = "*",
        lazy = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts={
            automatic_enable = true
        },
        dependencies = {
            {"mason-org/mason.nvim",opts = {}},
            "neovim/nvim-lspconfig"
        }
    },
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'default' },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = true} },
        signature = {
            enabled = true
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
        opts = {}
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
    {
        'akinsho/bufferline.nvim', 
        version = "*", 
        dependencies = 'nvim-tree/nvim-web-devicons'
    }

})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "pyright","clangd","ts_ls"},
}

require("bufferline").setup{
    options = {

    diagnostics = "nvim_lsp",
    diagnostics_update_on_event = true,
    hover = {
                enabled = true,
                delay = 200,
                reveal = {'close'}
            }, -- use nvim's diagnostic handler
    }
}
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>l", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>h", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "Pick buffer" })

require("nvim-tree").setup({
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
        custom = {
            "^.git$"
        }
    },
})

-- key binding for file tree
vim.keymap.set("n","<leader>e",":NvimTreeToggle<CR>")
vim.keymap.set("n","<leader>f",":NvimTreeFocus<CR>")

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'ayu_dark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
