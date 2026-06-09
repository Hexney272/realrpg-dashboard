-- Server-side settings persistence

RegisterNetEvent('dashboard:saveSetting')
AddEventHandler('dashboard:saveSetting', function(key, value)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId then return end

    -- Store in database as JSON field
    MySQL.Async.execute(
        'UPDATE characters SET settings = JSON_SET(COALESCE(settings, "{}"), ?, ?) WHERE characterId = ?',
        { '$.' .. key, tostring(value), charId }
    )
end)

RegisterNetEvent('dashboard:setWalkingStyle')
AddEventHandler('dashboard:setWalkingStyle', function(styleIndex)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if not charId then return end
    if not Config.WalkingStyles[styleIndex] then return end

    MySQL.Async.execute('UPDATE characters SET walkingStyle = ? WHERE characterId = ?',
        { styleIndex, charId })
end)
