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

	local cur_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)") --HACK: there mast be a better way to get current dir
	local pre_script_path = cur_dir .. "../../js/preScript.js"
	table.insert(cmd, "-r")
	table.insert(cmd, pre_script_path)

	table.insert(cmd, fileName)
	return cmd
end

return M
