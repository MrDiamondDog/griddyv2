local indexHandlers = {}
local function onIndex(handler)
    indexHandlers[#indexHandlers + 1] = handler
end

local vaultsChangedHandlers = {}
local function onVaultsChanged(handler)
    vaultsChangedHandlers[#vaultsChangedHandlers + 1] = handler
end

local controllerStateHandlers = {}
local function onControllerStateChanged(handler)
    controllerStateHandlers[#controllerStateHandlers + 1] = handler
end

local function callHandlers(handlers, ...)
    for i = 1, #handlers do
        handlers[i](...)
    end
end

return {
    onIndex = onIndex,
    onVaultsChanged = onVaultsChanged,
    callHandlers = callHandlers,
    vaultsChangedHandlers = vaultsChangedHandlers,
    indexHandlers = indexHandlers,
    onControllerStateChanged = onControllerStateChanged,
    controllerStateHandlers = controllerStateHandlers
}