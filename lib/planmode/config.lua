local M = {}

local function find_line(lines, pattern)
  for i, line in ipairs(lines) do
    if line:find(pattern, 1, true) then return i end
  end
  return nil
end

function M.add_subagent_depth(data)
  if data:find('"subagent_depth"', 1, true) then return data, "unchanged" end
  if data:find('"experimental"', 1, true) then
    error("opencode.json already has an experimental object without subagent_depth; edit it manually")
  end
  local lines = {}
  for line in data:gmatch("([^\n]*)\n?") do lines[#lines + 1] = line end
  if lines[#lines] == "" then table.remove(lines) end
  local at = find_line(lines, "{")
  if not at then error("opencode.json does not start with an object") end
  table.insert(lines, at + 1, '  "experimental": { "subagent_depth": 2 },')
  return table.concat(lines, "\n") .. "\n", "added"
end

function M.remove_subagent_depth(data)
  if not data:find('"subagent_depth"', 1, true) then return data, "unchanged" end
  local cleaned = data:gsub('  "experimental": { "subagent_depth": 2 },\n', "")
  if cleaned == data then
    error("cannot remove subagent_depth with the managed one-line layout; edit opencode.json manually")
  end
  return cleaned, "removed"
end

return M
