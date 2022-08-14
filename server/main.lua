local unit = {}
unit.__index = unit
JOBBLIPS = {
    UNITS = setmetatable({
        units = {},
    }, {
        __index = self,
        __add = function(self, unit)
            if type(unit.server_id) ~= 'number' then return end
            self.units[unit.server_id] = unit
            return self.units
        end,
    }),
    LISTENERS = {},
}

local function isAllowed(src)
    local job = FRAMEWORK.GET_JOB(src)
    local jobs_allowed = CONFIG.JOBS
    if type(jobs_allowed) == 'table' then
        for i = 1, #jobs_allowed do
            if jobs_allowed[i] == job then
                return true
            end
        end
    end
    return false
end

---Remove a unit from the list.
---@param id number
function JOBBLIPS.UNITS:removeUnit(id)
    self.units[id] = nil
end

---Update color of a unit.
---@param color number
function unit:updateColor(color)
    self.color = color
end

---Update the units
function JOBBLIPS.UNITS:update()
    CreateThread(function()
        while true do
            for _, un in pairs(self.units) do
                local ped = GetPlayerPed(un.server_id)
                if DoesEntityExist(ped) then
                    local coords = GetEntityCoords(ped)
                    local heading = math.floor(GetEntityHeading(ped))
                    un.heading = heading
                    un.coords = coords
                else
                    JOBBLIPS.UNITS:removeUnit(un.server_id)
                end
            end
            for listener, enabled in pairs(JOBBLIPS.LISTENERS) do
                if not enabled then goto skip end
                TriggerClientEvent(CONFIG.EVENT_PREFIX..'update_units', listener, self.units)
                ::skip::
            end
            Wait(CONFIG.REFRESH_RATE)
        end
    end)
end

---Update the listen state of the listener.
---@param source any
local function handleListen(source)
    local allowed = isAllowed(source)
    if not allowed then
        print(CONFIG.LOCALES.NOT_ALLOWED)
        return 0
    end
    JOBBLIPS.LISTENERS[source] = true
end

RegisterCommand(CONFIG.COMMANDS[1][1], handleListen)

---Check if a reference exist
---@param source number
---@return boolean
local function doesRefExist(source)
    for _, unit in pairs(JOBBLIPS.UNITS.units) do
        if unit.server_id == source then
            return true
        end
    end
    return false
end

---Handle reference activation
---@param source number
---@return number
local function handleRef(source)
    local allowed = isAllowed(source)
    if not allowed then
        print(CONFIG.LOCALES.NOT_ALLOWED)
        return 0
    end
    local exist = doesRefExist(source)
    if exist then
        if JOBBLIPS.UNITS.units[source] then
            JOBBLIPS.UNITS:removeUnit(source)
        end
        JOBBLIPS.LISTENERS[source] = nil
        TriggerClientEvent(CONFIG.EVENT_PREFIX..'remove_refs', source)
        return 0
    end
    local self = setmetatable({
        server_id = tonumber(source),
        color = 1,
        coords = GetEntityCoords(GetPlayerPed(source)),
        heading = math.floor(GetEntityHeading(GetPlayerPed(source))),
        name = FRAMEWORK.GET_NAME(source),
    }, unit)
    JOBBLIPS.LISTENERS[source] = true
    return JOBBLIPS.UNITS + self
end

RegisterCommand(CONFIG.COMMANDS[2][1], handleRef)

---Change the color of a reference.
---@param source number
---@param args table
local function changeColor(source, args)
    local color = tostring(args[1])
    if not color then return end
    local unit = JOBBLIPS.UNITS.units[source]
    if not unit then return end
    local color = CONFIG.ALLOWED_COLORS[color]
    if not color then return print(CONFIG.LOCALES.NOT_ALLOWED) end
    unit:updateColor(color)
end

RegisterCommand(CONFIG.COMMANDS[3][1], changeColor)

---Remove references
---@param source number
local function removeRefs(source)
    if JOBBLIPS.UNITS.units[source] then
        JOBBLIPS.UNITS:removeUnit(source)
    end
    JOBBLIPS.LISTENERS[source] = nil
    TriggerClientEvent(CONFIG.EVENT_PREFIX..'remove_refs', source)
end

RegisterCommand(CONFIG.COMMANDS[4][1], removeRefs)

JOBBLIPS.UNITS:update()