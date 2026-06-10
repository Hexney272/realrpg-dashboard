-- Server-side premium shop

RegisterNetEvent('dashboard:buyPremiumItem')
AddEventHandler('dashboard:buyPremiumItem', function(menuIndex, itemIndex, amount)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId then return end

    amount = tonumber(amount) or 1
    if amount < 1 then amount = 1 end

    -- Validate menu and item exist
    local menu = Config.PremiumShop[menuIndex]
    if not menu then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Ervenytelen menu!')
        return
    end

    local item = menu.items[itemIndex]
    if not item then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Ervenytelen item!')
        return
    end

    local totalCost = item.price * amount
    local pp = GetPlayerPremiumPoints(src)

    if pp < totalCost then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Nincs eleg RealCoinod!')
        return
    end

    -- Deduct PP
    local accountId = GetPlayerAccountId(src)
    MySQL.Async.execute('UPDATE accounts SET realcoins = realcoins - ? WHERE accountId = ?',
        { totalCost, accountId })

    -- Give item
    if item.item == 'money' then
        -- Give money (adapt to your economy system)
        local moneyAmount = (item.amount or 0) * amount
        -- GivePlayerMoney(src, moneyAmount)
        TriggerClientEvent('dashboard:notify', src, 'success', 'Sikeres vasarlas! Kaptal: $' .. FormatNumber(moneyAmount))
    else
        -- Give weapon or item (adapt to your inventory system)
        -- exports.ox_inventory:AddItem(src, item.item, amount)
        TriggerClientEvent('dashboard:notify', src, 'success', 'Sikeres vasarlas! ' .. amount .. 'x ' .. item.item)
    end

    -- Update balance on client
    TriggerClientEvent('dashboard:updatePremiumBalance', src, pp - totalCost)

    -- Log
    print(string.format('[PP Shop] %s (ID:%d) bought %dx %s for %d PP',
        GetPlayerName(src), src, amount, item.item, totalCost))
end)

-- Admin command to add premium points
RegisterCommand('addpremium', function(source, args, rawCommand)
    local src = source
    if src ~= 0 then
        -- Check admin permission (adapt to your system)
        local adminLevel = GetPlayerAdminLevel(src)
        if adminLevel < 6 then
            TriggerClientEvent('dashboard:notify', src, 'error', 'Nincs jogod ehhez!')
            return
        end
    end

    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])

    if not targetId or not amount then
        if src == 0 then
            print('[Usage] addpremium [server_id] [amount]')
        else
            TriggerClientEvent('dashboard:notify', src, 'error', 'Hasznalat: /addpremium [id] [mennyiseg]')
        end
        return
    end

    if not GetPlayerName(targetId) then
        local msg = 'A jatekos nincs online!'
        if src == 0 then print(msg) else TriggerClientEvent('dashboard:notify', src, 'error', msg) end
        return
    end

    GivePlayerPremiumPoints(targetId, amount)

    local msg = string.format('Hozzaadva %d PP jatek %s-nak.', amount, GetPlayerName(targetId))
    if src == 0 then
        print(msg)
    else
        TriggerClientEvent('dashboard:notify', src, 'success', msg)
    end
    TriggerClientEvent('dashboard:notify', targetId, 'success', 'Kaptal ' .. amount .. ' RealCoinot!')
end, true)
