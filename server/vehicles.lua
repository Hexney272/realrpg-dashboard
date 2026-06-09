-- Server-side vehicle management

RegisterNetEvent('dashboard:requestVehicles')
AddEventHandler('dashboard:requestVehicles', function()
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId then return end

    local vehicles = MySQL.Sync.fetchAll([[
        SELECT
            v.dbID as vehicleId,
            v.modelId as model,
            v.plate,
            v.distance as odometer,
            v.impounded,
            v.inService,
            v.fuelType,
            v.fuelLevel,
            v.driveType,
            v.health,
            v.color,
            v.performanceTuning,
            v.customModel
        FROM vehicles
        WHERE v.characterId = ?
        ORDER BY v.dbID ASC
    ]], { charId })

    local limit = MySQL.Sync.fetchScalar('SELECT vehiclesSlot FROM characters WHERE characterId = ?', { charId }) or 5

    -- Process vehicles data
    local processedVehicles = {}
    for i, veh in ipairs(vehicles or {}) do
        table.insert(processedVehicles, {
            vehicleId = veh.vehicleId,
            model = veh.model,
            name = GetVehicleDisplayName(veh.customModel or veh.model),
            plate = veh.plate or '',
            odometer = veh.odometer or 0,
            impounded = veh.impounded and veh.impounded > 0,
            inService = veh.inService,
            fuelType = veh.fuelType or 'petrol',
            fuelLevel = veh.fuelLevel or 0,
            driveType = veh.driveType or 'FWD',
            health = veh.health or 1000,
        })
    end

    TriggerClientEvent('dashboard:receiveVehicles', src, processedVehicles, limit)
end)

-- Mark vehicle on GPS
RegisterNetEvent('dashboard:markVehicleGPS')
AddEventHandler('dashboard:markVehicleGPS', function(vehicleId)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId or not vehicleId then return end

    -- Find the vehicle entity in the world
    local vehicles = GetAllVehicles()
    for _, veh in ipairs(vehicles) do
        local state = Entity(veh).state
        if state and state.dbId == vehicleId then
            local coords = GetEntityCoords(veh)
            TriggerClientEvent('dashboard:vehicleGPSMark', src, { x = coords.x, y = coords.y, z = coords.z })
            TriggerClientEvent('dashboard:notify', src, 'info', 'A jarmuved megjelolve a terkepen!')
            return
        end
    end

    -- If not spawned, get from DB
    local result = MySQL.Sync.fetchAll('SELECT posX, posY, posZ FROM vehicles WHERE dbID = ? AND characterId = ?', { vehicleId, charId })
    if result and result[1] then
        local coords = { x = result[1].posX, y = result[1].posY, z = result[1].posZ }
        TriggerClientEvent('dashboard:vehicleGPSMark', src, coords)
        TriggerClientEvent('dashboard:notify', src, 'info', 'A jarmuved megjelolve a terkepen! (Garazsban)')
    else
        TriggerClientEvent('dashboard:notify', src, 'error', 'Nem talalhato a jarmuveid kozott!')
    end
end)

-- Buy vehicle slot
RegisterNetEvent('dashboard:buyVehicleSlot')
AddEventHandler('dashboard:buyVehicleSlot', function(amount)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId then return end

    amount = tonumber(amount) or 1
    if amount < 1 then return end

    local totalCost = amount * Config.VehicleSlotPrice
    local pp = GetPlayerPremiumPoints(src)

    if pp < totalCost then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Nincs eleg PremiumPontod!')
        return
    end

    -- Deduct PP
    MySQL.Async.execute('UPDATE accounts SET premiumPoints = premiumPoints - ? WHERE accountId = ?',
        { totalCost, GetPlayerAccountId(src) })

    -- Add slots
    MySQL.Async.execute('UPDATE characters SET vehiclesSlot = vehiclesSlot + ? WHERE characterId = ?',
        { amount, charId })

    -- Refresh
    local newBalance = pp - totalCost
    TriggerClientEvent('dashboard:updatePremiumBalance', src, newBalance)
    TriggerClientEvent('dashboard:notify', src, 'success', 'Sikeres vasarlas! ' .. amount .. ' slot hozzaadva.')

    -- Resend vehicle list
    TriggerEvent('dashboard:requestVehicles')
end)

-- Sell vehicle
RegisterNetEvent('dashboard:sellVehicle')
AddEventHandler('dashboard:sellVehicle', function(vehicleId, targetServerId, price)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId or not vehicleId then return end

    price = tonumber(price) or 0
    if price < 1 then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A minimum eladasi ar 1$.')
        return
    end

    local targetSrc = tonumber(targetServerId)
    if not targetSrc or not GetPlayerName(targetSrc) then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A celjatek nincs online!')
        return
    end

    -- Check distance
    local myPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetSrc)
    local myCoords = GetEntityCoords(myPed)
    local targetCoords = GetEntityCoords(targetPed)
    local dist = #(myCoords - targetCoords)

    if dist > 5.0 then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A kiválasztott jatekos tul tavol van!')
        return
    end

    -- Verify ownership
    local ownerCheck = MySQL.Sync.fetchScalar('SELECT characterId FROM vehicles WHERE dbID = ?', { vehicleId })
    if ownerCheck ~= charId then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Ez nem a te jarmuved!')
        return
    end

    -- Transfer vehicle
    local targetCharId = GetPlayerCharacterId(targetSrc)
    if not targetCharId then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A celjatek nincs bejelentkezve!')
        return
    end

    MySQL.Async.execute('UPDATE vehicles SET characterId = ? WHERE dbID = ?', { targetCharId, vehicleId })

    -- Handle money transfer (adapt to your economy)
    -- GivePlayerMoney(src, price)
    -- TakePlayerMoney(targetSrc, price)

    TriggerClientEvent('dashboard:notify', src, 'success', 'Jarmu sikeresen eladva!')
    TriggerClientEvent('dashboard:notify', targetSrc, 'success', 'Kaptal egy uj jarmuvet!')
end)

-- Helper: Get vehicle display name
function GetVehicleDisplayName(model)
    if not model then return 'Ismeretlen' end
    -- In FiveM you'd use GetDisplayNameFromVehicleModel on client
    -- On server, you might maintain a lookup table or just return the model name
    return tostring(model)
end
