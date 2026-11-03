local util = require("util")
local M = {}

local function is_safe_rel(path)
  if path:sub(1, 1) == "/" then return false end
  if path:find("..", 1, true) then return false end
  return true
end

function M.plan(src_list, dst_list)
  local keep = {}
  for line in io.lines(src_list) do keep[line] = true end
  for line in io.lines(dst_list) do
    if is_safe_rel(line) and not keep[line] then io.write(line, "\n") end
  end
end

function M.copy_manifest(list_file, src_root, dst_root)
  for line in io.lines(list_file) do
    if not is_safe_rel(line) then error("unsafe path: " .. line) end
    local src = src_root .. "/" .. line
    local dst = dst_root .. "/" .. line
    local data = util.read_all(src)
    util.write_all(dst, data)
  end
end

return M
