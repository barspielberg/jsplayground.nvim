--- @class PlaygrondConfig
local M = {}

--- @class PlaygrondOptions
M.options = {}

M.ns = vim.api.nvim_create_namespace("jsPlayground")

--- @class PlaygrondOptions
local defaults = {
	file_name = "playground.js",
	-- cmd = { "node", "-r", "ts-node/register/transpile-only", "-r", "tsconfig-paths/register" },
	cmd = { "node" },
	console = {
		screenRatio = 0.25,
	},
	marks = {
		inline_prefix = "» ",
	},
}

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
