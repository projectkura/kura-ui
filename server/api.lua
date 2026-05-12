_ENV.__kura_ui = _ENV.__kura_ui or {}

local server <const> = __kura_ui.server

exports('controlsShowFor', function(owner, targets, data)
    return server.controlsShowFor(owner, targets, data)
end)

exports('controlsUpdateFor', function(owner, targets, id, patch)
    return server.controlsUpdateFor(owner, targets, id, patch)
end)

exports('controlsHideFor', function(owner, targets, id)
    return server.controlsHideFor(owner, targets, id)
end)

exports('controlsClearFor', function(owner, targets)
    server.controlsClearFor(owner, targets)
end)
