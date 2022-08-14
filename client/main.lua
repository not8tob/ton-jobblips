UNIT = {}
UNIT.__index = UNIT

JOBBLIPS = {
    SERVER_ID = GetPlayerServerId(PlayerId()),
    UNITS = setmetatable(
        {
            units = {},
        },
        {
            __index = self,
            __add = function(self, unit)
                if type(unit.server_id) ~= 'number' then return end
                self.units[unit.server_id] = unit
                return self.units[unit.server_id]
            end,
            __sub = function (self, unit)
                if type(unit.server_id) ~= 'number' then return end
                self.units[unit.server_id] = nil
            end,
        }
    ),
}

---Update the coords of the unit.
---@param coords table
function UNIT:updateCoords(coords)
    self.coords = coords
    self:update()
end

---Update the color of the unit.
---@param color number
function UNIT:updateColor(color)
    self.color = color
end

---Destroy the number of the unit.
---@return number
function UNIT:destroy()
    return JOBBLIPS.UNITS - self
end

---Update the blip of the unit.
function UNIT:update()
    local ped = nil
    if self.server_id == JOBBLIPS.SERVER_ID then
        ped = PlayerPedId()
    else
        local player = GetPlayerFromServerId(self.server_id)
        ped = GetPlayerPed(player)
    end
    if self.blip_id ~= nil and DoesBlipExist(self.blip_id) then
        SetBlipCoords(self.blip_id, self.coords.x, self.coords.y, self.coords.z)
        SetBlipColour(self.blip_id, self.color)
        return
    end
    if ped then
        self.blip_id = AddBlipForEntity(ped)
    end
    if not self.blip_id or not DoesBlipExist(self.blip_id) then
        self.blip_id = AddBlipForCoord(self.coords.x, self.coords.y, self.coords.z)
    end
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(self.name)
    EndTextCommandSetBlipName(self.blip_id)
    SetBlipCoords(self.blip_id, self.coords.x, self.coords.y, self.coords.z)
    SetBlipAsShortRange(self.blip_id, true)
    if self.heading then
        ShowHeadingIndicatorOnBlip(self.blip_id, true)
        SetBlipRotation(self.blip_id, self.heading)
    end
    SetBlipColour(self.blip_id, self.color)
    SetBlipScale(self.blip_id, 1.3)
end

CreateThread(function()
    Wait(1000)
    for _, command in pairs(CONFIG.COMMANDS) do
        TriggerEvent('chat:addSuggestion', '/'..command[1], command[2], {})
    end
    DEBUG.Log('INFO', 'Registered command suggestions')
end)