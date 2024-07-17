return {
  {
    "petertriho/nvim-scrollbar",
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "folke/tokyonight.nvim",
    },
    opts = {
      excluded_filetypes = {
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "neo-tree",
        "alpha",
      },
    },
    config = function(_, opts)
      require("hlslens").setup()
      require("scrollbar").setup(opts)
      vim.keymap.set("n", "<leader>rt", "<cmd>ScrollbarToggle<cr>", { desc = "ScrollbarToggle" })
    end,
  },
}
