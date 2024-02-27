local utils = require("js_playground.utils")
local Runner = require("js_playground.runner")
local Console = require("js_playground.console")

local opts = {
	percentage = 0.25,
	-- cmd = { "node", "-r", "ts-node/register/transpile-only", "-r", "tsconfig-paths/register" },
	cmd = { "node" },
}

---@type Runner|nil
local runner = nil
--TODO:support multiple runners

local M = {}

M.start = function()
	if runner then
		runner:detach()
		runner = nil
	else
		local cur_dir = vim.fn.expand("%:p:h")
		local file_name = vim.fn.expand("%:t")
		local cmd = utils.create_cmd(opts.cmd, file_name)
		runner = Runner.new(Console.new(opts.percentage))
		runner:attach(cmd, cur_dir)
	end
end

M.setup = function(_opts)
	-- do something
end

return M

--TODO: set_mappings()
