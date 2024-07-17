return {
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      local function header()
        return require("util.alpha.logo")["random"]
      end
      alpha.setup(dashboard.opts)
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. "  New file", ":ene | startinsert <CR>"),
        dashboard.button("r", " " .. "  Recent file", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("s", " " .. "  Restore Session", ':lua require("persistence").load() <CR>'),
        dashboard.button("p", " " .. "  Projects", ":Telescope projects <CR>"),
        dashboard.button("l", "󰒲 " .. "  Lazy", ":Lazy <CR>"),
        dashboard.button("q", " " .. "  Quit", ":qa <CR>"),
      }

      dashboard.opts.layout[1].val = 2
      dashboard.section.header.val = header()

      vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          local version = " v"
              .. vim.version().major
              .. "."
              .. vim.version().minor
              .. "."
              .. vim.version().patch
          local fortune = require("util.alpha.fortune")
          local quote = table.concat(fortune(), "\n")
          local plugins = "󱐌 Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          local footer = "\t" .. version .. "\t" .. plugins .. "\n" .. quote
          dashboard.section.footer.val = footer
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
