return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      triggersblacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
        V = { "j", "k" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      vim.keymap.set({ "n", "v", "" }, "<C-d>", "<C-d>zz", { silent = true, noremap = true })
      vim.keymap.set({ "n", "v", "" }, "<C-u>", "<C-u>zz", { silent = true, noremap = true })
    end,
  },
}
