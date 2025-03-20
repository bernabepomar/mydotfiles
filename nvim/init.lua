-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/.config/nvim/LuaSnip/" } })
require("luasnip-latex-snippets")

require("luasnip").config.setup({ enable_autosnippets = true })
