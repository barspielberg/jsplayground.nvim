local utils = require("js_playground.utils")
local marks = require("js_playground.marks")
local config = require("js_playground.config")
local Console = require("js_playground.console")

local api = vim.api
local groupId = api.nvim_create_augroup("jsPlayground", { clear = true })

---@class Runner
---@field console Console | nil
---@field autocmd_id number | nil
local Runner = {}
Runner.__index = Runner

function Runner.new()
	return setmetatable({
		console = config.options.console and Console:new() or nil,
	}, Runner)
end

---@param output string[]
---@param buf number
function Runner:on_std(output, buf)
	if not output then
		return
	end
	local messages = {}
	for i = 1, #output, 1 do
		local line, prop, message = utils.get_log_data(output[i])
		if message then
			local marksOpts = config.options.marks
			if marksOpts then
				marks.set_mark(buf, line, { marksOpts.inline_prefix .. message, prop })
			end
			table.insert(messages, message)
		else
			table.insert(messages, output[i])
		end
	end

	if self.console then
		self.console:write(messages)
	end
end

---@param command table<string>
---@param cwd string
function Runner:attach(command, cwd)
	---@param run_data {buf: number}
	local function run(run_data)
		if self.console then
			self.console:init()
		end
		marks.clear(run_data.buf)

		local function callback(_, output, _)
			self:on_std(output, run_data.buf)
		end

		vim.fn.jobstart(command, { -- TODO: cleanup
			cwd = cwd,
			on_stdout = callback,
			on_stderr = callback,
		})
	end

	self.autocmd_id = api.nvim_create_autocmd("BufWritePost", {
		group = groupId,
		pattern = command[#command],
		callback = run,
	})
	marks.init(api.nvim_get_current_win())
end

function Runner:detach()
	if self.autocmd_id then
		api.nvim_del_autocmd(self.autocmd_id)
	end
	if self.console then
		self.console:close()
	end
	marks.clear(api.nvim_win_get_buf(0))
end

return Runner

-- TODO: I might want to nvim_buf_del_mark if start edit line
