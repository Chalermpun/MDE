return {
  {
    "jbyuki/nabla.nvim",
    keys = { { "<leader>pn", "<cmd>:lua require('nabla').popup()<CR>", desc = "Nabla Popup" } },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
  {
    "AckslD/nvim-FeMaco.lua",
    config = 'require("femaco").setup()',
  },

  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "org", "norg" },
  },

  {
    "mzlogin/vim-markdown-toc",
    ft = { "markdown" },
  },
  {
    "Zeioth/markmap.nvim",
    build = "yarn global add markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    opts = {
      html_output = "/tmp/markmap.html",
      hide_toolbar = false,
      grace_period = 3600000,
    },
    config = function(_, opts)
      require("markmap").setup(opts)
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",

      "nvim-tree/nvim-web-devicons",
    },

    config = function(_, opts)
      require("markview").setup(opts)
      vim.api.nvim_set_keymap('n', '<leader>mt', ':Markview toggle<CR>',
        { noremap = true, silent = true, desc = 'Toggle Markview (Current buffer)' })
    end,
  },
}
