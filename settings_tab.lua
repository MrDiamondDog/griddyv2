local controller = require("controller")
local vaults = require("vaults")
local events = require("events")

local function initSettingsTab(tab)
    tab:addLabel():setText("Vaults"):setPosition(2, 2)
    local vaultsList = tab:addList():setSize(15, 6):setPosition(2, 3):setBackground(colors.gray):setForeground(colors.white):setSelectionColor(colors.lightGray, colors.white)

    for i = 1, controller.numVaults do
        vaultsList:addItem("Vault " .. i .. "   " .. #vaults.getItems(i))
    end

    tab:addButton():setText("+"):setPosition(2, 9):setSize(7, 1):onClick(function()
        controller.numVaults = controller.numVaults + 1
        vaultsList:addItem("Vault " .. controller.numVaults .. "   0")
        local file = fs.open("vault_cache/"..controller.numVaults, "w")
        file.close()

        events.callHandlers(events.vaultsChangedHandlers)
    end)

    tab:addButton():setText("-"):setPosition(10, 9):setSize(7, 1):onClick(function()
        if controller.numVaults > 1 then
            controller.numVaults = controller.numVaults - 1
            vaultsList:removeItem(vaultsList:getItemIndex())
            fs.delete("vault_cache/"..controller.numVaults + 1)

            events.callHandlers(events.vaultsChangedHandlers)
        end
    end)
end

return initSettingsTab