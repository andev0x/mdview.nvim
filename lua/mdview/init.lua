local M = {}
local svc = require("mdview.server")
local view = require("mdview.view")

function M.setup()

	vim.api.nvim_create_user_command("MDView", function()
		local file = vim.fn.expand("%:p")
		if vim.fn.filereadable(file) == 0 then
			print("No markdown file to preview")
			return
		end
		svc.start(file)
		-- small delay then open view
		vim.defer_fn(function()
			view.open(svc.port)
		end, 300)
	end, {})

	vim.api.nvim_create_user_command("MDStop", function()
		view.close()
		svc.stop()
	end, {})
end

return M
