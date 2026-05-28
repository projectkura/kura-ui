fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'kura-ui'
author 'Walteria.net'
version '0.0.3'
license 'UNLICENSED'
description 'Kura UI interface layer for Project Kura'

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**/*',
}

shared_scripts {
    '@kura-lib/init.lua',
    '@kura-core/init.lua',
    'init.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}
