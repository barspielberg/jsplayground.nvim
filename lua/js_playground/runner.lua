local utils = require("js_playground.utils")
local marks = require("js_playground.marks")
local api = vim.api
local groupId = api.nvim_create_augroup("jsPlayground", { clear = true })

---@class Runner
---@field console Console
---@field autocmd_id number|nil
local Runner = {}
Runner.__index = Runner

---@param console Console
function Runner.new(console)
	return setmetatable({
		console = console,
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
			marks.set_mark(buf, line, { message, prop })
			table.insert(messages, message)
		else
			table.insert(messages, output[i])
		end
	end
	self.console:write(messages)
end

---@param command table<string>
---@param cwd string
function Runner:attach(command, cwd)
	---@param run_data {buf: number}
	local function run(run_data)
		self.console:init()
		marks.clear(run_data.buf)

		local function callback(_, output, _)
			self:on_std(output, run_data.buf)
		end

		vim.fn.jobstart(command, {
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
	run({ buf = api.nvim_win_get_buf(0) })
end

function Runner:detach()
	if self.autocmd_id then
		api.nvim_del_autocmd(self.autocmd_id)
	end
	self.console:close()
	marks.clear(api.nvim_win_get_buf(0))
end

return Runner

-- TODO: I might want to nvim_buf_del_mark if start edit line
