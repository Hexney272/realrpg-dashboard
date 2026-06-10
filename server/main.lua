-- ============================================
-- RealRPG Dashboard - Server Main
-- ESX Legacy Integration
-- ============================================

ESX = exports['es_extended']:getSharedObject()

-- ============================================
-- REQUEST ALL DASHBOARD DATA
-- ============================================
RegisterNetEvent('dashboard:requestData')
AddEventHandler('dashboard:requestData', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()

    -- Get played time from users table
    local userResult = MySQL.Sync.fetchAll('SELECT playtime, realcoins, group_name FROM users WHERE identifier = ?', { identifier })
    local playtime = 0
    local realcoins = 0
    local adminGroup = 'user'
    if userResult and userResult[1] then
        playtime = userResult[1].playtime or 0
        realcoins = userResult[1].realcoins or 0
        adminGroup = userResult[1].group_name or 'user'
    end

    -- Vehicle count
    local vehCount = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM owned_vehicles WHERE owner = ?', { identifier }) or 0

    -- Properties count
    local propCount = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM owned_properties WHERE owner = ?', { identifier }) or 0

    local data = {
        name = xPlayer.getName(),
        serverId = src,
        realcoinBalance = realcoins,
        money = xPlayer.getMoney(),
        bankMoney = xPlayer.getAccount('bank').money,
        blackMoney = xPlayer.getAccount('black_money').money,
        playedMinutes = math.floor(playtime / 60), -- playtime stored in seconds in ESX
        level = GetLevel(math.floor(playtime / 60)),
        vehicleCount = vehCount,
        interiorCount = propCount,
        job = xPlayer.getJob().name,
        jobLabel = xPlayer.getJob().label,
        jobGrade = xPlayer.getJob().grade,
        jobGradeLabel = xPlayer.getJob().grade_label,
        identifier = identifier,
        adminGroup = adminGroup,
    }

    TriggerClientEvent('dashboard:receiveData', src, data)

    -- Also send RealCoin shop config
    TriggerClientEvent('dashboard:receivePremiumShop', src, Config.PremiumShop)

    -- Send news
    TriggerClientEvent('dashboard:receiveNews', src, Config.LatestNews)

    -- Send settings from KVP or database
    local settingsJson = MySQL.Sync.fetchScalar('SELECT dashboard_settings FROM users WHERE identifier = ?', { identifier })
    local playerSettings = {}
    if settingsJson and settingsJson ~= '' and settingsJson ~= 'NULL' then
        playerSettings = json.decode(settingsJson) or {}
    end

    -- Merge with working defaults
    local defaults = {
        walkingStyle = 1,
        voiceVolume = 50,
        hudVisible = true,
        nametagsVisible = true,
        streamerMode = false,
        speedoUnit = 'KM/H',
    }
    for k, v in pairs(defaults) do
        if playerSettings[k] == nil then
            playerSettings[k] = v
        end
    end

    TriggerClientEvent('dashboard:receiveSettings', src, playerSettings)
end)

-- ============================================
-- NEWS
-- ============================================
RegisterNetEvent('dashboard:requestNews')
AddEventHandler('dashboard:requestNews', function()
    TriggerClientEvent('dashboard:receiveNews', source, Config.LatestNews)
end)

-- ============================================
-- ADMIN LIST (ESX group mező alapján)
-- ============================================

-- Admin szintek konfigurálása (bővíthető)
Config.AdminGroups = {
    ['superadmin']  = { level = 11, title = 'Tulajdonos' },
    ['dev']         = { level = 10, title = 'Fejlesztő' },
    ['admin']       = { level = 6,  title = 'Admin' },
    ['mod']         = { level = 3,  title = 'Moderátor' },
    ['support']     = { level = 1,  title = 'Adminsegéd' },
    ['helper']      = { level = 1,  title = 'Adminsegéd' },
}

RegisterNetEvent('dashboard:requestAdminList')
AddEventHandler('dashboard:requestAdminList', function()
    local src = source
    local admins = {}
    local xPlayers = ESX.GetExtendedPlayers()

    -- Online adminok (ESX group alapján)
    for _, xPlayer in pairs(xPlayers) do
        local group = xPlayer.getGroup()
        local adminInfo = Config.AdminGroups[group]

        if adminInfo then
            table.insert(admins, {
                name = xPlayer.getName(),
                id = xPlayer.source,
                level = adminInfo.level,
                title = adminInfo.title,
                group = group,
                onDuty = true, -- Online = duty-ban van
                online = true,
            })
        end
    end

    -- Offline adminok is megjeleníthetők (users tábla group_name mező)
    local offlineAdmins = MySQL.Sync.fetchAll([[
        SELECT identifier, firstname, lastname, group_name
        FROM users
        WHERE group_name IN ('superadmin', 'dev', 'admin', 'mod', 'support', 'helper')
    ]])

    if offlineAdmins then
        for _, dbAdmin in ipairs(offlineAdmins) do
            -- Ne adjuk hozzá ha már online listában van
            local alreadyOnline = false
            for _, onlineAdmin in ipairs(admins) do
                local xP = ESX.GetPlayerFromId(onlineAdmin.id)
                if xP and xP.getIdentifier() == dbAdmin.identifier then
                    alreadyOnline = true
                    break
                end
            end

            if not alreadyOnline then
                local adminInfo = Config.AdminGroups[dbAdmin.group_name]
                if adminInfo then
                    table.insert(admins, {
                        name = (dbAdmin.firstname or '') .. ' ' .. (dbAdmin.lastname or ''),
                        id = '-',
                        level = adminInfo.level,
                        title = adminInfo.title,
                        group = dbAdmin.group_name,
                        onDuty = false,
                        online = false,
                    })
                end
            end
        end
    end

    -- Rendezés: online elsők, aztán szint szerint csökkenő
    table.sort(admins, function(a, b)
        if a.online ~= b.online then
            return a.online and not b.online
        end
        return a.level > b.level
    end)

    TriggerClientEvent('dashboard:receiveAdminList', src, admins)
end)

-- ============================================
-- REPORT SYSTEM
-- ============================================
RegisterNetEvent('dashboard:createReport')
AddEventHandler('dashboard:createReport', function(title, category, description)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- Save to database
    MySQL.Async.execute([[
        INSERT INTO dashboard_reports (identifier, player_name, title, category, description, created_at)
        VALUES (?, ?, ?, ?, ?, NOW())
    ]], { xPlayer.getIdentifier(), xPlayer.getName(), title, category, description })

    -- Notify admins
    local xPlayers = ESX.GetExtendedPlayers()
    for _, admin in pairs(xPlayers) do
        if admin.getGroup() == 'admin' or admin.getGroup() == 'superadmin' then
            TriggerClientEvent('dashboard:notify', admin.source, 'info',
                '[Report] ' .. xPlayer.getName() .. ': ' .. title)
        end
    end

    TriggerClientEvent('dashboard:notify', src, 'success', 'A reportod sikeresen elküldve!')
end)

-- ============================================
-- SAVE SETTINGS
-- ============================================
RegisterNetEvent('dashboard:saveSetting')
AddEventHandler('dashboard:saveSetting', function(key, value)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()

    -- Get current settings
    local settingsJson = MySQL.Sync.fetchScalar('SELECT dashboard_settings FROM users WHERE identifier = ?', { identifier })
    local settings = {}
    if settingsJson and settingsJson ~= '' and settingsJson ~= 'NULL' then
        settings = json.decode(settingsJson) or {}
    end

    settings[key] = value

    MySQL.Async.execute('UPDATE users SET dashboard_settings = ? WHERE identifier = ?',
        { json.encode(settings), identifier })
end)

-- ============================================
-- WALKING STYLE
-- ============================================
RegisterNetEvent('dashboard:setWalkingStyle')
AddEventHandler('dashboard:setWalkingStyle', function(styleIndex)
    local src = source
    if Config.WalkingStyles[styleIndex] then
        -- Broadcast to nearby players so they see the change
        TriggerClientEvent('dashboard:applyWalkingStyle', -1, src, Config.WalkingStyles[styleIndex].clipset)
    end
end)

-- ============================================
-- INVITE SYSTEM
-- ============================================
RegisterNetEvent('dashboard:requestInviteData')
AddEventHandler('dashboard:requestInviteData', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()

    -- Get or generate invite code
    local inviteCode = MySQL.Sync.fetchScalar('SELECT invite_code FROM users WHERE identifier = ?', { identifier })
    if not inviteCode or inviteCode == '' or inviteCode == 'NULL' then
        inviteCode = GenerateInviteCode()
        MySQL.Async.execute('UPDATE users SET invite_code = ? WHERE identifier = ?', { inviteCode, identifier })
    end

    -- Get invited players
    local invitedPlayers = MySQL.Sync.fetchAll([[
        SELECT u.identifier, u.firstname, u.lastname, u.playtime
        FROM users u
        WHERE u.invited_by = ?
    ]], { inviteCode })

    local processedInvited = {}
    if invitedPlayers then
        for _, p in ipairs(invitedPlayers) do
            table.insert(processedInvited, {
                name = (p.firstname or '') .. ' ' .. (p.lastname or ''),
                playedMinutes = math.floor((p.playtime or 0) / 60),
                identifier = p.identifier,
            })
        end
    end

    -- Check achievements
    local awards = CheckPlayerAchievements(processedInvited, src)

    TriggerClientEvent('dashboard:receiveInviteData', src, inviteCode, processedInvited, awards)
end)

-- ============================================
-- CLAIM AWARD
-- ============================================
RegisterNetEvent('dashboard:claimAward')
AddEventHandler('dashboard:claimAward', function(awardIndex)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if not Config.AwardDetails[awardIndex] then return end

    local reward = Config.AwardDetails[awardIndex].reward
    if reward.type == 'realcoin' then
        MySQL.Async.execute('UPDATE users SET realcoins = realcoins + ? WHERE identifier = ?',
            { reward.amount, xPlayer.getIdentifier() })
        local newBal = MySQL.Sync.fetchScalar('SELECT realcoins FROM users WHERE identifier = ?', { xPlayer.getIdentifier() }) or 0
        TriggerClientEvent('dashboard:updatePremiumBalance', src, newBal)
    elseif reward.type == 'money' then
        xPlayer.addAccountMoney('bank', reward.amount)
    end

    TriggerClientEvent('dashboard:notify', src, 'success', 'Jutalom sikeresen átvéve!')
end)

-- ============================================
-- ONLINE PLAYERS (extra feature)
-- ============================================
RegisterNetEvent('dashboard:requestOnlinePlayers')
AddEventHandler('dashboard:requestOnlinePlayers', function()
    local src = source
    local players = {}
    local xPlayers = ESX.GetExtendedPlayers()

    for _, xPlayer in pairs(xPlayers) do
        table.insert(players, {
            id = xPlayer.source,
            name = xPlayer.getName(),
            job = xPlayer.getJob().label,
            ping = GetPlayerPing(xPlayer.source),
        })
    end

    table.sort(players, function(a, b) return a.id < b.id end)
    TriggerClientEvent('dashboard:receiveOnlinePlayers', src, players, #players)
end)

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

function GetPlayerPremiumPoints(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return 0 end
    local result = MySQL.Sync.fetchScalar('SELECT realcoins FROM users WHERE identifier = ?', { xPlayer.getIdentifier() })
    return result or 0
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
        local parts = SplitString(award.id, ':')
        if parts[1] == 'invite' then
            local target = tonumber(parts[2]) or 0
            if #invitedPlayers >= target then
                awards[i].done = true
            end
        end
    end
    return awards
end

-- Export functions
exports('generateInviteCode', GenerateInviteCode)
exports('isInviteCodeOccupied', function(code)
    local result = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM users WHERE invite_code = ?', { code })
    return (result or 0) > 0
end)
exports('getWalkingStyle', function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return 1 end
    local settingsJson = MySQL.Sync.fetchScalar('SELECT dashboard_settings FROM users WHERE identifier = ?', { xPlayer.getIdentifier() })
    if settingsJson then
        local s = json.decode(settingsJson)
        if s and s.walkingStyle then return s.walkingStyle end
    end
    return 1
end)
