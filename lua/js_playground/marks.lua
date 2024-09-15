local config = require("js_playground.config")

local api = vim.api
local ns = config.ns

local M = {}

---@param win number
M.init = function(win)
	api.nvim_set_hl(ns, "log", { link = "DiagnosticInfo", default = true })
	api.nvim_set_hl(ns, "info", { link = "DiagnosticHint", default = true })
	api.nvim_set_hl(ns, "error", { link = "DiagnosticError", default = true })
	api.nvim_set_hl(ns, "warn", { link = "DiagnosticWarn", default = true })
	api.nvim_set_hl(ns, "debug", { link = "DiagnosticOk", default = true })
	api.nvim_win_set_hl_ns(win, ns)
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
