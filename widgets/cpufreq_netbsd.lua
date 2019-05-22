-- {{{ Grab environment
local tonumber = tonumber
local setmetatable = setmetatable
local helpers = require("vicious.helpers")
-- }}}

--[[
  Possible values for your system to pass to warg
  Aarch64
    machdep.cpu.frequency.current
  Intel SpeedStep
    machdep.est.frequency.current
  AMD PowerNow!
    machdep.powernow.frequency.current
--]]


-- Cpufreq: provides freq, voltage and governor info for a requested CPU
-- vicious.widgets.cpufreq
local cpufreq_netbsd = {}


-- {{{ CPU frequency widget type
local function worker(format, warg)
    if not warg then return end

    -- Default frequency and voltage values
    local freqv = {
        ["mhz"] = "N/A", ["ghz"] = "N/A",
        ["v"]   = "N/A", ["mv"]  = "N/A",
    }

    local freq = tonumber(helpers.sysctl(warg))

    freqv.mhz = freq
    freqv.ghz = freq / 1000

    local governor = "N/A"

    return {freqv.mhz, freqv.ghz, freqv.mv, freqv.v, governor}
end
-- }}}

return setmetatable(cpufreq_netbsd, { __call = function(_, ...) return worker(...) end })
