local uv = vim.loop
local json = vim.json
local M = {}

M.server = nil
M.clients = {}

function M.start()
	if M.server then
		return
	end

	M.server = uv.new_tcp()
	M.server:bind("127.0.0.1", 7071)
	M.server:listen(128, function(err)
		assert(not err, err)
		local client = uv.new_tcp()
		M.server:accept(client)
		table.insert(M.clients, client)

		client:read_start(function(err2, chunk)
			assert(not err2, err2)
			if chunk and #chunk > 0 then
				-- Simple HTTP WebSocket handshake
				if chunk:find("Upgrade: websocket") then
					local key = chunk:match("Sec%-WebSocket%-Key: (.-)\r\n")
					local sha1 = vim.fn.sha256(key .. "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")
					local accept = vim.fn.systemlist("echo -n '" .. sha1 .. "' | base64")[1]
					local response = table.concat({
						"HTTP/1.1 101 Switching Protocols",
						"Upgrade: websocket",
						"Connection: Upgrade",
						"Sec-WebSocket-Accept: " .. accept,
						"\r\n",
					}, "\r\n")
					client:write(response)
				else
					-- Handle scroll event from browser
					local payload = chunk:sub(3)
					pcall(function()
						local msg = json.decode(payload)
						if msg.type == "scroll" then
							vim.schedule(function()
								local line = math.floor(msg.ratio * vim.api.nvim_buf_line_count(0))
								pcall(vim.api.nvim_win_set_cursor, 0, { line + 1, 0 })
							end)
						end
					end)
				end
			end
		end)
	end)

	print("WebSocket server running on ws://127.0.0.1:7071")
end

function M.send(msg)
	local data = json.encode(msg)
	for _, client in ipairs(M.clients) do
		client:write("\x81" .. string.char(#data) .. data) -- opcode=1 text frame
	end
end

function M.stop()
	if M.server then
		M.server:close()
		M.server = nil
	end
	M.clients = {}
end

return M
