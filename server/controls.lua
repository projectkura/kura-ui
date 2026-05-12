_ENV.__kura_ui = _ENV.__kura_ui or {}

local state = __kura_ui
state.server = state.server or {}

local server = state.server
local resourceName <const> = GetCurrentResourceName()

server.controls = server.controls or {
    entries = {},
    sequence = 0,
}

local controls = server.controls

local function resolveOwner(rawOwner)
    local invoking <const> = GetInvokingResource()

    if invoking and invoking ~= '' then
        rawOwner = invoking
    end

    if type(rawOwner) ~= 'string' or rawOwner == '' then
        rawOwner = resourceName
    end

    return ('server:%s'):format(rawOwner)
end

local function normalizeTargets(targets)
    local list = {}
    local seen = {}

    if type(targets) == 'number' then
        targets = { targets }
    end

    if type(targets) ~= 'table' then
        error('kura-ui server controls require a target id or target id array.', 3)
    end

    for index = 1, #targets do
        local target <const> = targets[index]

        if type(target) == 'number' and target > 0 and not seen[target] then
            seen[target] = true
            list[#list + 1] = target
        end
    end

    if #list == 0 then
        error('kura-ui server controls require at least one valid target player id.', 3)
    end

    return list
end

local function toTargetSet(targets)
    local set = {}

    for index = 1, #targets do
        set[targets[index]] = true
    end

    return set
end

local function hasTargets(targets)
    for _ in pairs(targets) do
        return true
    end

    return false
end

local function nextId(owner)
    controls.sequence = controls.sequence + 1
    return ('controls:%s:%d'):format(owner:gsub('[^%w%-_]', '_'), controls.sequence)
end

local function makeEntryKey(owner, id)
    return ('%s::controls::%s'):format(owner, id)
end

local function shallowCopy(data)
    local clone = {}

    for key, value in pairs(data) do
        clone[key] = value
    end

    return clone
end

local function emit(eventName, targets, ...)
    for index = 1, #targets do
        TriggerClientEvent(eventName, targets[index], ...)
    end
end

function server.controlsShowFor(rawOwner, targets, data)
    if type(data) ~= 'table' then
        error('kura-ui controls.showFor requires a data table.', 3)
    end

    local owner <const> = resolveOwner(rawOwner)
    local targetList <const> = normalizeTargets(targets)
    local payload <const> = shallowCopy(data)

    if type(payload.id) ~= 'string' or payload.id == '' then
        payload.id = nextId(owner)
    end

    local key <const> = makeEntryKey(owner, payload.id)
    controls.entries[key] = {
        owner = owner,
        id = payload.id,
        targets = toTargetSet(targetList),
    }

    emit('kura-ui:server:controlsShow', targetList, owner, payload)
    return payload.id
end

function server.controlsUpdateFor(rawOwner, targets, id, patch)
    if type(id) ~= 'string' or id == '' then
        error('kura-ui controls.updateFor requires a non-empty id.', 3)
    end

    if type(patch) ~= 'table' then
        error('kura-ui controls.updateFor requires a patch table.', 3)
    end

    local owner <const> = resolveOwner(rawOwner)
    local key <const> = makeEntryKey(owner, id)
    local entry <const> = controls.entries[key]

    if not entry then
        return false
    end

    local targetList <const> = normalizeTargets(targets)
    emit('kura-ui:server:controlsUpdate', targetList, owner, id, patch)
    return true
end

function server.controlsHideFor(rawOwner, targets, id)
    if type(id) ~= 'string' or id == '' then
        error('kura-ui controls.hideFor requires a non-empty id.', 3)
    end

    local owner <const> = resolveOwner(rawOwner)
    local key <const> = makeEntryKey(owner, id)
    local entry <const> = controls.entries[key]

    if not entry then
        return false
    end

    local targetList <const> = normalizeTargets(targets)
    emit('kura-ui:server:controlsHide', targetList, owner, id)

    for index = 1, #targetList do
        entry.targets[targetList[index]] = nil
    end

    if not hasTargets(entry.targets) then
        controls.entries[key] = nil
    end

    return true
end

function server.controlsClearFor(rawOwner, targets)
    local owner <const> = resolveOwner(rawOwner)
    local targetList <const> = normalizeTargets(targets)

    for key, entry in pairs(controls.entries) do
        if entry.owner == owner then
            for index = 1, #targetList do
                entry.targets[targetList[index]] = nil
            end

            if not hasTargets(entry.targets) then
                controls.entries[key] = nil
            end
        end
    end

    emit('kura-ui:server:controlsClearOwner', targetList, owner)
end

AddEventHandler('onResourceStop', function(stoppedResource)
    if stoppedResource == resourceName then
        return
    end

    local owner <const> = ('server:%s'):format(stoppedResource)
    local allTargets = {}
    local seenTargets = {}

    for key, entry in pairs(controls.entries) do
        if entry.owner == owner then
            for target in pairs(entry.targets) do
                if not seenTargets[target] then
                    seenTargets[target] = true
                    allTargets[#allTargets + 1] = target
                end
            end

            controls.entries[key] = nil
        end
    end

    if #allTargets > 0 then
        emit('kura-ui:server:controlsClearOwner', allTargets, owner)
    end
end)
