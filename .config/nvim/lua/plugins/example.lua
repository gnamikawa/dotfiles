-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore

-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore ans setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  { "jesseduffield/lazygit" },
  { "chentoast/marks.nvim" },
  { "kevinhwang91/promise-async" },
  { "nvim-lua/plenary.nvim" },
  { "echasnovski/mini.pairs",                         enabled = false },

  {
    "sindrets/diffview.nvim",
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open side-by-side diff" } }
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim"
    }
  },
  {
    "lambdalisue/suda.vim",
    init = function()
      vim.g.suda_smart_edit = 1
    end
  },
  {
    "Mofiqul/vscode.nvim",
    config = function()
      require('vscode').load('dark')
    end
  },
  {
    "kevinhwang91/nvim-ufo",
    requires = {
      "kevinhwang91/promise-async"
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
      local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require('lspconfig')[ls].setup({
          capabilities = capabilities
          -- you can add other fields for setting up lsp server in this table
        })
      end
      require('ufo').setup()

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = true,
      servers = { eslint = {} },
      setup = {
        eslint = function()
          require("lazyvim.util").on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
  {
    "rbong/vim-flog"
  },
  {
    "tpope/vim-fugitive"
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "prettierd")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.formatting.prettierd)
    end,
  },
  {
    "fedepujol/move.nvim",
    keys = {
      { "<A-left>",   "<cmd>MoveHChar(-1)<CR>", desc = "Move char area left",    noremap = true },
      { "<A-down>",   "<cmd>MoveLine(1)<CR>",   desc = "Move line area up",      noremap = true },
      { "<A-up>",     "<cmd>MoveLine(-1)<CR>",  desc = "Move line area down",    noremap = true },
      { "<A-right>",  "<cmd>MoveHChar(1)<CR>",  desc = "Move char area right",   noremap = true },
      { "<leader>wf", "<cmd>MoveWord(1)<CR>",   desc = "Move word forward",      noremap = true },
      { "<leader>wb", "<cmd>MoveWord(-1)<CR>",  desc = "Move word backward",     noremap = true },
      { "<A-left>",   ":MoveHBlock(-1)<CR>",    desc = "Move visual area left",  mode = "v",    noremap = true },
      { "<A-down>",   ":MoveBlock(1)<CR>",      desc = "Move visual area down",  mode = "v",    noremap = true },
      { "<A-up>",     ":MoveBlock(-1)<CR>",     desc = "Move visual area up",    mode = "v",    noremap = true },
      { "<A-right>",  ":MoveHBlock(1)<CR>",     desc = "Move visual area right", mode = "v",    noremap = true },
    }
  },
  {
    "lewis6991/gitsigns.nvim",
    config = {
      numhl = true,
      word_diff = true
    },
    keys = {
      { "<leader>gw", ":Gitsigns toggle_word_diff<CR>", desc = "Toggle inline word diff", mode = "n", noremap = true },
      { "<leader>gl", ":Gitsigns toggle_linehl<CR>",    desc = "Toggle inline line diff", mode = "n", noremap = true },
    },
    {
      "olrtg/emmet-language-server",
      config = function()
        vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = "astro,css,eruby,html,htmldjango,javascriptreact,less,pug,sass,scss,svelte,typescriptreact,vue",
          callback = function()
            vim.lsp.start({
              cmd = { "emmet-language-server", "--stdio" },
              root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
              init_options = {
                --- @type table<string, any> https://docs.emmet.io/customization/preferences/
                preferences = {},
                --- @type "always" | "never" defaults to `"always"`
                showexpandedabbreviation = "always",
                --- @type boolean defaults to `true`
                showabbreviationsuggestions = true,
                --- @type boolean defaults to `false`
                showsuggestionsassnippets = false,
                --- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
                syntaxprofiles = {},
                --- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
                variables = {},
                --- @type string[]
                excludelanguages = {},
              },
            })
          end,
        })
      end,
    }
  },
  {
    "ribelo/taskwarrior.nvim",
    keys = {
      {
        "<leader>t",
        desc = "Taskwarrior",
      },
      {
        "<leader>tt",
        function()
          require("taskwarrior_nvim").browser({ "ready" })
        end,
        desc = "Ongoing tasks",
        mode = "n",
        noremap = true
      }
    }
  },
  {
    "xarthurx/taskwarrior.vim"
  }
}
