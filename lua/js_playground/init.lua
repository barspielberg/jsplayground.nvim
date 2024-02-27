local utils = require("js_playground.utils")
local Runner = require("js_playground.runner")
local Console = require("js_playground.console")

local opts = {
	percentage = 0.25,
	-- cmd = { "node", "-r", "ts-node/register/transpile-only", "-r", "tsconfig-paths/register" },
	cmd = { "node" },
}

---@type Runner | nil
local runner = nil
--TODO:support multiple runners

local function stop()
	if runner then
		runner:detach()
		runner = nil
	end
end

local function listen_cur_buf()
	--close runner on buf close
	vim.api.nvim_command("autocmd BufDelete <buffer> lua require('js_playground').stop()")

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
