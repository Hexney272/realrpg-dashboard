-- Server-side news management

-- The news is configured in Config.LatestNews
-- Can be extended to load from database

RegisterNetEvent('dashboard:requestNews')
AddEventHandler('dashboard:requestNews', function()
    local src = source
    TriggerClientEvent('dashboard:receiveNews', src, Config.LatestNews)
end)
