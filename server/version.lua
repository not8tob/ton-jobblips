local function checkVersion()
    local current_version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    PerformHttpRequest('https://raw.githubusercontent.com/not8tob/version_control/main/jobblips', function(code, data, headers)
        if code ~= 200 then return DEBUG.Log('ERROR', 'Not able to check the resource version') end
        data = json.decode(data)
        if current_version == data.version then return DEBUG.Log('INFO', 'The resource is updated') end
        DEBUG.Log('WARNING', 'The resource version is outdated. Please update the resource. The things that changed are:')
        local news = data.news
        for _, new in pairs(news) do
            DEBUG.Log('INFO', 'Changelog: ' ..new)
        end
    end, 'GET')
end

CreateThread(function()
    Wait(1000)
    checkVersion()
end)