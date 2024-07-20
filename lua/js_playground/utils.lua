local api = vim.api
local M = {}

M.create_empty_buffer = function()
	local buf = api.nvim_create_buf(false, true) -- create new empty buffer
	api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	api.nvim_set_option_value("swapfile", false, { buf = buf })
	api.nvim_set_option_value("filetype", "nvim-oldfile", { buf = buf })
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

M.get_log_data = function(str)
	return str:match("line:(%d+),prop:(%w+)| (.+)")
end

return M
