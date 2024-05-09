local basalt = require("basalt")
local main = require("frame")
local controller = require("controller")
local initControlsTab = require("controls_tab")
local initVaultsTab = require("vaults_tab")
local initItemsTab = require("items_tab")
local initSettingsTab = require("settings_tab")

fs.makeDir("vault_cache")

controller.setPusherLock(true)
controller.setGrabberLock(true)
controller.setChassisLock(true)
controller.setChassisDirection(controller.DirectionOut)
controller.setHandDirection(controller.DirectionOut)

local tabs = {
    main.frame:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"),
    main.frame:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
    main.frame:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
    main.frame:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide()
}

local function openTab(id)
    if(tabs[id]~=nil)then
        for k,v in pairs(tabs)do
            v:hide()
        end
        tabs[id]:show()
    end
end

local menubar = main.frame:addMenubar():setScrollable()
    :setSize("parent.w")
    :onChange(function(self, val)
        openTab(self:getItemIndex())
    end)
    :addItem("Vaults")
    :addItem("Items")
    :addItem("Controls")
    :addItem("Options")


initVaultsTab(tabs[1])
initItemsTab(tabs[2])
initControlsTab(tabs[3])
initSettingsTab(tabs[4])

basalt.autoUpdate()