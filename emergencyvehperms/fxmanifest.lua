fx_version 'cerulean'
game 'gta5'

description 'Kick unauthorized users out of emergency vehicles with webhook logging'
author 'MaestroDelFuego'
version '1.1.0'

shared_script '@qb-core/shared/locale.lua'
shared_script 'config.lua'

client_script 'client.lua'
server_script 'server.lua'

lua54 'yes'
