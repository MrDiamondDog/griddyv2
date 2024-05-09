local main = require("frame")
local events = require("events")

local function distanceToRotationDuration(speed, distance)
    return (math.ceil(distance / (speed / 512)) + 2) / 20
end

local numVaults = fs.exists("vault_cache") and #fs.list("vault_cache") or 0
local currentVault = 0

local controllerThread = main.frame:addThread()

local controller = peripheral.wrap("top")

local directionOut = true
local directionIn = false

local pusherLockState = true
local grabberLockState = true
local chassisLockState = true
local handDirectionState = directionIn
local chassisDirectionState = directionIn

local function working()
    return controllerThread:getStatus() == "running" or controllerThread:getStatus() == "suspended"
end

local function emitEvent()
    events.callHandlers(events.controllerStateHandlers, {
        pusherLock = pusherLockState,
        grabberLock = grabberLockState,
        chassisLock = chassisLockState,
        handDirection = handDirectionState,
        chassisDirection = chassisDirectionState
    })
end

local function setPusherLock(state)
    controller.setOutput("top", state)
    pusherLockState = state
end

local function setHandDirection(dir)
    controller.setOutput("right", not dir)
    handDirectionState = not dir
end

local function setGrabberLock(state)
    controller.setOutput("back", state)
    grabberLockState = state
end

local function setChassisDirection(dir)
    controller.setOutput("left", not dir)
    chassisDirectionState = not dir
end

local function setChassisLock(state)
    controller.setOutput("front", state)
    chassisLockState = state
end

local function reset()
    controllerThread:start(function()
        setHandDirection(directionIn)
        setPusherLock(false)
        setGrabberLock(false)
        emitEvent()
        sleep(5)
        setPusherLock(true)
        setGrabberLock(true)

        setChassisDirection(directionIn)
        setChassisLock(false)
        emitEvent()
        sleep(5)
        setChassisLock(true)
        emitEvent()
    end)
end

local function grabVault(index, thencb)
    controllerThread:start(function()
        setGrabberLock(true)
        setPusherLock(true)
        setChassisLock(true)

        local duration = distanceToRotationDuration(128, index * 3 + 3)

        setChassisDirection(directionOut)
        setChassisLock(false)
        emitEvent()
        sleep(duration)
        setChassisLock(true)

        setHandDirection(directionOut)
        setGrabberLock(false)
        emitEvent()
        sleep(2)
        setHandDirection(directionIn)
        emitEvent()
        sleep(2)
        setGrabberLock(true)

        setChassisDirection(directionIn)
        setChassisLock(false)
        emitEvent()
        sleep(duration)
        setChassisLock(true)

        setHandDirection(directionOut)
        setPusherLock(false)
        emitEvent()
        sleep(2)
        setHandDirection(directionIn)
        emitEvent()
        sleep(2)
        setPusherLock(true)
        emitEvent()

        currentVault = index + 1

        if thencb then
            thencb()
        end
    end)
end

local function returnVault(index, thencb)
    controllerThread:start(function()
        setGrabberLock(true)
        setPusherLock(true)
        setChassisLock(true)

        local duration = distanceToRotationDuration(128, index * 3 + 3)

        setHandDirection(directionOut)
        setGrabberLock(false)
        emitEvent()
        sleep(2)
        setHandDirection(directionIn)
        emitEvent()
        sleep(2)
        setGrabberLock(true)

        setChassisDirection(directionOut)
        setChassisLock(false)
        emitEvent()
        sleep(duration)
        setChassisLock(true)

        setHandDirection(directionOut)
        setPusherLock(false)
        emitEvent()
        sleep(2)
        setHandDirection(directionIn)
        emitEvent()
        sleep(2)
        setPusherLock(true)

        setChassisDirection(directionIn)
        setChassisLock(false)
        emitEvent()
        sleep(duration)
        setChassisLock(true)
        emitEvent()

        currentVault = 0
        
        if thencb then
            thencb()
        end
    end)
end

return {
    setPusherLock = setPusherLock,
    setHandDirection = setHandDirection,
    setGrabberLock = setGrabberLock,
    setChassisDirection = setChassisDirection,
    setChassisLock = setChassisLock,
    grabVault = grabVault,
    returnVault = returnVault,
    reset = reset,
    distanceToRotationDuration = distanceToRotationDuration,

    working = working,
    currentVault = currentVault,
    numVaults = numVaults,
    directionIn = directionIn,
    directionOut = directionOut,
    pusherLockState = pusherLockState,
    grabberLockState = grabberLockState,
    chassisLockState = chassisLockState,
    handDirectionState = handDirectionState,
    chassisDirectionState = chassisDirectionState
}