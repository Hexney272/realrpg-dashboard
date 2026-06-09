addEvent("buyPremiumItem", true)
addEventHandler("buyPremiumItem", getRootElement(), function(menuTab, selectedItem, amount)
    if client then
        local itemId, price, itemData1 = unpack(menus[menuTab].items[selectedItem])
        amount = tonumber(amount) or 1

        local function formatPlayerName(rawName)
            local parts = {}
            for part in string.gmatch(rawName, "[^_]+") do
                table.insert(parts, part)
            end
            if #parts >= 3 then
                return parts[1] .. " " .. parts[2]:sub(1, 1) .. " " .. parts[3]
            else
                return string.gsub(rawName, "_", " ")
            end
        end

        local visibleName = formatPlayerName(getElementData(client, "char.name") or getPlayerName(client))

        if tonumber(itemId) then
            if exports.sItems:getCurrentWeight(client) + exports.sItems:getItemWeight(itemId) * amount > exports.sItems:getWeightLimit("player", client) then
                exports.sGui:showInfobox(client, "e", "Nincs elég helyed!")
            else
                if exports.sCore:getPP(client) < price * amount then
                    exports.sGui:showInfobox(client, "e", "Nincs elég prémiumpontod!")
                    return
                end

                if exports.sCore:takePP(client, price * amount) then
                    local giveItem = exports.sItems:giveItem(client, itemId, amount, false, itemData1 or false)
                    exports.sGui:showInfobox(client, "s", "Sikeres vásárlás!")
                    
                    local itemName = exports.sItems:getItemName(itemId)
                    outputChatBox("[color=sightblue][WonderLife - Premium]: #FFFFFFVásároltál [color=sightblue]" .. amount .. " #FFFFFFdarab [color=sightblue]" .. itemName .. " #FFFFFFitemet #808080[" .. visibleName .. "]", client, 255, 255, 255, true)

                    if exports.sWeapons:getWeaponId(itemId) then
                        exports.sItems:giveItem(client, 583, 1, false, toJSON({
                            item = itemId,
                            serial = exports.sItems:formatSerial(itemId, exports.sItems:getLastWeaponSerial()),
                            buyer = string.gsub(getElementData(client, "char.name"), "_", " "),
                            acc = getElementData(client, "char.accID"),
                            price = price,
                            ts = getRealTime().timestamp
                        }, true))

                        exports.sAnticheat:sendWebhookMessage("**"..string.gsub(getElementData(client, "char.name"), "_", " ").. "** Vásárolt egy fegyvert a premiumshopból! **[ItemID: "..itemId.." | SERIAL: "..exports.sItems:formatSerial(itemId, exports.sItems:getLastWeaponSerial()).."]**", "premiumshop")
                    else
                        exports.sAnticheat:sendWebhookMessage("**"..string.gsub(getElementData(client, "char.name"), "_", " ").. "** Vásárolt egy tárgyat a prémiumshopból! **[Amount: "..amount.." | ItemID: "..itemId.."]**", "premiumshop")
                    end
                end
            end
        elseif itemId == "money" then
            if exports.sCore:getPP(client) < price * amount then
                exports.sGui:showInfobox(client, "e", "Nincs elég prémiumpontod!")
                return
            end

            if exports.sCore:takePP(client, price) then
                exports.sCore:giveMoney(client, amount)
                exports.sGui:showInfobox(client, "s", "Sikeres vásárlás!")
                
            end
        end
    end
end)

addCommandHandler("addpremium",
function (sourcePlayer, _, targetPlayer, packageID)
    if not exports.sPermission:hasPermission(sourcePlayer, "addPremium") then
        return
    end

    if not targetPlayer or not packageID then
        outputChatBox("[color=sightblue][WonderLife - Használat]: #ffffff/addpremium [Játékos Név / ID] [Csomag ID]", sourcePlayer, 255, 255, 255)
        outputChatBox("[color=sightblue][WonderLife - Használat]: #ffffff1: Ezüst(1100pp), 2:Arany(2200pp), 3:Gyémánt(6500pp), 4:Smaragd(22500pp).", sourcePlayer, 255, 255, 255)
        return
    end

    targetPlayer, targetName = exports.sCore:findPlayer(sourcePlayer, targetPlayer)
    if not targetPlayer then
        outputChatBox("[color=sightred][WonderLife]: #ffffffNem található játékos ezzel az ID-val!", sourcePlayer, 255, 0, 0)
        return
    end

    local packages = {
        [1] = {name = "Ezüst", points = 1100},
        [2] = {name = "Arany", points = 2200},
        [3] = {name = "Gyémánt", points = 6500},
        [4] = {name = "Smaragd", points = 22500}
    }

    local package = packages[tonumber(packageID)]
    if not package then
        outputChatBox("[color=sightred][WonderLife]: #ffffffÉrvénytelen csomag ID!", sourcePlayer, 255, 0, 0)
        return
    end

    local currentPP = getElementData(targetPlayer, "acc.premiumPoints") or 0
    local newPP = currentPP + package.points
    setElementData(targetPlayer, "acc.premiumPoints", newPP)

    triggerClientEvent(targetPlayer, "onPremiumPointsAdded", targetPlayer, package.name, package.points)

    local adminName = tostring(getElementData(sourcePlayer, "acc.adminNick"))
    local targetName = tostring(getElementData(targetPlayer, "visibleName"))

    ---local adminMessage = adminName .. " #ffffffhozzáadott " .. tostring(package.points) .. " prémium pontot " .. targetName .. " játékosnak '" .. package.name .. "' csomag."
    
    --exports.sAdministration:showAdminMessage(adminMessage)

    outputChatBox("[color=sightgreen][WonderLife]: #ffffffA '" .. package.name .. "' csomagot sikeresen hozzáadtad " .. targetName .. " játékosnak.", sourcePlayer, 255, 255, 255)

 
    local webhook = "https://discord.com/api/webhooks/1392047124073549895/iCKas5_tRLVJ3i6s0PmQI1Ew27ZzHbJqLHaNEr5jvgSF46cQL-T1jgO3cs91rrRJ4t40"
    local msg = "[LOG - PP Jóváirás] " .. adminName .. " hozzáadott '" .. package.name .. " (" .. package.points .. "pp)'" .. " prémium pontot " .. targetName .. " játékosnak."

    fetchRemote(webhook, {
        formFields = {
            content = msg
        }
    }, function(responseData)
    end)
end)