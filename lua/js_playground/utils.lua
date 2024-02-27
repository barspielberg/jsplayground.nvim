local api = vim.api
local M = {}

M.create_empty_buffer = function()
	local buf = api.nvim_create_buf(false, true) -- create new empty buffer
	api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	api.nvim_buf_set_option(buf, "buftype", "nofile")
	api.nvim_buf_set_option(buf, "swapfile", false)
	api.nvim_buf_set_option(buf, "filetype", "nvim-oldfile")
	return buf
end

---@param command string[]
---@param fileName string
M.create_cmd = function(command, fileName)
	local cmd = {}
	for i = 1, #command, 1 do
		table.insert(cmd, command[i])
	end
	table.insert(cmd, fileName)
	return cmd
end

return M
