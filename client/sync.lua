local data_cache = {}

---Create a unit.
---@param data table
local function createUnit(data)
    if not data.server_id then return end
    local self = setmetatable({
        server_id = data.server_id,
        color = data.color or 1,
        coords = data.coords or {x = 0, y = 0, z = 0},
        heading = data.heading or 0,
        name = data.name,
    }, UNIT)
    return JOBBLIPS.UNITS + self
end

---Check if any unit should be removed.
---@param data table
local function checkIfRemove(data)
    for unit in pairs(data_cache) do
        if not data[unit] then
            if not JOBBLIPS.UNITS.units[unit] then return end
            RemoveBlip(JOBBLIPS.UNITS.units[unit].blip_id)
            JOBBLIPS.UNITS.units[unit]:destroy()
        end
    end
end

---Update the units.
---@param data table
local function updateUnits(data)
    checkIfRemove(data)
    data_cache = data
    for _, un in pairs(data) do
        if not JOBBLIPS.UNITS.units[un.server_id] then
            local unit = createUnit(un)
            if unit then
                DEBUG.Log('INFO', 'Created new unit with server_id: '..un.server_id)
            end
        else
            JOBBLIPS.UNITS.units[un.server_id]:updateColor(un.color)
            JOBBLIPS.UNITS.units[un.server_id]:updateCoords(un.coords)
        end
    end
end

RegisterNetEvent(CONFIG.EVENT_PREFIX..'update_units', updateUnits)

local function removeRefs()
    for unit in pairs(JOBBLIPS.UNITS.units) do
        if not JOBBLIPS.UNITS.units[unit] then return end
        RemoveBlip(JOBBLIPS.UNITS.units[unit].blip_id)
        JOBBLIPS.UNITS.units[unit]:destroy()
    end
end

RegisterNetEvent(CONFIG.EVENT_PREFIX..'remove_refs', removeRefs)