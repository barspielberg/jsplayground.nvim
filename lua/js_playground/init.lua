local utils = require("js_playground.utils")
local Runner = require("js_playground.runner")
local Console = require("js_playground.console")

local opts = {
	file_name = "playground.js",
	percentage = 0.25,
	-- cmd = { "node", "-r", "ts-node/register/transpile-only", "-r", "tsconfig-paths/register" },
	cmd = { "node" },
}

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
	local cmd = utils.create_cmd(opts.cmd, file_name)
	runner = Runner.new(Console.new(opts.percentage))
	runner:attach(cmd, cur_dir)
end

local function toggle()
	if runner then
		stop()
	else
		vim.api.nvim_command("vnew " .. opts.file_name)
		listen_cur_buf()
	end
end

local function setup(_opts)
	--TODO: merge opts
	-- set_mappings()
end

return {
	stop = stop,
	toggle = toggle,
	setup = setup,
}
