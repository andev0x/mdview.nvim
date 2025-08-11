local M = {}
M.port = 7070
M._job_id = nil
M._file = nil
M._poll_timer = nil
M._last_browser_event = nil

local function node_exec_path()
	return vim.fn.exepath("node")
end

function M.start(filepath, port)
	port = port or M.port
	M._file = filepath
	M.port = port

	if M._job_id then
		print("MD server already running on port " .. M.port)
		return
	end

	local node = node_exec_path()
	if node == "" then
		print("node not found in PATH")
		return
	end

	local script_dir = debug.getinfo(1, "S").source:sub(2):gsub("/lua/mdview/server.lua$", "")
	local server_js = script_dir .. "/server.js"

	local cmd = { node, server_js, filepath, tostring(port) }

	M._job_id = vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		on_stdout = function(_, data, _)
			if data then
				for _, line in ipairs(data) do
					if line and line:match("MDView server running") then
						vim.schedule(function()
							print(line)
						end)
					end
				end
			end
		end,
		on_stderr = function(_, data, _)
			if data then
				for _, line in ipairs(data) do
					if line and line ~= "" then
						vim.schedule(function()
							print("mdview server err: " .. line)
						end)
					end
				end
			end
		end,
	})
	-- start polling timer to fetch browser events
	if M._poll_timer == nil then
		M._poll_timer = vim.loop.new_timer()
		M._poll_timer:start(
			200,
			200,
			vim.schedule_wrap(function()
				-- poll /events
				local url = string.format("http://127.0.0.1:%d/events", M.port)
				local res = vim.fn.systemlist({ "curl", "-s", url }) -- capture single-line or JSON
				if res and #res > 0 then
					local ok, parsed = pcall(vim.fn.json_decode, table.concat(res, "\n"))
					if ok and parsed and parsed.event then
						M._last_browser_event = parsed.event
					end
				end
			end)
		)
	end
end

function M.stop()
	if M._job_id then
		vim.fn.jobstop(M._job_id)
		M._job_id = nil
	end
	if M._poll_timer then
		M._poll_timer:stop()
		M._poll_timer:close()
		M._poll_timer = nil
	end
end

-- send update from Neovim to server (will broadcast to browser via server)
function M.send_update(payload)
	local url = string.format("http://127.0.0.1:%d/update", M.port)
	-- send JSON via curl
	local json = vim.fn.json_encode(payload)
	local cmd = { "curl", "-s", "-X", "POST", "-H", "Content-Type: application/json", "-d", json, url }
	vim.fn.system(cmd)
end

-- poll last browser event (if any) and clear it locally
function M.consume_browser_event()
	local e = M._last_browser_event
	M._last_browser_event = nil
	return e
end

return M
