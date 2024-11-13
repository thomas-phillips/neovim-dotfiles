return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	-- "gc" to comment visual regions/lines

	{ "numToStr/Comment.nvim", opts = {} },

	require("plugins/neo-tree"),
	require("plugins/telescope"),
	require("plugins/which-key"),
	require("plugins/catppucian-mocha"),
	require("plugins/vim-tmux-navigator"),
	require("plugins/autopairs"),
	require("plugins/lsp-zero"),
	require("plugins/conform"),
	require("plugins/gitsigns"),
	require("plugins/lualine"),
}
