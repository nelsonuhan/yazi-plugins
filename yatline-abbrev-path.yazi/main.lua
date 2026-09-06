-- ~/.config/yazi/plugins/yatline-abbrev-path.yazi/main.lua

local M = {}

local function abbrev_path(cwd, max_len)
  local home = os.getenv('HOME') or ''
  local has_tilde = false
  if home ~= '' and cwd:sub(1, #home) == home then
    cwd = '~' .. cwd:sub(#home + 1)
    has_tilde = true
  end

  if cwd == '/' or cwd == '~' then
    return cwd
  end

  local leading, rest
  if has_tilde then
    leading = '~/'
    rest = cwd:sub(3)
  elseif cwd:sub(1, 1) == '/' then
    leading = '/'
    rest = cwd:sub(2)
  else
    leading = ''
    rest = cwd
  end

  local parts = {}
  for part in rest:gmatch('[^/]+') do
    table.insert(parts, part)
  end

  local full_path = leading .. table.concat(parts, '/')

  if not max_len or #full_path <= max_len then
    return full_path
  end

  -- Doesn't fit: abbreviate everything, then expand from the right
  local result = {}
  for i, part in ipairs(parts) do
    result[i] = part:sub(1, 1)
  end
  for i = #parts, 1, -1 do
    result[i] = parts[i]
    if #(leading .. table.concat(result, '/')) > max_len then
      result[i] = parts[i]:sub(1, 1)
      break
    end
  end
  return leading .. table.concat(result, '/')
end

function M:setup()
  --- @param max_len? integer Maximum display length; if unset, full path is shown (default: nil)
  function Yatline.string.get:abbrev_tab_path(max_len)
    return abbrev_path(tostring(cx.active.current.cwd), max_len)
  end
end

return M
