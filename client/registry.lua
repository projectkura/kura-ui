_ENV.__kura_ui = _ENV.__kura_ui or {}

local state = __kura_ui
state.client = state.client or {}

local client = state.client
local resourceName <const> = GetCurrentResourceName()

client.registry = client.registry or {
    sequence = 0,
    nodes = {},
}

local registry = client.registry

local function nodeKey(owner, feature, id)
    return ('%s::%s::%s'):format(owner, feature, id)
end

function client.sendMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end

function client.nextSequence()
    registry.sequence = registry.sequence + 1
    return registry.sequence
end

function client.makeOwner(rawOwner)
    return ('client:%s'):format(rawOwner)
end

function client.makeKey(owner, feature, id)
    return nodeKey(owner, feature, id)
end

function client.upsertNode(node)
    registry.nodes[node.key] = node
    client.sendMessage('overlay:upsert', {
        node = node,
    })
end

function client.removeNode(key)
    if not registry.nodes[key] then
        return false
    end

    registry.nodes[key] = nil

    client.sendMessage('overlay:remove', {
        key = key,
    })

    return true
end

function client.getNode(key)
    return registry.nodes[key]
end

function client.clearOwner(owner)
    local hasChanges = false

    for key, node in pairs(registry.nodes) do
        if node.owner == owner then
            registry.nodes[key] = nil
            hasChanges = true
        end
    end

    if hasChanges then
        client.sendMessage('overlay:clearOwner', {
            owner = owner,
        })
    end
end

AddEventHandler('onClientResourceStop', function(stoppedResource)
    if stoppedResource == resourceName then
        return
    end

    client.clearOwner(client.makeOwner(stoppedResource))
end)

AddEventHandler('onClientResourceStart', function(startedResource)
    if startedResource ~= resourceName then
        return
    end

    client.sendMessage('overlay:reset', {})
end)
