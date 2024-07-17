local function toggle_miniindentscope()
  if vim.b.miniindentscope_disable then
    vim.b.miniindentscope_disable = false
    print("miniindentscope enabled")
  else
    vim.b.miniindentscope_disable = true
    print("miniindentscope disabled")
  end
end
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "oil",
        },
      },
    },
    main = "ibl",
  },

  {
    "echasnovski/mini.indentscope",
    version = false,
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      vim.keymap.set("n", "<leader>it", "<cmd>IBLToggle<cr>", { desc = "Indent Blankline Toggle" })
      vim.keymap.set("n", "<leader>mi", toggle_miniindentscope, { desc = "Toggle MiniIndent Scope" })
    end,
  },
}
