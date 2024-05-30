local controller = require("controller")
local vaults = require("vaults")
local events = require("events")
local frame = require("frame")

local inEvent = false

local function initControlsTab(tab)
    local pusherLock = tab:addCheckbox():setText("Pusher Lock"):setPosition(2, 2):setChecked(controller.pusherLockState):onChange(function(self)
        if controller.working() and not inEvent then
            self:setChecked(controller.pusherLockState)
            return
        end

        local checked = self:getValue()
        controller.setPusherLock(checked)
    end)

    local grabberLock = tab:addCheckbox():setText("Grabber Lock"):setPosition(2, 4):setChecked(controller.grabberLockState):onChange(function(self)
        if controller.working() and not inEvent then
            self:setChecked(controller.pusherLockState)
            return
        end

        local checked = self:getValue()
        controller.setGrabberLock(checked)
    end)

    local chassisLock = tab:addCheckbox():setText("Chassis Lock"):setPosition(2, 6):setChecked(controller.chassisLockState):onChange(function(self)
        if controller.working() and not inEvent then
            self:setChecked(controller.pusherLockState)
            return
        end

        local checked = self:getValue()
        controller.setChassisLock(checked)
    end)

    tab:addLabel():setText("Chassis Direction"):setPosition(2, 8)
    tab:addLabel():setText("Hand Direction"):setPosition(2, 12)

    local chassisDir = tab:addRadio():setPosition(2, 10):addItem("Out", 2, 0):addItem("In", 2, 1):onChange(function(self)
        if controller.working() then
            if controller.chassisDirectionState == controller.directionOut then
                self:selectItem(1)
            else
                self:selectItem(2)
            end
            return
        end

        local value = self:getItemIndex()
        if value == 1 then
            controller.setChassisDirection(controller.directionOut)
        else
            controller.setChassisDirection(controller.directionIn)
        end
    end)

    local handDir = tab:addRadio():setPosition(2, 14):addItem("Out", 2, 0):addItem("In", 2, 1):onChange(function(self)
        if controller.working() then
            if controller.handDirectionState == controller.directionOut then
                self:selectItem(1)
            else
                self:selectItem(2)
            end
            return
        end

        local value = self:getItemIndex()
        if value == 1 then
            controller.setHandDirection(controller.directionOut)
        else
            controller.setHandDirection(controller.directionIn)
        end
    end)

    events.onControllerStateChanged(function(state)
        -- frame.debug(tostring(state.pusherLock) .. " " .. tostring(state.grabberLock) .. " " .. tostring(state.chassisLock) .. " " .. tostring(state.chassisDirection) .. " " .. tostring(state.handDirection))
        inEvent = true
        pusherLock:setChecked(state.pusherLock)
        grabberLock:setChecked(state.grabberLock)
        chassisLock:setChecked(state.chassisLock)
        inEvent = false

        if state.chassisDirection == controller.directionOut then
            chassisDir:selectItem(1)
        else
            chassisDir:selectItem(2)
        end

        if state.handDirection == controller.directionOut then
            handDir:selectItem(1)
        else
            handDir:selectItem(2)
        end
    end)


    tab:addLabel():setText("Vaults"):setPosition(21, 2)

    local selectedVault = 1
    local vaultSelection = tab:addRadio():setPosition(21, 4):onChange(function(self)
        selectedVault = self:getItemIndex()
    end)

    for i = 1, controller.numVaults do
        vaultSelection:addItem("Vault "..i, 2, i - 1)
    end

    events.onVaultsChanged(function()
        vaultSelection:clear()
        for i = 1, controller.numVaults do
            vaultSelection:addItem("Vault "..i, 2, i - 1)
        end
    end)

    tab:addButton():setText("Grab"):setPosition(32, 2):setSize(8, 3):onClick(function(self)
        if controller.working() then return end

        controller.grabVault(selectedVault - 1)
    end)
    tab:addButton():setText("Return"):setPosition(41, 2):setSize(8, 3):onClick(function(self)
        if controller.working() then return end

        controller.returnVault(selectedVault - 1)
    end)

    tab:addButton():setText("Index"):setPosition(32, 6):setSize(17, 3):onClick(function(self)
        if controller.working() then return end

        controller.grabVault(selectedVault - 1)
        vaults.saveItems(selectedVault)
        controller.returnVault(selectedVault - 1)
    end)

    tab:addButton():setText("Empty Chest"):setPosition(32, 10):setSize(17, 3):onClick(function(self)
        if controller.working() or controller.getCurrentVault() == 0 then return end

        local vault = peripheral.wrap(vaults.vaultSide)
        local chest = peripheral.wrap(vaults.chestSide)
        for i = 1, chest.size() do
            vault.pullItems(vaults.chestSide, i)
        end
        vaults.saveItems(controller.getCurrentVault())
    end)
end

return initControlsTab