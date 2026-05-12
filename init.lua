---@class KuraUIOffset
---@field x? number
---@field y? number

---@alias KuraUIAnchor
---| 'top-left'
---| 'top-center'
---| 'top-right'
---| 'center-left'
---| 'center'
---| 'center-right'
---| 'bottom-left'
---| 'bottom-center'
---| 'bottom-right'

---@alias KuraUIControlsOrientation
---| 'row'
---| 'column'

---@class KuraUIControlItem
---@field input string
---@field label string

---@class KuraUIControlSet
---@field id? string
---@field anchor? KuraUIAnchor
---@field offset? KuraUIOffset
---@field order? number
---@field orientation? KuraUIControlsOrientation
---@field items KuraUIControlItem[]

---@class KuraUIControlSetPatch
---@field anchor? KuraUIAnchor
---@field offset? KuraUIOffset
---@field order? number
---@field orientation? KuraUIControlsOrientation
---@field items? KuraUIControlItem[]

---@class KuraUIControlsClient
---@field show fun(data: KuraUIControlSet): string
---@field update fun(id: string, patch: KuraUIControlSetPatch): boolean
---@field hide fun(id: string): boolean
---@field clear fun(): nil
---@field exists fun(id: string): boolean

---@class KuraUIControlsServer
---@field showFor fun(targets: number|number[], data: KuraUIControlSet): string
---@field updateFor fun(targets: number|number[], id: string, patch: KuraUIControlSetPatch): boolean
---@field hideFor fun(targets: number|number[], id: string): boolean
---@field clearFor fun(targets: number|number[]): nil

---@class KuraUI
---@field controls KuraUIControlsClient|KuraUIControlsServer

if GetResourceState('kura-core') ~= 'started' then
    error('kura-ui must be started after kura-core.', 0)
end

local resourceName <const> = GetCurrentResourceName()
local isServer <const> = IsDuplicityVersion()
local proxyCache = {}

local function resolveOwner()
    return GetInvokingResource() or GetCurrentResourceName()
end

local function createClientProxy(owner)
    ---@type KuraUI
    return {
        controls = {
            show = function(data)
                return exports[resourceName]:controlsShow(owner, data)
            end,
            update = function(id, patch)
                return exports[resourceName]:controlsUpdate(owner, id, patch)
            end,
            hide = function(id)
                return exports[resourceName]:controlsHide(owner, id)
            end,
            clear = function()
                exports[resourceName]:controlsClear(owner)
            end,
            exists = function(id)
                return exports[resourceName]:controlsExists(owner, id)
            end,
        }
    }
end

local function createServerProxy(owner)
    ---@type KuraUI
    return {
        controls = {
            showFor = function(targets, data)
                return exports[resourceName]:controlsShowFor(owner, targets, data)
            end,
            updateFor = function(targets, id, patch)
                return exports[resourceName]:controlsUpdateFor(owner, targets, id, patch)
            end,
            hideFor = function(targets, id)
                return exports[resourceName]:controlsHideFor(owner, targets, id)
            end,
            clearFor = function(targets)
                exports[resourceName]:controlsClearFor(owner, targets)
            end,
        }
    }
end

exports('getInterface', function()
    local owner <const> = resolveOwner()
    local cached <const> = proxyCache[owner]

    if cached then
        return cached
    end

    local proxy <const> = isServer and createServerProxy(owner) or createClientProxy(owner)
    proxyCache[owner] = proxy
    return proxy
end)
