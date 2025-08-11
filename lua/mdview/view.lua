local svc = require("mdview.server")
local M = {}
M.win_id = nil
M.buf_id = nil
M.term_job = nil
M.auto_browser_opened = false
M.update_autocmd = nil

local function open_browser(port)
	-- macOS: open, Linux: xdg-open
	local open_cmd = vim.fn.executable("open") == 1 and "open" or "xdg-open"
	vim.fn.jobstart({ open_cmd, string.format("http://127.0.0.1:%d", port) }, { detach = true })
	M.auto_browser_opened = true
end

function M.open(port)
	if M.win_id then
		return
	end
	M.buf_id = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	M.win_id = vim.api.nvim_open_win(M.buf_id, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	-- start terminal with w3m
	M.term_job = vim.fn.termopen({ "w3m", string.format("http://127.0.0.1:%d", port) })

	-- keymaps in terminal-mode buffer
	vim.api.nvim_buf_set_keymap(
		M.buf_id,
		"t",
		"q",
		[[<C-\><C-n>:lua require('mdview.view').close()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		M.buf_id,
		"t",
		"o",
		string.format([[<C-\><C-n>:lua require('mdview.view').open_browser(%d)<CR>i]], port),
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		M.buf_id,
		"t",
		"t",
		[[<C-\><C-n>:lua require('mdview.view').toggle_theme()<CR>i]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		M.buf_id,
		"t",
		"y",
		[[<C-\><C-n>:lua require('mdview.view').yank_html()<CR>i]],
		{ noremap = true, silent = true }
	)

	-- auto open browser for full features (scroll sync) once when view opened
	vim.defer_fn(function()
		open_browser(port)
	end, 250)

	-- set autocmd to send Neovim scroll / cursor events to server
	if M.update_autocmd == nil then
		M.update_autocmd = vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinScrolled" }, {
			pattern = "*",
			callback = function()
				-- compute percent scrolled in current buffer
				local buf = vim.api.nvim_get_current_buf()
				if vim.api.nvim_buf_get_name(buf) ~= vim.fn.expand("%:p") then
					-- not markdown file currently editing
					-- but here we want only when editing the markdown file
					return
				end
				-- compute percent: use window view
				local first_line = vim.fn.line("w0")
				local total_lines = vim.fn.line("$")
				local percent = 0
				if total_lines > 1 then
					percent = (first_line - 1) / (total_lines - 1)
				end
				svc.send_update({ type = "scrollTo", percent = percent })
			end,
		})
	end

	-- start timer to poll server for browser events (scroll from browser)
	if not M._poll_timer then
		M._poll_timer = vim.loop.new_timer()
		M._poll_timer:start(
			250,
			250,
			vim.schedule_wrap(function()
				local ev = svc.consume_browser_event()
				if type(ev) == "table" and ev.type == "scroll" then
					-- map browser percent to line and jump there
					local total = vim.fn.line("$")
					local target = math.max(1, math.floor(ev.percent * total))
					local w = vim.api.nvim_get_current_win()
					vim.api.nvim_win_set_cursor(w, { target, 0 })
				end
			end)
		)
	end
end

function M.open_browser(port)
	open_browser(port)
end

function M.toggle_theme()
	svc.send_update({ type = "toggleTheme" })
end

function M.yank_html()
	local url = string.format("http://127.0.0.1:%d/raw", svc.port)
	local html = vim.fn.systemlist({ "curl", "-s", url })
	if #html == 0 then
		return
	end
	local text = table.concat(html, "\n")
	vim.fn.setreg("+", text) -- yank to system clipboard
	print("HTML yanked to + register")
end

function M.close()
	if M.win_id and vim.api.nvim_win_is_valid(M.win_id) then
		vim.api.nvim_win_close(M.win_id, true)
		M.win_id = nil
	end
	if M._poll_timer then
		M._poll_timer:stop()
		M._poll_timer:close()
		M._poll_timer = nil
	end
	-- remove autocmd if exists
	if M.update_autocmd then
		pcall(vim.api.nvim_del_autocmd, M.update_autocmd)
		M.update_autocmd = nil
	end
end

return M
