fx_version 'cerulean'
game 'gta5'

name "OnlineM Cinema"
description "GTA:Online Cinema Remastered"
author "Mycroft"
lua54 'yes'
version "1.0.0"

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}
