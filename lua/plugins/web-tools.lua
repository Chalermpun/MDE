return {
  {
    "ray-x/web-tools.nvim",
    config = function()
      require("web-tools").setup({
        keymaps = {
          rename = nil,
          repeat_rename = ".",
        },
        hurl = {
          show_headers = false,
          floating = false,
          json5 = false,
          formatters = {
            json = { "jq" },
            html = { "prettier", "--parser", "html" },
          },
        },
      })
    end,
  },
}
