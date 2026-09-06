-- ~/.config/yazi/plugins/yatline-gitinfo.yazi/main.lua

local function setup(st, opts)
  st.info = {}

  function Yatline.coloreds.get:gitinfo()
    local cwd = tostring(cx.active.current.cwd)
    local info = st.info[cwd]
    if not info then
      return nil
    end
    return info
  end

  -- Refresh only on actual navigation/file-change events, not on every
  -- directory rendered anywhere (e.g. preview panes) -- using a fetcher for
  -- that fires far too often and leaves background git calls unfinished
  -- when quitting.
  local callback = function()
    local cwd = cx.active.current.cwd
    ya.emit('plugin', {
      st._id,
      ya.quote(tostring(cwd), true),
    })
  end

  ps.sub('cd', callback)
  ps.sub('tab', callback)
  ps.sub('rename', callback)
  ps.sub('bulk', callback)
  ps.sub('move', callback)
  ps.sub('trash', callback)
  ps.sub('delete', callback)
end

local add = ya.sync(function(st, cwd, info)
  st.info[cwd] = info
  ui.render()
end)

local remove = ya.sync(function(st, cwd)
  st.info[cwd] = nil
  ui.render()
end)

local function entry(_, job)
  local args = job.args or job
  local cwd = args[1]

  -- Single call: get branch, ahead/behind, and dirty status all at once
  local output = Command('git')
    :cwd(cwd)
    :arg({ '--no-optional-locks', 'status', '--porcelain=v2', '--branch' })
    :output()
  if not output or output.stdout == '' then
    remove(cwd)
    return
  end

  local branch, ahead, behind, dirty = nil, 0, 0, 0
  for line in output.stdout:gmatch('[^\n]+') do
    if line:match('^# branch%.head ') then
      branch = line:match('^# branch%.head (.+)')
    elseif line:match('^# branch%.ab ') then
      local a, b = line:match('%+(%d+) %-(%d+)')
      ahead = tonumber(a) or 0
      behind = tonumber(b) or 0
    elseif not line:match('^#') then
      dirty = dirty + 1
    end
  end

  -- No branch (detached HEAD) or not a repo
  if not branch or branch == '(detached)' then
    remove(cwd)
    return
  end
  branch = branch:gsub('%s+$', '')

  -- Build coloreds array
  local coloreds = { { ' ' .. branch, 'white' } }
  if ahead > 0 then
    coloreds[#coloreds + 1] = { ' ⇡' .. ahead, 'green' }
  end
  if behind > 0 then
    coloreds[#coloreds + 1] = { ' ⇣' .. behind, 'red' }
  end
  if dirty > 0 then
    coloreds[#coloreds + 1] = { ' ~' .. dirty, 'yellow' }
  end

  add(cwd, coloreds)
end

return { setup = setup, entry = entry }
