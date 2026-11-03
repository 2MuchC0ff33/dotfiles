local M = {}
local state = 12345

---@param n integer
function M.seed(n)
  state = n % 65537
  if state == 0 then
    state = 1
  end
end

---@return integer
function M.next()
  state = (75 * state + 74) % 65537
  return state
end

---@param n integer
---@return integer
function M.int(n)
  return (M.next() % n) + 1
end

return M
