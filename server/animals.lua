-- Server-side animals/pets management

RegisterNetEvent('dashboard:requestAnimals')
AddEventHandler('dashboard:requestAnimals', function()
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId then return end

    local animals = MySQL.Sync.fetchAll([[
        SELECT animalId, name, type, health, hunger, love
        FROM animals
        WHERE ownerId = ?
        ORDER BY animalId ASC
    ]], { charId })

    TriggerClientEvent('dashboard:receiveAnimals', src, animals or {})
end)

-- Buy a new animal
RegisterNetEvent('dashboard:buyAnimal')
AddEventHandler('dashboard:buyAnimal', function(animalType, animalName)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId then return end

    if not animalName or #animalName < 1 then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Add meg a haziallat nevet!')
        return
    end

    -- Find animal price
    local animalData = nil
    for _, animal in ipairs(Config.AnimalsToBuy) do
        if animal.name == animalType then
            animalData = animal
            break
        end
    end

    if not animalData then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Ismeretlen allatfajta!')
        return
    end

    -- Check premium balance
    local pp = GetPlayerPremiumPoints(src)
    if pp < animalData.price then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Nincs eleg RealCoinod!')
        return
    end

    -- Deduct PP
    local accountId = GetPlayerAccountId(src)
    MySQL.Async.execute('UPDATE accounts SET realcoins = realcoins - ? WHERE accountId = ?',
        { animalData.price, accountId })

    -- Create animal
    MySQL.Async.execute([[
        INSERT INTO animals (ownerId, name, type, health, hunger, love)
        VALUES (?, ?, ?, 100, 100, 50)
    ]], { charId, animalName, animalType })

    TriggerClientEvent('dashboard:notify', src, 'success', 'Sikeresen megvasaroltad: ' .. animalName .. ' (' .. animalType .. ')!')
    TriggerClientEvent('dashboard:updatePremiumBalance', src, pp - animalData.price)

    -- Refresh animal list
    Wait(100)
    TriggerEvent('dashboard:requestAnimals')
end)

-- Spawn animal (create ped near player)
local spawnedAnimals = {} -- [src] = { entity, animalId }

RegisterNetEvent('dashboard:spawnAnimal')
AddEventHandler('dashboard:spawnAnimal', function(animalId)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId or not animalId then return end

    -- Check if player already has a spawned animal
    if spawnedAnimals[src] then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Elobb despawnold az aktiv allatod!')
        return
    end

    -- Verify ownership
    local animal = MySQL.Sync.fetchAll('SELECT * FROM animals WHERE animalId = ? AND ownerId = ?', { animalId, charId })
    if not animal or #animal == 0 then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Ez nem a te allatod!')
        return
    end

    -- Get animal model based on type
    local model = GetAnimalModel(animal[1].type)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)

    -- Spawn on client side
    TriggerClientEvent('dashboard:spawnAnimalPed', src, {
        animalId = animalId,
        model = model,
        coords = { x = coords.x + 1.0, y = coords.y + 1.0, z = coords.z },
        name = animal[1].name,
        health = animal[1].health,
    })

    spawnedAnimals[src] = animalId
    TriggerClientEvent('dashboard:notify', src, 'success', animal[1].name .. ' lespawnolva!')
end)

-- Despawn animal
RegisterNetEvent('dashboard:despawnAnimal')
AddEventHandler('dashboard:despawnAnimal', function(animalId)
    local src = source
    if spawnedAnimals[src] == animalId then
        TriggerClientEvent('dashboard:despawnAnimalPed', src, animalId)
        spawnedAnimals[src] = nil
        TriggerClientEvent('dashboard:notify', src, 'success', 'Allat despawnolva!')
    end
end)

-- Rename animal
RegisterNetEvent('dashboard:renameAnimal')
AddEventHandler('dashboard:renameAnimal', function(animalId, newName)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId or not animalId then return end

    if not newName or #newName < 1 or #newName > 32 then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A nev 1-32 karakter kozott legyen!')
        return
    end

    MySQL.Async.execute('UPDATE animals SET name = ? WHERE animalId = ? AND ownerId = ?',
        { newName, animalId, charId })

    TriggerClientEvent('dashboard:notify', src, 'success', 'Allat atnevezve: ' .. newName)
end)

-- Sell animal to player
RegisterNetEvent('dashboard:sellAnimal')
AddEventHandler('dashboard:sellAnimal', function(animalId, targetServerId, price)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId or not animalId then return end

    price = tonumber(price) or 0
    if price < 500 then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A minimum eladasi ar 500$!')
        return
    end

    local targetSrc = tonumber(targetServerId)
    if not targetSrc or not GetPlayerName(targetSrc) then
        TriggerClientEvent('dashboard:notify', src, 'error', 'A celjatek nincs online!')
        return
    end

    -- Check if animal is not spawned
    if spawnedAnimals[src] == animalId then
        TriggerClientEvent('dashboard:notify', src, 'error', 'Nem adhatod el lespawnolt allatot!')
        return
    end

    local targetCharId = GetPlayerCharacterId(targetSrc)
    if not targetCharId then return end

    -- Transfer ownership
    MySQL.Async.execute('UPDATE animals SET ownerId = ? WHERE animalId = ? AND ownerId = ?',
        { targetCharId, animalId, charId })

    TriggerClientEvent('dashboard:notify', src, 'success', 'Allat sikeresen eladva!')
    TriggerClientEvent('dashboard:notify', targetSrc, 'success', 'Kaptal egy uj haziallatot!')
end)

-- Cleanup on disconnect
AddEventHandler('playerDropped', function()
    local src = source
    if spawnedAnimals[src] then
        spawnedAnimals[src] = nil
    end
end)

-- Get animal model hash by type
function GetAnimalModel(animalType)
    local models = {
        ["Husky"]           = "a_c_husky",
        ["Rottweiler"]      = "a_c_rottweiler",
        ["Doberman"]        = "a_c_shepherd",
        ["Bull Terrier"]    = "a_c_pug",
        ["Boxer"]           = "a_c_retriever",
        ["Francia Bulldog"] = "a_c_poodle",
    }
    return models[animalType] or "a_c_husky"
end
