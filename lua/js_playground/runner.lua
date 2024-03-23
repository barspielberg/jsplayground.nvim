local utils = require("js_playground.utils")
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

---@param data string[]
function Runner:on_std(data)
	if not data then
		return
	end
	local messages = {}
	for i = 1, #data, 1 do
		local line, prop, message = utils.get_log_data(data[i])
		if message then
			table.insert(messages, message)
		else
			table.insert(messages, data[i])
		end
	end
	self.console:write(messages)
end

---@param command table<string>
---@param cwd string
function Runner:attach(command, cwd)
	local function run()
		self.console:init()

		local function callback(_, data, _)
			self:on_std(data)
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
	run()
end

function Runner:detach()
	if self.autocmd_id then
		api.nvim_del_autocmd(self.autocmd_id)
	end
	self.console:close()
end

return Runner
