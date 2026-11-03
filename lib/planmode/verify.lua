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

return M
