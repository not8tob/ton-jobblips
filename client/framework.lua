CORE = nil

local function executeReferenceRemoving()
    ExecuteCommand('removerefs')
end

if CONFIG.FRAMEWORK[1] == 'esx' then
    RegisterNetEvent('esx:setJob', executeReferenceRemoving)
elseif CONFIG.FRAMEWORK[1] == 'qbcore' then
    RegisterNetEvent('QBCore:Client:OnJobUpdate', executeReferenceRemoving)
else
    ---Your job change event
end