local main = require("frame")
local events = require("events")

local speed = 256

local function distanceToRotationDuration(distance)
    local blocksToMove = distance + 4
    local metersPerTick = speed / 512
    local duration = math.ceil(blocksToMove / metersPerTick) + 2
    return duration / 20
end

local numVaults = fs.exists("vault_cache") and #fs.list("vault_cache") or 0

local controller = peripheral.wrap("top")

local directionOut = true
local directionIn = false

local pusherLockState = true
local grabberLockState = true
local chassisLockState = true
local handDirectionState = directionIn
local chassisDirectionState = directionIn

local function setCurrentVault(index)
    local file = fs.open("activeVault", "w")
    file.write(index)
    file.close()
end

local function getCurrentVault()
    local file = fs.open("activeVault", "r")
    local index = file.readAll()
    file.close()
    return tonumber(index)
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
    setHandDirection(directionIn)
    setPusherLock(false)
    setGrabberLock(false)
    sleep(5)
    setPusherLock(true)
    setGrabberLock(true)

    setChassisDirection(directionIn)
    setChassisLock(false)
    sleep(5)
    setChassisLock(true)
end

local function grabVault(index)
    setGrabberLock(true)
    setPusherLock(true)
    setChassisLock(true)

    local duration = distanceToRotationDuration(index * 3)

    setChassisDirection(directionOut)
    setChassisLock(false)
    sleep(duration)
    setChassisLock(true)

    setHandDirection(directionOut)
    setGrabberLock(false)
    sleep(2)
    setHandDirection(directionIn)
    sleep(2)
    setGrabberLock(true)

    setChassisDirection(directionIn)
    setChassisLock(false)
    sleep(duration)
    setChassisLock(true)

    setHandDirection(directionOut)
    setPusherLock(false)
    sleep(2)
    setHandDirection(directionIn)
    sleep(2)
    setPusherLock(true)

    setCurrentVault(index + 1)
end

local function returnVault(index)
    setGrabberLock(true)
    setPusherLock(true)
    setChassisLock(true)

    local duration = distanceToRotationDuration(index * 3)

    setHandDirection(directionOut)
    setGrabberLock(false)
    sleep(2)
    setHandDirection(directionIn)
    sleep(2)
    setGrabberLock(true)

    setChassisDirection(directionOut)
    setChassisLock(false)
    sleep(duration)
    setChassisLock(true)

    setHandDirection(directionOut)
    setPusherLock(false)
    sleep(2)
    setHandDirection(directionIn)
    sleep(2)
    setPusherLock(true)

    setChassisDirection(directionIn)
    setChassisLock(false)
    sleep(duration)
    setChassisLock(true)

    setCurrentVault(0)
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

    setCurrentVault = setCurrentVault,
    getCurrentVault = getCurrentVault,
    numVaults = numVaults,
    directionIn = directionIn,
    directionOut = directionOut,
    pusherLockState = pusherLockState,
    grabberLockState = grabberLockState,
    chassisLockState = chassisLockState,
    handDirectionState = handDirectionState,
    chassisDirectionState = chassisDirectionState
}
