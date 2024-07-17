return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.keymap.set("n", "<leader>Du", "<Cmd>DBUIToggle<Cr>", { desc = "Toggle UI" })
      vim.keymap.set("n", "<leader>Df", "<Cmd>DBUIFindBuffer<Cr>", { desc = "Find buffer" })
      vim.keymap.set("n", "<leader>Dr", "<Cmd>DBUIRenameBuffer<Cr>", { desc = "Rename buffer" })
      vim.keymap.set("n", "<leader>Dq", "<Cmd>DBUILastQueryInfo<Cr>", { desc = "Last query info" })
    end,
  },
}
