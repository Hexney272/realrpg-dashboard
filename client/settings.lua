-- Client-side settings management

local currentSettings = {}

-- Load saved settings on resource start
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    -- Load all settings from KVP
    currentSettings = {
        streamerMode = loadValue('streamerMode', 'true') == 'true',
        hudVisible = loadValue('hudVisible', 'true') == 'true',
        walkingStyle = tonumber(loadValue('walkingStyle', '1')) or 1,
        chatAnim = tonumber(loadValue('chatAnim', '1')) or 1,
        voiceVolume = tonumber(loadValue('voiceVolume', '50')) or 50,
        nametagsVisible = loadValue('nametagsVisible', 'true') == 'true',
        nametagSize = tonumber(loadValue('nametagSize', '50')) or 50,
        speedoUnit = loadValue('speedoUnit', 'kmh'),
        crosshairType = tonumber(loadValue('crosshairType', '1')) or 1,
    }

    -- Apply walking style
    local style = Config.WalkingStyles[currentSettings.walkingStyle]
    if style then
        RequestAnimSet(style.clipset)
        local timeout = 0
        while not HasAnimSetLoaded(style.clipset) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
        if HasAnimSetLoaded(style.clipset) then
            SetPedMovementClipset(PlayerPedId(), style.clipset, 0.2)
        end
    end
end)

-- When server sends settings data to NUI
RegisterNetEvent('dashboard:receiveSettings')
AddEventHandler('dashboard:receiveSettings', function(settings)
    if settings then
        for k, v in pairs(settings) do
            currentSettings[k] = v
        end
    end

    SendNUIMessage({
        action = 'updateSettings',
        settings = currentSettings,
        walkingStyles = Config.WalkingStyles,
        chatAnims = Config.ChatAnims,
    })
end)

-- Setting changed from NUI
RegisterNUICallback('saveSetting', function(data, cb)
    local key = data.key
    local value = data.value

    -- Save to KVP
    saveValue(key, tostring(value))
    currentSettings[key] = value

    -- Apply immediately
    if key == 'walkingStyle' then
        local idx = tonumber(value) or 1
        local style = Config.WalkingStyles[idx]
        if style then
            RequestAnimSet(style.clipset)
            while not HasAnimSetLoaded(style.clipset) do
                Wait(10)
            end
            SetPedMovementClipset(PlayerPedId(), style.clipset, 0.2)
        end
        TriggerServerEvent('dashboard:setWalkingStyle', idx)
    elseif key == 'streamerMode' then
        -- Mute copyrighted music etc
    elseif key == 'hudVisible' then
        -- Toggle HUD
    end

    -- Sync to server if needed
    TriggerServerEvent('dashboard:saveSetting', key, value)
    cb('ok')
end)

-- Export for other resources
function getStreamerMode()
    return currentSettings.streamerMode or false
end
