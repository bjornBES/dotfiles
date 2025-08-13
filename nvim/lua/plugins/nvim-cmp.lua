local kind_icons = {
  Text = "",
  Method = "m",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
  calc = "󰃬"
}

return
{
		{
				"hrsh7th/nvim-cmp",
				event = "InsertEnter",
				dependencies = {
						"hrsh7th/cmp-nvim-lsp",
						"hrsh7th/cmp-buffer",
						"hrsh7th/cmp-path",
						"hrsh7th/cmp-cmdline",
						"hrsh7th/cmp-calc",
						"L3MON4D3/LuaSnip",
						"saadparwaiz1/cmp_luasnip",
						"onsails/lspkind.nvim"
				},
				config = function()
						require("luasnip/loaders/from_vscode").lazy_load()

						local cmp = require("cmp")
						local luasnip = require("luasnip")

						cmp.setup
						{
								auto_brackets = {},
								snippet = {
										expand = function(args)
												luasnip.lsp_expand(args.body)
										end,
								},
								mapping = {

										["<C-k>"] = cmp.mapping.select_prev_item(),
										["<C-j>"] = cmp.mapping.select_next_item(),
										["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
										["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
										["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
										["<C-e>"] = cmp.mapping {
												i = cmp.mapping.abort(),
												c = cmp.mapping.close(),
										},
										-- Accept currently selected item. If none selected, `select` first item.
										-- Set `select` to `false` to only confirm explicitly selected items.
										["<CR>"] = cmp.mapping.confirm { select = true },
										["<Tab>"] = cmp.mapping(function(fallback)
												if cmp.visible() then
														cmp.select_next_item()
												elseif luasnip.expandable() then
														luasnip.expand()
												elseif luasnip.expand_or_jumpable() then
														luasnip.expand_or_jump()
												else
														fallback()
												end
										end, {
										"i",
										"s",
										}),
								},
								formatting = {
										fields = { "kind", "abbr", "menu" },
										format = function(entry, vim_item)
												local lspkind_ok, lspkind = pcall(require, "lspkind")
												if not lspkind_ok then
														-- Kind icons
														vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
														-- Source
														vim_item.menu = ({
																buffer = "[Buffer]",
																nvim_lsp = "[LSP]",
																luasnip = "[LuaSnip]",
																nvim_lua = "[Lua]",
																latex_symbols = "[LaTeX]",
														})[entry.source.name]
														return vim_item
												else
														return lspkind.cmp_format()(entry, vim_item)
												end										
										end
--										format = require("lspkind").cmp_format {
--												mode = "symbol_text",
--												menu = {
--														nvim_lsp = "[LSP]",
--														buffer = "[Buffer]",
--														luasnip = "[LuaSnip]",
--												}
--										}
								},
								sources = cmp.config.sources({
										{ name = "luasnip" },
										{ name = "nvim_lua" },
										{ name = "path" },
										{ name = "buffer" },
										{ name = "calc" },
								}),
						}
				end,
		},
}
