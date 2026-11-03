local M = {}

local KNOWN = {
  TH = true,
  SH = true,
  SS = true,
  TP = true,
  TQ = true,
  IP = true,
  HP = true,
  PP = true,
  LP = true,
  P = true,
  br = true,
  sp = true,
  nf = true,
  fi = true,
  B = true,
  I = true,
  BR = true,
  BI = true,
  IB = true,
  IR = true,
  RB = true,
  RI = true,
  SB = true,
  SM = true,
  Em = true,
  Sy = true,
  Li = true,
  Cm = true,
  Ic = true,
  Va = true,
  Vt = true,
  Fn = true,
  Ft = true,
  Fa = true,
  In = true,
  Fd = true,
  Xr = true,
  Nm = true,
  Nd = true,
  Fl = true,
  Ar = true,
  Pa = true,
  Op = true,
  Oo = true,
  Oc = true,
  Pq = true,
  Ql = true,
  Dq = true,
  Sq = true,
  Qq = true,
  Aq = true,
  Bq = true,
  Brq = true,
  Bro = true,
  Brc = true,
  Eo = true,
  Ec = true,
  En = true,
  Es = true,
  Ex = true,
  Rv = true,
  St = true,
  Lb = true,
  At = true,
  Bx = true,
  Bsx = true,
  Fx = true,
  Nx = true,
  Ox = true,
  Dx = true,
  Ux = true,
  Lk = true,
  Mt = true,
  Mx = true,
  Tn = true,
  Sx = true,
  RS = true,
  RE = true,
  TS = true,
  TE = true,
  T = true,
  D1 = true,
  Dl = true,
  Bd = true,
  Ed = true,
  Bl = true,
  El = true,
  It = true,
  Ta = true,
  Tg = true,
  UR = true,
  UE = true,
  ME = true,
  MT = true,
  SY = true,
  YS = true,
  OP = true,
  de = true,
  ds = true,
  rm = true,
  nr = true,
  ["if"] = true,
  ie = true,
  el = true,
  so = true,
  mso = true,
  tr = true,
  char = true,
  rchar = true,
  ["while"] = true,
  ["break"] = true,
  continue = true,
  ["return"] = true,
  als = true,
  ami = true,
  am = true,
  ig = true,
  eo = true,
  ec = true,
  ev = true,
  ti = true,
  ne = true,
  nh = true,
  hy = true,
  ad = true,
  na = true,
  ce = true,
  po = true,
  pl = true,
  ll = true,
  bp = true,
  ps = true,
  vs = true,
  ft = true,
  fam = true,
  hw = true,
  cc = true,
  c2 = true,
  nop = true,
  ns = true,
  os = true,
  pc = true,
  pm = true,
  pn = true,
  rt = true,
  ta = true,
  tc = true,
  tl = true,
  wh = true,
  mk = true,
  rn = true,
  rr = true,
  ss = true,
  sv = true,
  tm = true,
  uf = true,
  ul = true,
  af = true,
  as = true,
  fchar = true,
  schar = true,
  class = true,
  hcode = true,
  hla = true,
  hlm = true,
  hpf = true,
  hpfa = true,
  hpfcode = true,
  rj = true,
  xn = true,
}

---@param line string
---@return string|nil
---@return string|nil
function M.macro(line)
  if line:sub(1, 1) ~= "." and line:sub(1, 1) ~= "'" then
    return nil
  end
  local name = line:match("^[.'][%s]*([A-Za-z][A-Za-z0-9]*)")
  if name == nil then
    return nil, "malformed macro line"
  end
  return name
end

---@param path string
---@return boolean|nil
---@return string|nil
function M.validate(path)
  local f, err = io.open(path, "r")
  if f == nil then
    return nil, err
  end
  local text = f:read("*a")
  f:close()

  if text:find("%.TH") == nil then
    return nil, path .. ": missing .TH"
  end

  local has_name = false
  local has_body = false
  local line_no = 0
  local last_section = ""
  local section_body = false

  for line in (text .. "\n"):gmatch("(.-)\n") do
    line_no = line_no + 1
    if line:sub(1, 3) ~= '.\\"' then
      local name, merr = M.macro(line)
      if merr ~= nil then
        return nil, path .. ":" .. line_no .. ": " .. merr
      end
      if name ~= nil then
        if not KNOWN[name] then
          return nil, path .. ":" .. line_no .. ": unknown macro ." .. name
        end
        if name == "TH" then
          local title, section = line:match("^%.TH%s+(%S+)%s+(%S+)")
          if title == nil or section == nil then
            return nil, path .. ":" .. line_no .. ": .TH requires title and section"
          end
          if section:match("^[1-9][A-Za-z]*$") == nil then
            return nil, path .. ":" .. line_no .. ": .TH section must be 1-9"
          end
        elseif name == "SH" then
          local title = line:match("^%.SH%s+(.+)$")
          if title == nil or title == "" then
            return nil, path .. ":" .. line_no .. ": .SH requires a title"
          end
          if last_section == "NAME" and not section_body then
            return nil, path .. ":" .. line_no .. ": empty NAME section"
          end
          last_section = title
          section_body = false
          if title == "NAME" then
            has_name = true
          elseif title == "SYNOPSIS" or title == "DESCRIPTION" then
            has_body = true
          end
        end
      elseif line:match("^%s*$") == nil then
        section_body = true
      end
    end
  end

  if not has_name then
    return nil, path .. ": missing .SH NAME"
  end
  if not has_body then
    return nil, path .. ": missing .SH SYNOPSIS or .SH DESCRIPTION"
  end
  return true
end

return M
