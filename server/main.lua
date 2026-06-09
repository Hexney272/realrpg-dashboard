-- Server-side main dashboard logic

-- Request all dashboard data
RegisterNetEvent('dashboard:requestData')
AddEventHandler('dashboard:requestData', function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0) -- steam/license/discord

    -- Build player data
    local data = {
        name = GetPlayerName(src),
        serverId = src,
        premiumBalance = GetPlayerPremiumPoints(src),
        money = GetPlayerMoney(src),
        bankMoney = GetPlayerBankMoney(src),
        playedMinutes = GetPlayerPlayedMinutes(src),
        level = GetLevel(GetPlayerPlayedMinutes(src)),
        vehicleCount = GetPlayerVehicleCount(src),
        interiorCount = GetPlayerInteriorCount(src),
        accountId = GetPlayerAccountId(src),
        characterId = GetPlayerCharacterId(src),
    }

    TriggerClientEvent('dashboard:receiveData', src, data)

    -- Also send premium shop config, settings, and news
    TriggerClientEvent('dashboard:receivePremiumShop', src, Config.PremiumShop)
    TriggerClientEvent('dashboard:receiveNews', src, Config.LatestNews)

    -- Send player settings from DB
    local charId = GetPlayerCharacterId(src)
    local settingsJson = nil
    if charId then
        settingsJson = MySQL.Sync.fetchScalar('SELECT settings FROM characters WHERE characterId = ?', { charId })
    end
    local playerSettings = {}
    if settingsJson and settingsJson ~= '' then
        playerSettings = json.decode(settingsJson) or {}
    end
    -- Merge with defaults
    playerSettings.walkingStyle = playerSettings.walkingStyle or 1
    playerSettings.streamerMode = playerSettings.streamerMode or false
    playerSettings.hudVisible = playerSettings.hudVisible ~= false
    playerSettings.nametagsVisible = playerSettings.nametagsVisible ~= false
    playerSettings.voiceVolume = playerSettings.voiceVolume or 50
    playerSettings.farClip = playerSettings.farClip or 3000
    playerSettings.fogDistance = playerSettings.fogDistance or 2000
    playerSettings.blips3d = playerSettings.blips3d ~= false
    playerSettings.platesVisible = playerSettings.platesVisible ~= false
    playerSettings.speedoUnit = playerSettings.speedoUnit or 'KM/H'
    playerSettings.gpsSoundPack = playerSettings.gpsSoundPack or 'Női'
    playerSettings.crosshairType = playerSettings.crosshairType or 1
    playerSettings.crosshairColor = playerSettings.crosshairColor or '#ffffff'
    playerSettings.infoboxChat = playerSettings.infoboxChat or false
    playerSettings.infoboxSound = playerSettings.infoboxSound ~= false
    playerSettings.kickMessages = playerSettings.kickMessages or false
    playerSettings.groupMessages = playerSettings.groupMessages ~= false
    playerSettings.oocTimestamps = playerSettings.oocTimestamps or false

    TriggerClientEvent('dashboard:receiveSettings', src, playerSettings)

    -- Send keybind defaults
    TriggerClientEvent('dashboard:receiveKeybinds', src, Config.DefaultBinds)
end)

-- Request news
RegisterNetEvent('dashboard:requestNews')
AddEventHandler('dashboard:requestNews', function()
    local src = source
    TriggerClientEvent('dashboard:receiveNews', src, Config.LatestNews)
end)

-- Request admin list
RegisterNetEvent('dashboard:requestAdminList')
AddEventHandler('dashboard:requestAdminList', function()
    local src = source
    local admins = GetOnlineAdmins()
    TriggerClientEvent('dashboard:receiveAdminList', src, admins)
end)

-- Create report
RegisterNetEvent('dashboard:createReport')
AddEventHandler('dashboard:createReport', function(title, category, description)
    local src = source
    -- Insert report into database or handle via your report system
    print(string.format('[Dashboard Report] Player: %s | Title: %s | Category: %s | Desc: %s',
        GetPlayerName(src), title, category, description))

    TriggerClientEvent('dashboard:notify', src, 'success', 'A reportod sikeresen elkuldve!')
end)

-- Save setting server-side
RegisterNetEvent('dashboard:saveSetting')
AddEventHandler('dashboard:saveSetting', function(key, value)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if charId then
        -- Save to database
        MySQL.Async.execute('UPDATE characters SET settings = JSON_SET(COALESCE(settings, "{}"), ?, ?) WHERE characterId = ?',
            { '$.' .. key, tostring(value), charId })
    end
end)

-- Set walking style
RegisterNetEvent('dashboard:setWalkingStyle')
AddEventHandler('dashboard:setWalkingStyle', function(styleIndex)
    local src = source
    local charId = GetPlayerCharacterId(src)
    if charId and Config.WalkingStyles[styleIndex] then
        MySQL.Async.execute('UPDATE characters SET walkingStyle = ? WHERE characterId = ?',
            { styleIndex, charId })
    end
end)

-- =============================================
-- HELPER FUNCTIONS (Adapt to your framework)
-- =============================================

--- Get player premium points (adapt to your economy system)
function GetPlayerPremiumPoints(src)
    -- Replace with your actual implementation
    -- Example with oxmysql:
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then return 0 end
    local result = MySQL.Sync.fetchScalar('SELECT premiumPoints FROM accounts WHERE identifier = ?', { identifier })
    return result or 0
end

--- Get player money
function GetPlayerMoney(src)
    -- Adapt to your economy framework (esx, qb, etc.)
    -- Example for ESX:
    -- local xPlayer = ESX.GetPlayerFromId(src)
    -- return xPlayer.getMoney()
    return 0
end

--- Get player bank money
function GetPlayerBankMoney(src)
    -- Adapt to your framework
    return 0
end

--- Get player played minutes
function GetPlayerPlayedMinutes(src)
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then return 0 end
    local result = MySQL.Sync.fetchScalar('SELECT playedMinutes FROM characters WHERE identifier = ?', { identifier })
    return result or 0
end

--- Get player vehicle count
function GetPlayerVehicleCount(src)
    local charId = GetPlayerCharacterId(src)
    if not charId then return 0 end
    local result = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM vehicles WHERE characterId = ?', { charId })
    return result or 0
end

--- Get player interior count
function GetPlayerInteriorCount(src)
    local charId = GetPlayerCharacterId(src)
    if not charId then return 0 end
    local result = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM interiors WHERE owner = ?', { charId })
    return result or 0
end

--- Get player account ID
function GetPlayerAccountId(src)
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then return 0 end
    local result = MySQL.Sync.fetchScalar('SELECT accountId FROM accounts WHERE identifier = ?', { identifier })
    return result or 0
end

--- Get player character ID
function GetPlayerCharacterId(src)
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then return 0 end
    local result = MySQL.Sync.fetchScalar('SELECT characterId FROM characters WHERE identifier = ?', { identifier })
    return result or 0
end

--- Get online admins
function GetOnlineAdmins()
    local admins = {}
    for _, playerId in ipairs(GetPlayers()) do
        local adminLevel = GetPlayerAdminLevel(tonumber(playerId))
        if adminLevel and adminLevel >= 1 then
            table.insert(admins, {
                name = GetPlayerName(tonumber(playerId)),
                id = playerId,
                level = adminLevel,
                onDuty = IsAdminOnDuty(tonumber(playerId)),
            })
        end
    end
    table.sort(admins, function(a, b) return a.level > b.level end)
    return admins
end

--- Get admin level (adapt to your permissions system)
function GetPlayerAdminLevel(src)
    -- Replace with your actual admin system
    -- Example: return GetResourceKvpInt('admin_' .. GetPlayerIdentifier(src, 0))
    return 0
end

--- Is admin on duty
function IsAdminOnDuty(src)
    return false
end

-- Invite system
RegisterNetEvent('dashboard:requestInviteData')
AddEventHandler('dashboard:requestInviteData', function()
    local src = source
    local accountId = GetPlayerAccountId(src)
    if not accountId or accountId == 0 then return end

    local inviteCode = MySQL.Sync.fetchScalar('SELECT inviteCode FROM accounts WHERE accountId = ?', { accountId })
    if not inviteCode then
        inviteCode = GenerateInviteCode()
        MySQL.Async.execute('UPDATE accounts SET inviteCode = ? WHERE accountId = ?', { inviteCode, accountId })
    end

    -- Get invited players
    local invitedPlayers = MySQL.Sync.fetchAll(
        'SELECT a.accountId, c.name, c.playedMinutes, a.lastOnline, a.achievements FROM accounts a LEFT JOIN characters c ON c.accountId = a.accountId WHERE a.invitedBy = ?',
        { inviteCode }
    )

    -- Check achievements
    local awards = CheckPlayerAchievements(invitedPlayers or {}, src)

    TriggerClientEvent('dashboard:receiveInviteData', src, inviteCode, invitedPlayers or {}, awards)
end)

-- Claim award
RegisterNetEvent('dashboard:claimAward')
AddEventHandler('dashboard:claimAward', function(awardIndex)
    local src = source
    if not Config.AwardDetails[awardIndex] then return end

    -- TODO: Verify the award is actually earned and not already claimed
    local reward = Config.AwardDetails[awardIndex].reward
    if reward.type == 'premium' then
        GivePlayerPremiumPoints(src, reward.amount)
    elseif reward.type == 'money' then
        GivePlayerMoney(src, reward.amount)
    end

    TriggerClientEvent('dashboard:notify', src, 'success', 'Jutalom sikeresen athozva!')
end)

function GivePlayerPremiumPoints(src, amount)
    local accountId = GetPlayerAccountId(src)
    if accountId and accountId > 0 then
        MySQL.Async.execute('UPDATE accounts SET premiumPoints = premiumPoints + ? WHERE accountId = ?', { amount, accountId })
        -- Refresh client balance
        local newBalance = MySQL.Sync.fetchScalar('SELECT premiumPoints FROM accounts WHERE accountId = ?', { accountId })
        TriggerClientEvent('dashboard:updatePremiumBalance', src, newBalance or 0)
    end
end

function GivePlayerMoney(src, amount)
    -- Adapt to your economy framework
    -- ESX example: local xPlayer = ESX.GetPlayerFromId(src) xPlayer.addMoney(amount)
end

function CheckPlayerAchievements(invitedPlayers, src)
    local awards = {}
    for i, award in ipairs(Config.AwardDetails) do
        awards[i] = {
            label = award.label,
            reward = award.reward,
            done = false,
            taken = false,
        }
        -- Simple check for invite-based awards
        local parts = SplitString(award.id, ':')
        if parts[1] == 'invite' then
            local target = tonumber(parts[2]) or 0
            if #invitedPlayers >= target then
                awards[i].done = true
            end
        end
        -- Additional checks can be added here
    end
    return awards
end

-- Export functions
exports('generateInviteCode', GenerateInviteCode)
exports('givePlayerAchievement', function(src, achievementType)
    -- Implement achievement giving
end)
exports('isInviteCodeOccupied', function(code)
    local result = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM accounts WHERE inviteCode = ?', { code })
    return (result or 0) > 0
end)
exports('getWalkingStyle', function(src)
    local charId = GetPlayerCharacterId(src)
    if not charId then return 1 end
    local result = MySQL.Sync.fetchScalar('SELECT walkingStyle FROM characters WHERE characterId = ?', { charId })
    return result or 1
end)
