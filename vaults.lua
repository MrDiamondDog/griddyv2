local controller = require("controller")
local strutils = require("strutils")
local events = require("events")

local vaultSide = "back"
local chestSide = "left"

local function getItems(vault)
    if vault > controller.numVaults or vault <= 0 then
        return 0
    end

    local file = fs.open("vault_cache/"..vault, "r")

    local items = {}
    local i = 1
    for item in file.readLine do
        local split = strutils.split(item, ":")
        local slot = tonumber(split[1])
        local name = split[2]
        local count = tonumber(split[3])
        items[i] = {slot = slot, item = name, count = count, vault = vault}

        i = i + 1
    end
    file.close()

    return items
end

local function getAllItems()
    local items = {}
    for i = 1, controller.numVaults do
        local vaultItems = getItems(i)
        for j = 1, #vaultItems do
            items[#items + 1] = vaultItems[j]
        end
    end

    return items
end

local function getItemsLocal(vault)
    if vault > controller.numVaults or vault <= 0 then
        return 0
    end

    local vaultapi = peripheral.wrap(vaultSide)
    local list = vaultapi.list()
    local items = {}
    local count = 1
    for i = 1, vaultapi.size() do
        if not list[i] then
            goto continue
        end

        local item = vaultapi.getItemDetail(i)
        if item then
            items[count] = {slot = i, item = item.displayName, count = item.count, vault = vault}
        end

        count = count + 1
        ::continue::
    end

    return items
end

local function saveItems(vault)
    if vault > controller.numVaults or vault <= 0 then
        return
    end

    local items = getItemsLocal(vault)
    local serialized = ""
    for i = 1, #items do
        local item = items[i]
        serialized = serialized..item.slot..":"..item.item..":"..item.count.."\n"
    end

    local file = fs.open("vault_cache/"..vault, "w")
    file.write(serialized)
    file.close()

    events.callHandlers(events.vaultsChangedHandlers)
end

local function retrieveItem(slot)
    local vault = peripheral.wrap(vaultSide)
    local item = vault.getItemDetail(slot)
    if not item then return end

    vault.pushItems(chestSide, slot)
end

return {
    getItems = getItems,
    getItemsLocal = getItemsLocal,
    getAllItems = getAllItems,
    saveItems = saveItems,
    retrieveItem = retrieveItem,
    vaultSide = vaultSide,
    chestSide = chestSide
}