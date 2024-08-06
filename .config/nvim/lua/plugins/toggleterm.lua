return {
  {
    "akinsho/toggleterm.nvim",
    config = {},
    keys = {
      {
        "<leader>gg",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
              border = "rounded",
            },
          })
          lazygit:toggle()
        end,
        "n",
        desc = "Lazygit",
      },
      {
        "<C-\\>",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local genericTerminal = Terminal:new({
            open_mapping = [[<c-\>]],
            dir = "%:p:h",
            direction = "float",
            float_opts = {
              border = "rounded",
            },
            -- function to run on opening the terminal
            on_open = function()
              vim.keymap.set("t", "<esc>", "<cmd>close<cr>")
            end,
          })

          genericTerminal:toggle()
        end,
        "n",
        desc = "Terminal",
      },
    },
  },
}
