-- Server-side interiors management

RegisterNetEvent('dashboard:requestInteriors')
AddEventHandler('dashboard:requestInteriors', function()
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId then return end

    local interiors = MySQL.Sync.fetchAll([[
        SELECT interiorId, name, type, locked, posX, posY, posZ
        FROM interiors
        WHERE owner = ?
        ORDER BY interiorId ASC
    ]], { charId })

    local limit = MySQL.Sync.fetchScalar('SELECT interiorsSlot FROM characters WHERE characterId = ?', { charId }) or 3

    local processed = {}
    for _, inti in ipairs(interiors or {}) do
        table.insert(processed, {
            interiorId = inti.interiorId,
            name = inti.name or 'Ismeretlen',
            type = inti.type or 'house',
            locked = inti.locked == 1,
            coords = { x = inti.posX or 0, y = inti.posY or 0, z = inti.posZ or 0 },
        })
    end

    TriggerClientEvent('dashboard:receiveInteriors', src, processed, limit)
end)

-- Buy interior slot
RegisterNetEvent('dashboard:buyInteriorSlot')
AddEventHandler('dashboard:buyInteriorSlot', function(amount)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId then return end

    amount = tonumber(amount) or 1
    if amount < 1 then return end

    local totalCost = amount * Config.InteriorSlotPrice
    local pp = GetPlayerPremiumPoints(src)

    if pp < totalCost then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Nincs eleg RealCoinod!')
        return
    end

    local accountId = GetPlayerAccountId(src)
    MySQL.Async.execute('UPDATE accounts SET realcoins = realcoins - ? WHERE accountId = ?',
        { totalCost, accountId })
    MySQL.Async.execute('UPDATE characters SET interiorsSlot = interiorsSlot + ? WHERE characterId = ?',
        { amount, charId })

    TriggerClientEvent('dashboard:updatePremiumBalance', src, pp - totalCost)
    TriggerClientEvent('dashboard:notify', src, 'success', 'Sikeres vasarlas! ' .. amount .. ' interior slot hozzaadva.')
end)

-- Mark interior on GPS
RegisterNetEvent('dashboard:markInteriorGPS')
AddEventHandler('dashboard:markInteriorGPS', function(interiorId)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId or not interiorId then return end

    local result = MySQL.Sync.fetchAll('SELECT posX, posY, posZ FROM interiors WHERE interiorId = ? AND owner = ?',
        { interiorId, charId })

    if result and result[1] then
        TriggerClientEvent('dashboard:interiorGPSMark', src, {
            x = result[1].posX,
            y = result[1].posY,
            z = result[1].posZ,
        })
        TriggerClientEvent('dashboard:notify', src, 'info', 'Interior megjelolve a terkepen!')
    end
end)
