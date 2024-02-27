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
	vim.api.nvim_buf_attach(0, false, { on_detach = stop }) --FIXME:
	local cur_dir = vim.fn.expand("%:p:h")
	local file_name = vim.fn.expand("%:t")
	local cmd = utils.create_cmd(opts.cmd, file_name)
	runner = Runner.new(Console.new(opts.percentage))
	runner:attach(cmd, cur_dir)
end

local M = {}

M.toggle = function()
	if runner then
		stop()
	else
		listen_cur_buf()
	end
end

M.setup = function(_opts)
	--TODO: merge opts
	-- set_mappings()
end

return M
