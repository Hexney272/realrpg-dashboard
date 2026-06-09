-- Client-side main dashboard controller
local isDashboardOpen = false
local playerData = {}
local streamerMode = false

-- Open/close dashboard
RegisterCommand('dashboard', function()
    ToggleDashboard()
end, false)

RegisterKeyMapping('dashboard', 'Dashboard megnyitasa', 'keyboard', Config.OpenKey)

function ToggleDashboard()
    isDashboardOpen = not isDashboardOpen
    SetNuiFocus(isDashboardOpen, isDashboardOpen)

    if isDashboardOpen then
        -- Request fresh data from server
        TriggerServerEvent('dashboard:requestData')
        SendNUIMessage({ action = 'open' })
    else
        SendNUIMessage({ action = 'close' })
    end
end

-- Receive player data from server
RegisterNetEvent('dashboard:receiveData')
AddEventHandler('dashboard:receiveData', function(data)
    playerData = data
    SendNUIMessage({
        action = 'updatePlayerData',
        data = data
    })
end)

-- Receive premium balance update
RegisterNetEvent('dashboard:updatePremiumBalance')
AddEventHandler('dashboard:updatePremiumBalance', function(balance)
    playerData.premiumBalance = balance
    SendNUIMessage({
        action = 'updatePremiumBalance',
        balance = balance
    })
end)

-- Receive vehicle list
RegisterNetEvent('dashboard:receiveVehicles')
AddEventHandler('dashboard:receiveVehicles', function(vehicles, limit)
    SendNUIMessage({
        action = 'updateVehicles',
        vehicles = vehicles,
        limit = limit
    })
end)

-- Receive animal list
RegisterNetEvent('dashboard:receiveAnimals')
AddEventHandler('dashboard:receiveAnimals', function(animals)
    SendNUIMessage({
        action = 'updateAnimals',
        animals = animals
    })
end)

-- Receive interior list
RegisterNetEvent('dashboard:receiveInteriors')
AddEventHandler('dashboard:receiveInteriors', function(interiors, limit)
    SendNUIMessage({
        action = 'updateInteriors',
        interiors = interiors,
        limit = limit
    })
end)

-- Receive groups data
RegisterNetEvent('dashboard:receiveGroups')
AddEventHandler('dashboard:receiveGroups', function(groups)
    SendNUIMessage({
        action = 'updateGroups',
        groups = groups
    })
end)

-- Receive news data
RegisterNetEvent('dashboard:receiveNews')
AddEventHandler('dashboard:receiveNews', function(news)
    SendNUIMessage({
        action = 'updateNews',
        news = news
    })
end)

-- Receive online players
RegisterNetEvent('dashboard:receiveOnlinePlayers')
AddEventHandler('dashboard:receiveOnlinePlayers', function(players, count)
    SendNUIMessage({
        action = 'updateOnlinePlayers',
        players = players,
        count = count
    })
end)

-- Receive admin list
RegisterNetEvent('dashboard:receiveAdminList')
AddEventHandler('dashboard:receiveAdminList', function(admins)
    SendNUIMessage({
        action = 'updateAdmins',
        admins = admins
    })
end)

-- Receive settings
RegisterNetEvent('dashboard:receiveSettings')
AddEventHandler('dashboard:receiveSettings', function(settings)
    SendNUIMessage({
        action = 'updateSettings',
        settings = settings
    })
end)

-- Receive keybinds
RegisterNetEvent('dashboard:receiveKeybinds')
AddEventHandler('dashboard:receiveKeybinds', function(keybinds)
    SendNUIMessage({
        action = 'updateKeybinds',
        keybinds = keybinds
    })
end)

-- Receive premium shop data
RegisterNetEvent('dashboard:receivePremiumShop')
AddEventHandler('dashboard:receivePremiumShop', function(shopData)
    SendNUIMessage({
        action = 'updatePremiumShop',
        shop = shopData
    })
end)

-- Receive invite data
RegisterNetEvent('dashboard:receiveInviteData')
AddEventHandler('dashboard:receiveInviteData', function(inviteCode, invitedPlayers, awards)
    SendNUIMessage({
        action = 'updateInviteData',
        inviteCode = inviteCode,
        invitedPlayers = invitedPlayers,
        awards = awards
    })
end)

-- Notification from server
RegisterNetEvent('dashboard:notify')
AddEventHandler('dashboard:notify', function(type, message)
    SendNUIMessage({
        action = 'notify',
        notifyType = type,
        message = message
    })
end)

-- NUI Callbacks
RegisterNUICallback('closeDashboard', function(data, cb)
    isDashboardOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    cb('ok')
end)

RegisterNUICallback('requestVehicles', function(data, cb)
    TriggerServerEvent('dashboard:requestVehicles')
    cb('ok')
end)

RegisterNUICallback('requestAnimals', function(data, cb)
    TriggerServerEvent('dashboard:requestAnimals')
    cb('ok')
end)

RegisterNUICallback('requestInteriors', function(data, cb)
    TriggerServerEvent('dashboard:requestInteriors')
    cb('ok')
end)

RegisterNUICallback('requestGroups', function(data, cb)
    TriggerServerEvent('dashboard:requestGroups')
    cb('ok')
end)

RegisterNUICallback('requestNews', function(data, cb)
    TriggerServerEvent('dashboard:requestNews')
    cb('ok')
end)

RegisterNUICallback('requestOnlinePlayers', function(data, cb)
    TriggerServerEvent('dashboard:requestOnlinePlayers')
    cb('ok')
end)

RegisterNUICallback('requestAdminList', function(data, cb)
    TriggerServerEvent('dashboard:requestAdminList')
    cb('ok')
end)

RegisterNUICallback('requestInviteData', function(data, cb)
    TriggerServerEvent('dashboard:requestInviteData')
    cb('ok')
end)

RegisterNUICallback('markVehicleGPS', function(data, cb)
    TriggerServerEvent('dashboard:markVehicleGPS', data.vehicleId)
    cb('ok')
end)

RegisterNUICallback('sellVehicle', function(data, cb)
    TriggerServerEvent('dashboard:sellVehicle', data.vehicleId, data.targetId, data.price)
    cb('ok')
end)

RegisterNUICallback('buyVehicleSlot', function(data, cb)
    TriggerServerEvent('dashboard:buyVehicleSlot', data.amount)
    cb('ok')
end)

RegisterNUICallback('buyInteriorSlot', function(data, cb)
    TriggerServerEvent('dashboard:buyInteriorSlot', data.amount)
    cb('ok')
end)

RegisterNUICallback('buyAnimal', function(data, cb)
    TriggerServerEvent('dashboard:buyAnimal', data.animalType, data.name)
    cb('ok')
end)

RegisterNUICallback('spawnAnimal', function(data, cb)
    TriggerServerEvent('dashboard:spawnAnimal', data.animalId)
    cb('ok')
end)

RegisterNUICallback('despawnAnimal', function(data, cb)
    TriggerServerEvent('dashboard:despawnAnimal', data.animalId)
    cb('ok')
end)

RegisterNUICallback('renameAnimal', function(data, cb)
    TriggerServerEvent('dashboard:renameAnimal', data.animalId, data.newName)
    cb('ok')
end)

RegisterNUICallback('sellAnimal', function(data, cb)
    TriggerServerEvent('dashboard:sellAnimal', data.animalId, data.targetId, data.price)
    cb('ok')
end)

RegisterNUICallback('buyPremiumItem', function(data, cb)
    TriggerServerEvent('dashboard:buyPremiumItem', data.menuIndex, data.itemIndex, data.amount)
    cb('ok')
end)

RegisterNUICallback('createReport', function(data, cb)
    TriggerServerEvent('dashboard:createReport', data.title, data.category, data.description)
    cb('ok')
end)

RegisterNUICallback('saveSetting', function(data, cb)
    TriggerServerEvent('dashboard:saveSetting', data.key, data.value)
    ApplySettingLocally(data.key, data.value)
    cb('ok')
end)

RegisterNUICallback('setWalkingStyle', function(data, cb)
    local style = Config.WalkingStyles[data.index]
    if style then
        RequestAnimSet(style.clipset)
        while not HasAnimSetLoaded(style.clipset) do
            Wait(10)
        end
        SetPedMovementClipset(PlayerPedId(), style.clipset, 0.2)
        TriggerServerEvent('dashboard:setWalkingStyle', data.index)
    end
    cb('ok')
end)

RegisterNUICallback('claimAward', function(data, cb)
    TriggerServerEvent('dashboard:claimAward', data.awardIndex)
    cb('ok')
end)

RegisterNUICallback('markInteriorGPS', function(data, cb)
    TriggerServerEvent('dashboard:markInteriorGPS', data.interiorId)
    cb('ok')
end)

-- Apply settings locally on client
function ApplySettingLocally(key, value)
    if key == 'streamerMode' then
        streamerMode = value
    elseif key == 'hudVisible' then
        -- Toggle HUD visibility
    end
end

-- Export: Get streamer mode
function getStreamerMode()
    return streamerMode
end

-- Export: Get current chat animation
function getCurrentChatAnim()
    return Config.ChatAnims[1] -- Default
end

-- Export: Save value (KVP storage in FiveM)
function saveValue(name, value)
    SetResourceKvp('dashboard_' .. name, tostring(value))
end

-- Load a saved value
function loadValue(name, default)
    local val = GetResourceKvpString('dashboard_' .. name)
    if val == nil then return default end
    return val
end

-- Vehicle GPS blip handling
local gpsBlip = nil

RegisterNetEvent('dashboard:vehicleGPSMark')
AddEventHandler('dashboard:vehicleGPSMark', function(coords)
    if gpsBlip then
        RemoveBlip(gpsBlip)
    end
    if coords then
        gpsBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(gpsBlip, 225)
        SetBlipColour(gpsBlip, 2)
        SetBlipScale(gpsBlip, 0.8)
        SetBlipRoute(gpsBlip, true)
        SetBlipRouteColour(gpsBlip, 2)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Jarmuved")
        EndTextCommandSetBlipName(gpsBlip)
    end
end)

-- Interior GPS blip handling
RegisterNetEvent('dashboard:interiorGPSMark')
AddEventHandler('dashboard:interiorGPSMark', function(coords)
    if gpsBlip then
        RemoveBlip(gpsBlip)
    end
    if coords then
        gpsBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(gpsBlip, 40)
        SetBlipColour(gpsBlip, 3)
        SetBlipScale(gpsBlip, 0.8)
        SetBlipRoute(gpsBlip, true)
        SetBlipRouteColour(gpsBlip, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Interiorod")
        EndTextCommandSetBlipName(gpsBlip)
    end
end)
