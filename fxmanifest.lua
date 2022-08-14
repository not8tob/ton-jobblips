fx_version  'cerulean'
game        'gta5'
lua54       'yes'

title       'ton-jobblips'
description 'A resource to place blips to job members'
version     '1.0.0'

contact     'ton#8456 or https://discord.gg/ucAfcAdwXD'

dependencies {
    '/onesync',
}

shared_scripts {
    './shared/config.lua',
    './shared/debug.lua',
}

client_scripts {
    './client/*.lua'
}

server_scripts {
    './server/framework.lua',
    './server/main.lua',
    './server/version.lua',
}