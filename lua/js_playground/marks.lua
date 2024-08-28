local api = vim.api
local M = {}

local ns = api.nvim_create_namespace("js_playground")

-- const override = ['log', 'error', 'warn', 'info', 'debug'];
M.init = function()
	vim.api.nvim_set_hl(ns, "log", { link = "DiagnosticInfo" })
end

---@param buf number
---@param line string
---@param text [string, string]
M.set_mark = function(buf, line, text)
	api.nvim_buf_set_extmark(buf, ns, tonumber(line) - 1, 0, { virt_text = { text } })
end

---@param buf number
M.clear = function(buf)
	api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

return M
