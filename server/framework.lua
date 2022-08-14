CORE = nil
if CONFIG.FRAMEWORK[1] == 'esx' then
    local function callCore()
        CORE = exports[CONFIG.FRAMEWORK[2]]:getSharedObject()
    end
    if pcall(callCore) then
        DEBUG.Log('INFO', 'Successfully loaded '..CONFIG.FRAMEWORK[2])
    else
        DEBUG.Log('CRITICAL', 'Failed to load '..CONFIG.FRAMEWORK[2]..'. Error handled, check your framework in config.lua')
    end
elseif CONFIG.FRAMEWORK[1] == 'qbcore' then
    local function callCore()
        CORE = exports[CONFIG.FRAMEWORK[2]]:GetCoreObject()
    end
    if pcall(callCore) then
        DEBUG.Log('INFO', 'Successfully loaded '..CONFIG.FRAMEWORK[2])
    else
        DEBUG.Log('CRITICAL', 'Failed to load '..CONFIG.FRAMEWORK[2]..'. Error handled, check your framework in config.lua')
    end
else
    ---Your export here
end

FRAMEWORK = {
    GET_JOB = function(src)
        if CONFIG.FRAMEWORK[1] == 'esx' then
            local player = CORE.GetPlayerFromId(src)
            return player.job.name
        end
        if CONFIG.FRAMEWORK[1] == 'qbcore' then
            local player = CORE.Functions.GetPlayer(src)
            return player.PlayerData.job.name
        end
        if CONFIG.FRAMEWORK == 'custom' then
            ---Include here your framework logic to get the job and return it instead of 'custom'.
            return 'custom'
        end
    end,
    GET_NAME = function (src)
        if CONFIG.FRAMEWORK[1] == 'esx' then
            local player = CORE.GetPlayerFromId(src)
            return player.getName()
        end
        if CONFIG.FRAMEWORK[1] == 'qbcore' then
            local player = CORE.Functions.GetPlayer(src)
            return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
        end
        if CONFIG.FRAMEWORK == 'custom' then
            ---Include here your framework logic to get the name and return it instead of this return.
            return GetPlayerName(src) or ''
        end
    end
}