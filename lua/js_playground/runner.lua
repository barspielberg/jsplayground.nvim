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

---@param command table<string>
---@param cwd string
function Runner:attach(command, cwd)
	local function on_std(_, data, _)
		if data then
			self.console:write(data)
		end
	end

	local function run()
		self.console:init()
		vim.fn.jobstart(command, {
			cwd = cwd,
			stdout_buffered = true,
			on_stdout = on_std,
			on_stderr = on_std,
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
