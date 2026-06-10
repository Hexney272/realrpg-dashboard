-- ============================================
-- RealRPG Dashboard - Vehicles
-- ESX Legacy - owned_vehicles tábla
-- ============================================

ESX = exports['es_extended']:getSharedObject()

-- ============================================
-- REQUEST VEHICLES
-- ============================================
RegisterNetEvent('dashboard:requestVehicles')
AddEventHandler('dashboard:requestVehicles', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()

    -- ESX Legacy owned_vehicles tábla
    local vehicles = MySQL.Sync.fetchAll([[
        SELECT owner, plate, vehicle, type, job, stored
        FROM owned_vehicles
        WHERE owner = ?
        ORDER BY plate ASC
    ]], { identifier })

    -- Get vehicle slot limit (custom field, default 5)
    local limit = MySQL.Sync.fetchScalar('SELECT vehicle_slots FROM users WHERE identifier = ?', { identifier }) or 5

    local processedVehicles = {}
    for _, veh in ipairs(vehicles or {}) do
        -- Parse the vehicle JSON (ESX stores vehicle data as JSON)
        local vehicleData = json.decode(veh.vehicle) or {}
        local model = vehicleData.model or 0
        local plate = veh.plate or ''
        local fuelLevel = vehicleData.fuelLevel or 65
        local bodyHealth = vehicleData.bodyHealth or 1000
        local engineHealth = vehicleData.engineHealth or 1000

        -- Get vehicle name from model hash
        local modelName = GetVehicleModelName(model)

        -- Check if vehicle is in garage or impounded
        local stored = veh.stored or 0 -- 0 = out, 1 = garage, 2 = impound

        -- Check if spawned in world
        local isSpawned = false
        local worldCoords = nil
        for _, worldVeh in ipairs(GetAllVehicles()) do
            if GetVehicleNumberPlateText(worldVeh) and string.gsub(GetVehicleNumberPlateText(worldVeh), '%s+', '') == string.gsub(plate, '%s+', '') then
                isSpawned = true
                local coords = GetEntityCoords(worldVeh)
                worldCoords = { x = coords.x, y = coords.y, z = coords.z }
                break
            end
        end

        -- Performance tuning from mods
        local mods = vehicleData.modEngine or 0
        local modTurbo = vehicleData.modTurbo and 1 or 0
        local modTransmission = vehicleData.modTransmission or 0
        local modSuspension = vehicleData.modSuspension or 0
        local modBrakes = vehicleData.modBrakes or 0

        table.insert(processedVehicles, {
            vehicleId = veh.plate, -- ESX uses plate as primary key
            model = model,
            name = modelName,
            plate = plate,
            odometer = vehicleData.distance or 0,
            fuelLevel = fuelLevel,
            fuelType = 'benzin',
            driveType = 'N/A',
            impounded = stored == 2,
            inGarage = stored == 1,
            isSpawned = isSpawned,
            worldCoords = worldCoords,
            bodyHealth = bodyHealth,
            engineHealth = engineHealth,
            job = veh.job or '',
            type = veh.type or 'car',
            -- Performance
            perfEngine = mods + 1, -- -1 to 3 in ESX, we normalize
            perfTurbo = modTurbo,
            perfTransmission = modTransmission + 1,
            perfSuspension = modSuspension + 1,
            perfBrakes = modBrakes + 1,
            -- Extras from vehicle data
            color1 = vehicleData.color1,
            color2 = vehicleData.color2,
            neonEnabled = vehicleData.neonEnabled,
            xenonColor = vehicleData.xenonColor,
            windowTint = vehicleData.windowTint,
            livery = vehicleData.modLivery,
        })
    end

    TriggerClientEvent('dashboard:receiveVehicles', src, processedVehicles, limit)
end)

-- ============================================
-- MARK VEHICLE ON GPS
-- ============================================
RegisterNetEvent('dashboard:markVehicleGPS')
AddEventHandler('dashboard:markVehicleGPS', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- Check if vehicle is spawned in world
    for _, veh in ipairs(GetAllVehicles()) do
        local vehPlate = GetVehicleNumberPlateText(veh)
        if vehPlate and string.gsub(vehPlate, '%s+', '') == string.gsub(plate, '%s+', '') then
            local coords = GetEntityCoords(veh)
            TriggerClientEvent('dashboard:vehicleGPSMark', src, { x = coords.x, y = coords.y, z = coords.z })
            TriggerClientEvent('dashboard:notify', src, 'info', 'Járműved megjelölve a térképen!')
            return
        end
    end

    -- Vehicle not spawned - check garage location
    local garageResult = MySQL.Sync.fetchAll('SELECT garage FROM owned_vehicles WHERE plate = ? AND owner = ?',
        { plate, xPlayer.getIdentifier() })

    if garageResult and garageResult[1] and garageResult[1].garage then
        -- Try to find garage coordinates from config
        -- This depends on your garage script (e.g., esx_vehicleshop garages)
        TriggerClientEvent('dashboard:notify', src, 'info', 'A jármű a garázsban van: ' .. (garageResult[1].garage or 'ismeretlen'))
    else
        TriggerClientEvent('dashboard:notify', src, 'error', 'A jármű nincs lespawnolva!')
    end
end)

-- ============================================
-- BUY VEHICLE SLOT
-- ============================================
RegisterNetEvent('dashboard:buyVehicleSlot')
AddEventHandler('dashboard:buyVehicleSlot', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    amount = tonumber(amount) or 1
    if amount < 1 or amount > 10 then return end

    local totalCost = amount * Config.VehicleSlotPrice
    local identifier = xPlayer.getIdentifier()
    local pp = MySQL.Sync.fetchScalar('SELECT realcoins FROM users WHERE identifier = ?', { identifier }) or 0

    if pp < totalCost then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Nincs elég RealCoinod!')
        return
    end

    MySQL.Async.execute('UPDATE users SET realcoins = realcoins - ?, vehicle_slots = vehicle_slots + ? WHERE identifier = ?',
        { totalCost, amount, identifier })

    local newBalance = pp - totalCost
    TriggerClientEvent('dashboard:updatePremiumBalance', src, newBalance)
    TriggerClientEvent('dashboard:notify', src, 'success', 'Sikeres vásárlás! +' .. amount .. ' jármű slot.')

    -- Re-send vehicle list with new limit
    TriggerEvent('dashboard:requestVehicles')
end)

-- ============================================
-- SELL VEHICLE TO PLAYER
-- ============================================
RegisterNetEvent('dashboard:sellVehicle')
AddEventHandler('dashboard:sellVehicle', function(plate, targetServerId, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    price = tonumber(price) or 0
    if price < 1 then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A minimum eladási ár 1$!')
        return
    end

    local targetSrc = tonumber(targetServerId)
    local xTarget = ESX.GetPlayerFromId(targetSrc)
    if not xTarget then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A céljátékos nincs online!')
        return
    end

    -- Distance check
    local myPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetSrc)
    local myCoords = GetEntityCoords(myPed)
    local targetCoords = GetEntityCoords(targetPed)

    if #(myCoords - targetCoords) > 5.0 then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A kiválasztott játékos túl távol van!')
        return
    end

    -- Check ownership
    local ownerCheck = MySQL.Sync.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate = ?', { plate })
    if ownerCheck ~= xPlayer.getIdentifier() then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Ez nem a te járműved!')
        return
    end

    -- Check buyer has enough money
    if xTarget.getMoney() < price then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A vevőnek nincs elég pénze!')
        return
    end

    -- Transfer
    MySQL.Async.execute('UPDATE owned_vehicles SET owner = ? WHERE plate = ?',
        { xTarget.getIdentifier(), plate })

    xTarget.removeMoney(price)
    xPlayer.addMoney(price)

    TriggerClientEvent('dashboard:notify', src, 'success', 'Jármű sikeresen eladva! Kaptál: $' .. FormatNumber(price))
    TriggerClientEvent('dashboard:notify', targetSrc, 'success', 'Vásároltál egy új járművet! (' .. plate .. ')')
end)

-- ============================================
-- HELPER: Get vehicle model name
-- ============================================
function GetVehicleModelName(modelHash)
    -- Common model hash to name mapping
    -- In production, use GetDisplayNameFromVehicleModel on client side and cache
    if not modelHash or modelHash == 0 then return 'Ismeretlen' end
    return tostring(modelHash)
end
