return {
  {
    "anuvyklack/hydra.nvim",
    config = function()
      local Hydra = require("hydra")
      Hydra({
        name = "Side scroll",
        mode = "n",
        body = "<leader>o",
        heads = {
          { "h", "1<C-w><" },
          { "l", "1<C-w>>" },
          { "j", "1<C-w>+" },
          { "k", "1<C-w>-" },
        },
      })
    end,
  },
  {
    "https://gitlab.com/yorickpeterse/nvim-window.git",
    config = function()
      require("nvim-window").setup({
        normal_hl = "BlackOnLightYellow",
        hint_hl = "Bold",
        border = "none",
      })
      vim.keymap.set(
        "n",
        "<leader>y",
        ":lua require('nvim-window').pick()<CR>",
        { desc = "Pick windows", remap = true }
      )
    end,
  },
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      require("windows").setup({
        autowidth = {
          enable = false,
          winwidth = 5,
          filetype = {
            help = 2,
          },
        },
        ignore = {
          buftype = { "quickfix" },
          filetype = {
            "diffviewfilepanel",
            "NvimTree",
            "DiffviewFilePanel",
            "neo-tree",
            "undotree",
            "gundo",
          },
        },
      })

      vim.keymap.set("n", "<C-w>|", "<cmd>WindowsMaximize<cr>", { desc = "Window Maximization", remap = true })
      vim.keymap.set("n", "<C-w>z", "<cmd>WindowsMaximize<cr>", { desc = "Window Maximization", remap = true })
      vim.keymap.set("n", "<C-w>=", "<cmd>WindowsEqualize<cr>", { desc = "Window Equalization", remap = true })
    end,
  },
}
