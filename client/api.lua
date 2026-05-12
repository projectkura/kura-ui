_ENV.__kura_ui = _ENV.__kura_ui or {}

local client <const> = __kura_ui.client

exports('controlsShow', function(owner, data)
    return client.controlsShow(owner, data)
end)

exports('controlsUpdate', function(owner, id, patch)
    return client.controlsUpdate(owner, id, patch)
end)

exports('controlsHide', function(owner, id)
    return client.controlsHide(owner, id)
end)

exports('controlsClear', function(owner)
    client.controlsClear(owner)
end)

exports('controlsExists', function(owner, id)
    return client.controlsExists(owner, id)
end)
