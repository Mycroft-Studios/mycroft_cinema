fx_version 'cerulean'
game 'gta5'

name "Mycroft's Cinema"
description "GTA:Online Cinema Remade"
author "Mycroft"
lua54 'yes'
version "1.0.0"

shared_scripts {
	'@es_extended/imports.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}
