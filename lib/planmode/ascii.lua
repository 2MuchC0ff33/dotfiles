local M = {}
local MAP = {
  {"\194\160", " "},
  {"\226\128\147", "-"},
  {"\226\128\148", "-"},
  {"\226\128\156", '"'},
  {"\226\128\157", '"'},
  {"\226\128\152", "'"},
  {"\226\128\153", "'"},
  {"\226\128\166", "..."},
  {"\226\134\146", "->"},
  {"\226\128\145", "-"},
}

function M.normalize(data)
  local out = data
  for _, pair in ipairs(MAP) do
    out = out:gsub(pair[1], pair[2])
  end
  return out:gsub("\239\187\191", "")
end

function M.first_non_ascii(data)
  for i = 1, #data do
    local byte = data:byte(i)
    if byte >= 127 then return i, byte end
  end
  return nil
end

return M
