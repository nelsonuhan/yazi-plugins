--- @sync entry

-- Hide the preview pane and give its width to the current pane, so the parent
-- pane keeps the width it had. Run again to restore the ratio from before.
--
-- toggle-pane's min-preview drops the preview's share instead, which widens
-- the parent along with the current pane.

local function get()
  local r = rt.mgr.ratio
  return { r[1], r[2], r[3] }
end

local function set(r)
  rt.mgr.ratio = { r[1], r[2], r[3] }
  ya.emit('app:resize', {})
end

local function eq(a, b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3]
end

local function entry(st)
  local now = get()

  -- Restore only if the ratio is still the one this plugin set; if something
  -- else changed it since, start over from what it is now.
  if st.old and eq(now, st.absorbed) then
    set(st.old)
    st.old, st.absorbed = nil, nil
    return
  end

  st.old = now
  st.absorbed = { now[1], now[2] + now[3], 0 }
  set(st.absorbed)
end

return { entry = entry }
