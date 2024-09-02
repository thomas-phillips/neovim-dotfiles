return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    init = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          treesitter = true,
          mini = {
            enabled = true,
          },
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}

