local M = {}

local MAX_IDENTITY_LINES = 40

local function read_file(path)
  local f = io.open(path, "rb")
  if not f then
    return nil
  end
  local data = f:read("*a")
  f:close()
  return data
end

local function split_segments(plan_arg)
  local parts = {}
  for part in (plan_arg .. "/"):gmatch("(.-)/") do
    parts[#parts + 1] = part
  end
  return parts
end

function M.parse_identity(data)
  local out = {}
  local line_no = 0
  for raw in (data .. "\n"):gmatch("(.-)\n") do
    line_no = line_no + 1
    if line_no > MAX_IDENTITY_LINES then
      break
    end
    local line = raw:gsub("\r$", "")
    local key, value = line:match("^([A-Za-z][A-Za-z0-9%-]*):%s*(.-)%s*$")
    if key and out[key] == nil then
      out[key] = value
    end
  end
  return out
end

function M.valid_segment(segment)
  if type(segment) ~= "string" then
    return false
  end
  if segment == "" or segment == "." or segment == ".." then
    return false
  end
  if segment:find("/", 1, true) or segment:find("\\", 1, true) then
    return false
  end
  return segment:match("^[A-Za-z0-9._%-]+$") ~= nil
end

local function select_explicit(repo_root, repo_name, plan_arg, plan_root)
  local parts = split_segments(plan_arg)
  if #parts < 1 or #parts > 2 then
    return nil, 5, "unsafe plan argument: " .. plan_arg
  end
  for _, part in ipairs(parts) do
    if not M.valid_segment(part) then
      return nil, 5, "unsafe plan segment: " .. part
    end
  end

  local repo, plan_id
  if #parts == 1 then
    repo = repo_name
    plan_id = parts[1]
  else
    repo = parts[1]
    plan_id = parts[2]
  end

  if repo ~= repo_name then
    return nil, 3, "plan repo " .. repo .. " does not match repository " .. repo_name
  end

  local dir = plan_root .. "/" .. repo .. "/" .. plan_id
  local data = read_file(dir .. "/HANDOVER.md")
  if not data then
    return nil, 2, "no plan for repo " .. repo_name .. "; searched " .. dir
  end

  local identity = M.parse_identity(data)
  if not identity.Repo or not identity.Status or not identity["Plan-Dir"] then
    return nil, 4, "handover identity is missing Repo, Status, or Plan-Dir"
  end
  if identity.Status ~= "READY" then
    return nil, 4, "handover status is not READY: " .. identity.Status
  end
  if identity.Repo ~= repo_root then
    return nil, 3, "handover Repo " .. identity.Repo .. " does not match " .. repo_root
  end
  if identity["Plan-Dir"] ~= dir then
    return nil, 4, "handover Plan-Dir " .. identity["Plan-Dir"] .. " does not match " .. dir
  end
  return dir, 0
end

local function select_bare(repo_root, repo_name, candidates, plan_root)
  local found = {}
  local seen = {}
  for _, path in ipairs(candidates) do
    local data = read_file(path)
    if data then
      local identity = M.parse_identity(data)
      if identity.Status == "READY" and identity.Repo == repo_root then
        local dir = path:match("^(.*)/HANDOVER%.md$")
        if dir and not seen[dir] then
          seen[dir] = true
          found[#found + 1] = dir
        end
      end
    end
  end

  if #found == 0 then
    return nil, 2, "no READY handover for repo " .. repo_name .. " under " .. plan_root .. "/" .. repo_name
  end
  if #found > 1 then
    table.sort(found)
    return nil, 2, "multiple READY handovers for repo " .. repo_name .. ":\n  " .. table.concat(found, "\n  ")
  end
  return found[1], 0
end

function M.select(repo_root, repo_name, plan_arg, candidates, plan_root)
  plan_root = plan_root or ((os.getenv("HOME") or "") .. "/.opencode/plan")
  candidates = candidates or {}
  if plan_arg ~= nil and plan_arg ~= "" then
    return select_explicit(repo_root, repo_name, plan_arg, plan_root)
  end
  return select_bare(repo_root, repo_name, candidates, plan_root)
end

return M
