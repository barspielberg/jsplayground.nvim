local utils = require("js_playground.utils")
local api = vim.api

---@class Console
---@field percentage number
---@field buf integer | nil
---@field win integer | nil
local Console = {}
Console.__index = Console

---@param percentage number
function Console.new(percentage)
	return setmetatable({
		percentage = percentage,
	}, Console)
end

function Console:open()
	self.buf = utils.create_empty_buffer()

	api.nvim_buf_attach(self.buf, false, {
		on_detach = function()
			self.buf = nil
			self.win = nil
		end,
	})

	api.nvim_command("split")
	local win = api.nvim_get_current_win()
	self.win = win

	api.nvim_win_set_buf(win, self.buf)
	api.nvim_win_set_height(win, math.ceil(api.nvim_get_option("lines") * self.percentage))
	api.nvim_win_set_option(win, "number", false)
	api.nvim_win_set_option(win, "relativenumber", false)

	--back to the original window
	api.nvim_command("wincmd p") -- HACK: this command causes the cursor to jump
end

function Console:close()
	api.nvim_win_close(self.win, true)
end

function Console:init()
	if not self.buf then
		self:open()
	end
	api.nvim_buf_set_lines(self.buf, 0, -1, false, { "Running..." })
end

---@param data string[]
function Console:write(data)
	api.nvim_buf_set_lines(self.buf, -1, -1, false, data)
end

return Console
