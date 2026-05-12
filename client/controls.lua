_ENV.__kura_ui = _ENV.__kura_ui or {}

local state = __kura_ui
state.client = state.client or {}

local client = state.client

local validAnchors = {
    ['top-left'] = true,
    ['top-center'] = true,
    ['top-right'] = true,
    ['center-left'] = true,
    ['center'] = true,
    ['center-right'] = true,
    ['bottom-left'] = true,
    ['bottom-center'] = true,
    ['bottom-right'] = true,
}

local function resolveOwner(rawOwner)
    local invoking <const> = GetInvokingResource()

    if invoking and invoking ~= '' then
        rawOwner = invoking
    end

    if type(rawOwner) ~= 'string' or rawOwner == '' then
        rawOwner = GetCurrentResourceName()
    end

    return client.makeOwner(rawOwner)
end

local function normalizeOffset(offset)
    offset = type(offset) == 'table' and offset or {}

    return {
        x = type(offset.x) == 'number' and offset.x or 0,
        y = type(offset.y) == 'number' and offset.y or 0,
    }
end

local function normalizeItems(items)
    if type(items) ~= 'table' or #items == 0 then
        error('kura-ui controls require a non-empty items array.', 3)
    end

    local normalized = {}

    for index = 1, #items do
        local item <const> = items[index]

        if type(item) ~= 'table' then
            error(('kura-ui control item #%d must be a table.'):format(index), 3)
        end

        if type(item.input) ~= 'string' or item.input == '' then
            error(('kura-ui control item #%d requires a non-empty input string.'):format(index), 3)
        end

        if type(item.label) ~= 'string' or item.label == '' then
            error(('kura-ui control item #%d requires a non-empty label string.'):format(index), 3)
        end

        normalized[index] = {
            input = item.input,
            label = item.label,
        }
    end

    return normalized
end

local function normalizeAnchor(anchor)
    if type(anchor) == 'string' and validAnchors[anchor] then
        return anchor
    end

    return 'bottom-right'
end

local function normalizeOrientation(orientation)
    if orientation == 'column' then
        return 'column'
    end

    return 'row'
end

local function makeGeneratedId(owner)
    local nextValue <const> = client.nextSequence()
    return ('controls:%s:%d'):format(owner:gsub('[^%w%-_]', '_'), nextValue)
end

local function createNode(owner, data)
    local id = data.id

    if type(id) ~= 'string' or id == '' then
        id = makeGeneratedId(owner)
    end

    return {
        key = client.makeKey(owner, 'controls', id),
        owner = owner,
        feature = 'controls',
        id = id,
        layer = 'hud',
        anchor = normalizeAnchor(data.anchor),
        offset = normalizeOffset(data.offset),
        order = type(data.order) == 'number' and data.order or 100,
        sequence = client.nextSequence(),
        payload = {
            orientation = normalizeOrientation(data.orientation),
            items = normalizeItems(data.items),
        }
    }
end

local function mergeNode(existing, patch)
    local merged = {
        id = existing.id,
        anchor = patch.anchor ~= nil and patch.anchor or existing.anchor,
        offset = patch.offset ~= nil and patch.offset or existing.offset,
        order = patch.order ~= nil and patch.order or existing.order,
        orientation = patch.orientation ~= nil and patch.orientation or existing.payload.orientation,
        items = patch.items ~= nil and patch.items or existing.payload.items,
    }

    local updated = createNode(existing.owner, merged)
    updated.id = existing.id
    updated.key = existing.key
    return updated
end

function client.controlsShow(rawOwner, data)
    local owner <const> = resolveOwner(rawOwner)
    local node <const> = createNode(owner, data)
    client.upsertNode(node)
    return node.id
end

function client.controlsUpdate(rawOwner, id, patch)
    local owner <const> = resolveOwner(rawOwner)

    if type(id) ~= 'string' or id == '' then
        error('kura-ui controls.update requires a non-empty id.', 3)
    end

    if type(patch) ~= 'table' then
        error('kura-ui controls.update requires a patch table.', 3)
    end

    local key <const> = client.makeKey(owner, 'controls', id)
    local existing <const> = client.getNode(key)

    if not existing then
        return false
    end

    local updated <const> = mergeNode(existing, patch)
    client.upsertNode(updated)
    return true
end

function client.controlsHide(rawOwner, id)
    local owner <const> = resolveOwner(rawOwner)

    if type(id) ~= 'string' or id == '' then
        error('kura-ui controls.hide requires a non-empty id.', 3)
    end

    local key <const> = client.makeKey(owner, 'controls', id)
    return client.removeNode(key)
end

function client.controlsClear(rawOwner)
    local owner <const> = resolveOwner(rawOwner)
    client.clearOwner(owner)
end

function client.controlsExists(rawOwner, id)
    local owner <const> = resolveOwner(rawOwner)

    if type(id) ~= 'string' or id == '' then
        return false
    end

    local key <const> = client.makeKey(owner, 'controls', id)
    return client.getNode(key) ~= nil
end

RegisterNetEvent('kura-ui:server:controlsShow', function(owner, data)
    local node <const> = createNode(owner, data)
    client.upsertNode(node)
end)

RegisterNetEvent('kura-ui:server:controlsUpdate', function(owner, id, patch)
    local key <const> = client.makeKey(owner, 'controls', id)
    local existing <const> = client.getNode(key)

    if not existing then
        return
    end

    local updated <const> = mergeNode(existing, patch)
    client.upsertNode(updated)
end)

RegisterNetEvent('kura-ui:server:controlsHide', function(owner, id)
    local key <const> = client.makeKey(owner, 'controls', id)
    client.removeNode(key)
end)

RegisterNetEvent('kura-ui:server:controlsClearOwner', function(owner)
    client.clearOwner(owner)
end)
