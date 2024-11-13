-- LSP Configuration must be included after lazy plugin manager

local lsp_zero = require("lsp-zero")

local lsp_attach = function(client, bufnr)
	local opts = { buffer = bufnr }

	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
	vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
	vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
	vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
	vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
end

lsp_zero.extend_lspconfig({
	sign_text = true,
	lsp_attach = lsp_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

local servers = {
	clangd = {
		filetypes = { "c", "cpp" },
	},
	-- pyright = {
	-- 	settings = {
	-- 		python = {
	-- 			analysis = {
	-- 				autoSearchPaths = true,
	-- 				diagnosticMode = "openFilesOnly",
	-- 				useLibraryCodeForTypes = true,
	-- 			},
	-- 		},
	-- 	},
	-- },
	pylsp = {},
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
	dockerls = {},
	docker_compose_language_service = {},
	gopls = {},
}

-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu.
require("mason").setup()

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	"stylua", -- Used to format Lua code
	"black",
	"clang-format",
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
require("mason-lspconfig").setup({
	-- ensure_installed = ensure_installed,
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}
			require("lspconfig")[server_name].setup(server)
		end,
	},
})

local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "path" },
	},
	snippet = {
		expand = function(args)
			-- vim.snippet.expand(args.body)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		-- Select the [n]ext item
		["<C-n>"] = cmp.mapping.select_next_item(),
		-- Select the [p]revious item
		["<C-p>"] = cmp.mapping.select_prev_item(),

		-- Scroll the documentation window [b]ack / [f]orward
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),

		-- Accept ([y]es) the completion.
		--  This will auto-import if your LSP supports it.
		--  This will expand snippets if the LSP sent a snippet.
		["<C-y>"] = cmp.mapping.confirm({ select = true }),

		-- If you prefer more traditional completion keymaps,
		-- you can uncomment the following lines
		--['<CR>'] = cmp.mapping.confirm { select = true },
		--['<Tab>'] = cmp.mapping.select_next_item(),
		--['<S-Tab>'] = cmp.mapping.select_prev_item(),

		-- Manually trigger a completion from nvim-cmp.
		--  Generally you don't need this, because nvim-cmp will display
		--  completions whenever it has completion options available.
		["<C-Space>"] = cmp.mapping.complete({}),
	}),
})
