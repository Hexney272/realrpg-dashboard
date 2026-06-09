fx_version 'cerulean'
game 'gta5'

name 'realrpg-dashboard'
description 'RealRPG Dashboard - Ported from MTA:SA'
author 'RealRPG'
version '1.0.0'

-- Shared scripts (loaded on both client and server)
shared_scripts {
    'shared/config.lua',
    'shared/functions.lua',
}

-- Client scripts
client_scripts {
    'client/main.lua',
    'client/settings.lua',
    'client/vehicles.lua',
    'client/animals.lua',
    'client/interiors.lua',
    'client/groups.lua',
    'client/news.lua',
    'client/ppshop.lua',
}

-- Server scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/settings.lua',
    'server/vehicles.lua',
    'server/animals.lua',
    'server/interiors.lua',
    'server/news.lua',
    'server/ppshop.lua',
}

-- NUI (Vue 3 + Vite built UI)
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/assets/*.css',
    'html/assets/*.js',
    'html/img/**/*.png',
    'html/img/*.png',
}

-- Exports
exports {
    'getStreamerMode',
    'getCurrentChatAnim',
    'saveValue',
}

server_exports {
    'getWalkingStyle',
    'generateInviteCode',
    'givePlayerAchievement',
    'isInviteCodeOccupied',
}

lua54 'yes'
