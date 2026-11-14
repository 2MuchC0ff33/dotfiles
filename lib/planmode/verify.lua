local util = require("util")
local M = {}

local REQUIRED_FILES = {
  "agents/plan.md",
  "agents/plan-repo-indexer.md",
  "agents/plan-researcher.md",
  "agents/plan-interrogator.md",
  "agents/plan-verifier.md",
  "agents/plan-risk-analyst.md",
  "agents/plan-proof-engineer.md",
  "agents/plan-scribe.md",
  "agents/plan-git-release.md",
  "commands/plan.md",
  "commands/execute-plan.md",
  "skills/canonical-plan-protocol/SKILL.md",
  "skills/build-handover-execution/SKILL.md",
  "config/opencode/AGENTS.md",
  "lib/planmode/resolve.lua",
  "lib/planmode/profile.lua",
  "bin/cvs-migrate",
  "templates/repo/AGENTS.block.txt",
  "man/planmode.1",
  "doc/plan-mode.txt",
  "README.txt",
  "Makefile",
}

function M.required_files(root, report)
  for _, rel in ipairs(REQUIRED_FILES) do
    local path = root .. "/" .. rel
    local f = io.open(path, "rb")
    if not f then
      report("missing " .. rel, true)
    else
      local data = f:read("*a")
      f:close()
      local ok = util.is_ascii(data)
      if not ok then report(rel .. " contains non-ascii bytes", true) end
    end
  end
end

function M.plan_agent(data, report)
  if not data:find('"id": "plan"', 1, true) then report("plan agent missing", true) end
  if not data:find('"system": "', 1, true) then report("plan system prompt missing", true) end
  for _, id in ipairs({
    "plan-repo-indexer",
    "plan-researcher",
    "plan-interrogator",
    "plan-verifier",
    "plan-risk-analyst",
    "plan-proof-engineer",
    "plan-scribe",
    "plan-git-release",
  }) do
    if not data:find('"id": "' .. id .. '"', 1, true) then
      report("missing subagent " .. id, true)
    end
  end
end

function M.protocol(text, report)
  if not text:find("maximum 12", 1, true) then report("protocol missing 12-agent budget", true) end
  if not text:find("Switch to the Build agent", 1, true) then report("protocol missing stop rule", true) end
  if text:find("Subagents never edit", 1, true) == nil and text:find("never edit", 1, true) == nil then
    report("protocol missing subagent edit ban", true)
  end
end

function M.generic(root, report)
  local function text(rel)
    local f = io.open(root .. "/" .. rel, "rb")
    if not f then return nil end
    local data = f:read("*a")
    f:close()
    return data
  end

  local cmd = text("commands/execute-plan.md")
  if not cmd then
    report("missing commands/execute-plan.md", true)
  else
    if not cmd:find("resolve-plan", 1, true) then
      report("execute-plan missing resolve-plan", true)
    end
    if cmd:find("/home/twomuchcoffee/.local/src/dotfiles", 1, true) then
      report("execute-plan hardcodes the dotfiles checkout", true)
    end
    if cmd:find("~/.opencode/plan/HANDOVER.md", 1, true) then
      report("execute-plan reads a flat handover", true)
    end
  end

  local agent = text("agents/plan.md")
  if not agent then
    report("missing agents/plan.md", true)
  else
    if not agent:find("<repo>", 1, true) then
      report("plan agent missing repo identity", true)
    end
    if agent:find("write flat artifacts", 1, true) then
      report("plan agent still writes flat artifacts", true)
    end
  end

  local skill = text("skills/canonical-plan-protocol/SKILL.md")
  if not skill then
    report("missing canonical-plan-protocol", true)
  elseif not skill:find("~/.opencode/plan/<repo>/<plan-id>/", 1, true) then
    report("protocol skill missing plan namespace", true)
  end
end

return M
