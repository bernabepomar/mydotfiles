local ok, ls = pcall(require, "luasnip")
if not ok then return end

local map = vim.keymap.set

map({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    local success, err = pcall(ls.expand_or_jump)
    if not success then
      vim.notify("LuaSnip error: " .. err, vim.log.levels.ERROR)
    end
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
  end
end, { silent = true })

