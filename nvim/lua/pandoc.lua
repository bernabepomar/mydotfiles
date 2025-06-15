local M = {}

-- Maps file types to extensions
local output_formats = {
  pdf = "pdf",
  docx = "docx",
  latex = "tex",
  markdown = "md",
  html = "html",
}

-- Main function to run pandoc
function M.convert(fmt)
  local ext = output_formats[fmt]
  if not ext then
    vim.notify("Unsupported format: " .. fmt, vim.log.levels.ERROR)
    return
  end

  local input_file = vim.api.nvim_buf_get_name(0)
  if input_file == "" then
    vim.notify("Buffer is not associated with a file.", vim.log.levels.ERROR)
    return
  end

  local input_ext = vim.fn.fnamemodify(input_file, ":e")
  local input_basename = vim.fn.fnamemodify(input_file, ":r")
  local output_file = input_basename .. "." .. ext

  local cmd = string.format("pandoc %s -o %s", vim.fn.shellescape(input_file), vim.fn.shellescape(output_file))

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            vim.notify(line)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            vim.notify("Error: " .. line, vim.log.levels.ERROR)
          end
        end
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Pandoc: File converted to " .. fmt .. " → " .. output_file)
      else
        vim.notify("Pandoc conversion failed", vim.log.levels.ERROR)
      end
    end,
  })
end

-- Setup command
function M.setup()
  vim.api.nvim_create_user_command("PandocConvert", function(args)
    M.convert(args.args)
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(output_formats)
    end,
  })
end

return M

