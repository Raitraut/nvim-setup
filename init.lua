-- ==========================================================================
-- 1. БАЗОВЫЕ НАСТРОЙКИ
-- ==========================================================================
vim.g.mapleader = " "

vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "kk", "<Esc>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Сохранить" })

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ==========================================================================
-- КРАСИВЫЕ ОШИБКИ (DIAGNOSTICS)
-- ==========================================================================

-- 1. Настраиваем иконки (чтобы было красиво слева)
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- 2. Настраиваем отображение
vim.diagnostic.config({
  -- Показывать текст ошибки справа от кода
  virtual_text = {
    prefix = '●', -- Кружочек перед текстом ошибки
    spacing = 4,
  },
  -- Показывать значки слева
  signs = true,
  -- Подчеркивать ошибку волнистой линией
  underline = true,
  -- Не обновлять ошибки, пока вы печатаете (чтобы не мелькало)
  update_in_insert = false,
  -- Сортировать: сначала важные ошибки
  severity_sort = true,
})

-- 3. Хоткеи для прыжков по ошибкам
-- [d  -> Предыдущая ошибка
-- ]d  -> Следующая ошибка
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Пред. ошибка" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "След. ошибка" })

-- Показать полный текст ошибки во всплывающем окне, если нажать <Пробел> + d (Error)
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = "Показать текст ошибки" })

-- ==========================================================================
-- 2. МЕНЕДЖЕР ПЛАГИНОВ
-- ==========================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================================================
-- 3. ПЛАГИНЫ
-- ==========================================================================
require("lazy").setup({
-- [ТЕРМИНАЛ]
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]], -- Хоткей для открытия: Ctrl + \
        direction = "float",      -- "float" (плавающее окно), "horizontal" или "vertical"
        float_opts = {
          border = "curved",      -- Закругленная рамка
        },
      })
      
      -- Чтобы в терминале работали обычные хоткеи (выход через jk)
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jj', [[<C-\><C-n>]], opts) -- Выйти в режим выделения текста
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end
  },
-- [GIT - DIFF VIEW (КАК В VS CODE)]
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      -- Пробел + g + d = Git Diff
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Открыть сравнение (Diff)" },
      -- Пробел + g + h = Git History (История текущего файла)
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "История файла" },
      -- Пробел + g + c = Git Close (Закрыть)
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Закрыть сравнение" },
    },
  },
  -- [ТЕМА]
    {
      "folke/tokyonight.nvim",
      priority = 1000,
      config = function()
        require("tokyonight").setup({
          -- Включаем прозрачность
          transparent = true,
          -- Настраиваем стили для разных частей интерфейса
          styles = {
            sidebars = "transparent", -- Прозрачная боковая панель (Neo-tree)
            floats = "transparent",   -- Прозрачные всплывающие окна
          },
        })
        -- Применяем тему
        vim.cmd([[colorscheme tokyonight-night]])
      end,
    },
-- [GIT - FUGITIVE + FLOG]
  {
    "tpope/vim-fugitive",
  },
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
    keys = {
      { "<leader>gl", "<cmd>Flog<cr>", desc = "Git Graph (Log)" }
    }
  },
  -- [ФАЙЛОВЫЙ МЕНЕДЖЕР]
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = { { "<leader>e", ":Neotree toggle<CR>", desc = "Файлы" } },
  },

  -- [ПОИСК - TELESCOPE] (ЛЕЧЕНИЕ ОШИБКИ ft_to_lang)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- ЯВНО ОТКЛЮЧАЕМ TREESITTER В ПРЕВЬЮ
      -- Это устраняет ошибку 'ft_to_lang attempt to call nil value'
      require("telescope").setup({
        defaults = {
          preview = {
            treesitter = false, -- ВАЖНО: Ставим false
          },
        },
      })
      
      -- Хоткеи поиска
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>cr', builtin.lsp_references, {})
    end
  },

  -- [ПОДСВЕТКА - TREESITTER] (БЕЗОПАСНАЯ ЗАГРУЗКА)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "windwp/nvim-ts-autotag" },
    config = function()
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then return end

      configs.setup({
        -- ДОБАВИЛ: python, c, cpp, go
        ensure_installed = { 
          "lua", "javascript", "typescript", "json", "bash", "html", "css",
          "python", "c", "cpp", "go" 
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
      })
    end,
  },
  -- [АВТО-СКОБКИ]
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- [ФОРМАТИРОВАНИЕ]
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" }, typescript = { "prettier" },
        json = { "prettier" }, sql = { "sql_formatter" }, lua = { "stylua" },
      },
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
    },
  },

  -- [LSP]
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets", "onsails/lspkind.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        -- ДОБАВИЛ: pyright, clangd, gopls
        ensure_installed = { 
          "ts_ls", "jsonls", "html", "cssls", "bashls", 
          "pyright", -- Для Python
          "clangd",  -- Для C и C++
          "gopls"    -- Для Go
        },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = require('cmp_nvim_lsp').default_capabilities()
            })
          end,
        }
      })

      -- Остальной код LSP без изменений...
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        end,
      })
      
      -- Настройка CMP (автодополнения)
      local cmp = require('cmp')
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' }, { name = 'buffer' }, { name = 'path' } }),
        formatting = { format = require('lspkind').cmp_format({ mode = 'symbol_text', maxwidth = 50 }) }
      })
    end,
  },
})
