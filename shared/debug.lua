DEBUG = {}
DEBUG.enabled = CONFIG.DEBUG_ENABLED
local res_name = GetCurrentResourceName()

local debug_levels = {
    ['CRITICAL'] = '^1['..res_name..'] CRITICAL: ^7',
    ['INFO']     = '^2['..res_name..'] INFO: ^7',
    ['WARNING']  = '^3['..res_name..'] WARNING: ^7',
    ['ERROR']    = '^1['..res_name..'] ERROR: ^7',
}

---Log a message to the console.
---@param level string CRITICAL|INFO|WARNING|ERROR
---@param msg any The data to log.
function DEBUG.Log(level, msg)
    if not DEBUG.enabled then return end
    if not debug_levels[level] then return end
    Citizen.Trace(debug_levels[level]..msg..'\n')
end