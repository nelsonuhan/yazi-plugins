local M = {}

function M:entry()
	local dir = os.getenv("YAZI_START_DIR")
	if dir and dir ~= "" then
		ya.emit("cd", { Url(dir), raw = true })
	end
end

return M
