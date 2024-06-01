local vaults = require("vaults")
-- local controller = require("controller")
local events = require("events")
local strutils = require("strutils")
local frame = require("frame")

local items = vaults.getAllItems()
local itemsRequested = {}

local function selectItem(item)
    if not item then return end
    for i = 1, #itemsRequested do
        if itemsRequested[i] == item then
            table.remove(itemsRequested, i)
            RequestsLabel:setText("Items Requested: " .. #itemsRequested)
            return
        end
    end

    itemsRequested[#itemsRequested + 1] = item
    RequestsLabel:setText("Items Requested: " .. #itemsRequested)
end

local function addItems(search)
    local header = Flex:addFrame():setSize("parent.w", 1):setPosition(1, 1)
    header:addLabel():setText("Item"):setPosition(2, 1)
    header:addLabel():setText("Count"):setPosition(35, 1)
    header:addLabel():setText("Vault"):setPosition(41, 1)

    local added = 0
    for i = 1, #items do
        if added >= 50 then break end
        if not search or search == "" or items[i].item:lower():find(search:lower()) then
            local row = Flex:addFrame():setSize("parent.w", 1):setPosition(1, i)

            row:setBackground(colors.gray)
            local found = false
            for j = 1, #itemsRequested do
                if itemsRequested[j] == items[i] then
                    found = true
                    break
                end
            end
            if not found then
                row:setBackground(colors.black)
            end

            row:addLabel():setText(items[i].item):setPosition(2, 1)
            row:addLabel():setText(items[i].count):setPosition(35, 1)
            row:addLabel():setText(items[i].vault):setPosition(41, 1)

            row:onClick(function()
                selectItem(items[i])
                row:setBackground(colors.gray)
                found = false
                for j = 1, #itemsRequested do
                    if itemsRequested[j] == items[i] then
                        found = true
                        break
                    end
                end
                if not found then
                    row:setBackground(colors.black)
                end
            end)

            added = added + 1
        end
    end
end

local function resetUI()
    FlexFrame:removeChildren()
    Flex = FlexFrame:addFlexbox():setSize("parent.w", "parent.h"):setDirection("column"):setSpacing(0)
end

local function requestItems()
    if #itemsRequested == 0 then return end

    table.sort(itemsRequested, function(a, b)
        return a.vault < b.vault
    end)

    local currentVault = 0

    for i = 1, #itemsRequested do
        -- if currentVault ~= itemsRequested[i].vault then
        --     if currentVault ~= 0 then
        --         vaults.saveItems(currentVault)
        --         controller.returnVault(currentVault - 1)
        --     end

        --     currentVault = itemsRequested[i].vault
        --     controller.grabVault(currentVault - 1)
        -- end

        vaults.retrieveItem(itemsRequested[i].slot)
    end

    vaults.saveItems(currentVault)
    -- controller.returnVault(currentVault - 1)

    itemsRequested = {}
    RequestsLabel:setText("Items Requested: " .. #itemsRequested)
end

local function initItemsTab(tab)
    FlexFrame = tab:addMovableFrame():setSize("parent.w", "parent.h - 7"):setPosition(1, 2)
    Flex = FlexFrame:addFlexbox():setSize("parent.w", "parent.h"):setDirection("column"):setSpacing(0)

    local search = ""

    tab:addInput():setSize("parent.w", 1):setDefaultText("Search..."):onChange(function(self)
        search = self:getValue()
        resetUI()
        addItems(search)
    end)

    local controlBar = tab:addFrame():setSize("parent.w", 6):setPosition(1, "parent.h - 5")
    RequestsLabel = controlBar:addLabel():setText("Items Requested: " .. #itemsRequested):setPosition(2, 2)
    controlBar:addButton():setText("Request Items"):setSize(15, 3):setPosition(2, 3):onClick(function()
        requestItems()
        search = ""
    end)

    -- controlBar:addButton():setText("Empty chest"):setSize(13, 3):setPosition(18, 3):onClick(function()
    --     -- find first empty vault
    --     local emptyVault = 0
    --     for i = 1, controller.numVaults do
    --         local file = fs.open("vault_cache/" .. i, "r")
    --         if #strutils.split(file.readAll(), "\n") < 1620 then
    --             emptyVault = i
    --             file.close()
    --             break
    --         end
    --         file.close()
    --     end

    --     -- frame.debug(emptyVault)

    --     if emptyVault == 0 then
    --         return
    --     end

    --     controller.grabVault(emptyVault - 1)

    --     local vault = peripheral.wrap(vaults.vaultSide)
    --     local chest = peripheral.wrap(vaults.chestSide)
    --     for i = 1, chest.size() do
    --         vault.pullItems(vaults.chestSide, i)
    --     end
    --     vaults.saveItems(emptyVault)
    --     controller.returnVault(emptyVault - 1)
    -- end)

    controlBar:addButton():setText("Refresh"):setSize(9, 3):setPosition(32, 3):onClick(function()
        items = vaults.getAllItems()
        resetUI()
        addItems(search)
    end)

    events.onIndex(function()
        items = vaults.getAllItems()
        resetUI()
        addItems(search)
    end)

    addItems()
end

return initItemsTab