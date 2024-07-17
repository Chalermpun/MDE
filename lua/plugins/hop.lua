return {
  {
    "phaazon/hop.nvim",
    dependencies = {
      "ziontee113/syntax-tree-surfer",
      "mfussenegger/nvim-treehopper",
    },
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
      local hop = require("hop")
      vim.keymap.set({ "n", "v" }, "f", function()
        hop.hint_char1({ current_line_only = true })
      end, { remap = true, desc = "Move to Charecter in Current Line" })

      vim.keymap.set({ "n", "v" }, "t", function()
        hop.hint_words({ current_line_only = false })
      end, { remap = true, desc = "Move to Charecter in Other Line" })
    end,
  },
}
