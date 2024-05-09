local controller = require("controller")
local vaults = require("vaults")

local function initVaultsTab(tab)
    local items = 0
    local vaultItems = {}
    for i = 1, controller.numVaults do
        vaultItems[i] = vaults.getItems(i)
        for j = 1, #vaultItems[i] do
            items = items + vaultItems[i][j].count
        end
    end

    tab:addLabel():setText("Total Items: " .. items):setPosition(2, 2)
    tab:addLabel():setText("Total Vaults: " .. controller.numVaults):setPosition(2, 3)
    tab:addLabel():setText("Vault Capacity"):setPosition(2, 5)

    for i = 1, controller.numVaults do
        tab:addLabel():setText(i):setPosition(3, i * 2 + 5)
        tab:addVisualObject():setBackground(colors.lightGray):setSize(15, 1):setPosition(5, i * 2 + 5)
        tab:addVisualObject():setBackground(colors.green):setSize(15 / (1620 / #vaultItems[i]), 1):setPosition(5, i * 2 + 5)
        tab:addLabel():setText(#vaultItems[i] .. "/1620"):setPosition(6, i * 2 + 5)
    end
end

return initVaultsTab