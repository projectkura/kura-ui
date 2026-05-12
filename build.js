import { readFileSync, writeFileSync } from 'node:fs';

const packageJson = JSON.parse(readFileSync('./package.json', 'utf8'));

const manifest = `fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

name '${packageJson.name}'
author '${packageJson.author}'
version '${packageJson.version}'
license '${packageJson.license}'
description '${packageJson.description}'

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
`;

writeFileSync('./fxmanifest.lua', manifest);
