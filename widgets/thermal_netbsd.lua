-- {{{ Grab environment
local setmetatable = setmetatable
local string = { match = string.match }
local helpers = require("vicious.helpers")
-- }}}


-- Thermal: provides temperature levels of ACPI and coretemp thermal zones
-- vicious.widgets.thermal
local thermal_netbsd = {}


-- {{{ Thermal widget type
local function worker(format, warg)
    if not warg then return end
    if type(warg) ~= "table" then warg = { warg } end

    local gears = require("gears")
    local thermals = {}

    for i=1, #warg do
      local name = gears.string.split(warg[i], ":")[2]
      local f = io.popen("envstat -s " .. helpers.shellquote(warg[i]))
      for line in f:lines("*line") do
        if line then
          for key,value in line:gmatch("%s*(.+):%s+(%d*)%s*") do
            if key == name then
              thermals[i] = value
            end
          end
        end
      end
      f:close()
    end

    return thermals
end
-- }}}

return setmetatable(thermal_netbsd, { __call = function(_, ...) return worker(...) end })
