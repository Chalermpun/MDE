return {
  "christoomey/vim-tmux-navigator",
  -- a calendar application for vim
  { "itchyny/calendar.vim", cmd = { "Calendar" } },

  -- dims inactive portions of the code you're editing.
  { "folke/twilight.nvim",  opts = {},           cmd = { "Twilight", "TwilightEnable", "TwilightDisable" } },

  -- 🧘 zen mode
  {
    "folke/zen-mode.nvim",
    opts = { plugins = { tmux = { enabled = true } } },
    cmd = { "ZenMode" },
  },

  -- A high-performance color highlighter for Neovim
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      vim.o.termguicolors = true
      require("colorizer").setup()
    end,
  },
  {
    "eandrju/cellular-automaton.nvim",
    event = "VeryLazy",
    lazy = true,
  },

  {
    "tamton-aquib/zone.nvim",
    event = "VeryLazy",
  },
}
