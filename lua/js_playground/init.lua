local utils = require("js_playground.utils")
local Runner = require("js_playground.runner")
local config = require("js_playground.config")

---@type Runner | nil
local runner = nil
--TODO:support multiple runners?

local function stop()
	if runner then
		runner:detach()
		runner = nil
	end
end

local function listen_cur_buf()
	vim.api.nvim_create_autocmd({ "WinClosed", "BufDelete" }, {
		buffer = 0,
		callback = stop,
	})

	local cur_dir = vim.fn.expand("%:p:h")
	local file_name = vim.fn.expand("%:t")
	local cmd = utils.create_cmd(config.options.cmd, file_name)
	runner = Runner.new()
	runner:attach(cmd, cur_dir)
end

local function toggle()
	if runner then
		stop()
	else
		vim.api.nvim_command("edit " .. config.options.file_name)
		listen_cur_buf()
	end
end

return {
	stop = stop,
	toggle = toggle,
	setup = config.setup,
}
