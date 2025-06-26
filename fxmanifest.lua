fx_version 'cerulean'
game 'gta5'

author 'Jacobmaate'
description 'FIB Police (FIBP) Pack'
version 'v3.03'

files {

	'data/vehicles.meta',
	'data/carvariations.meta',
	'data/carcols.meta',
	'data/handling.meta',
	'data/dlctext.meta',
	'data/vehiclelayouts.meta',
	'data/jmfibpolice_game.dat151.rel',
	'data/buffaloac_sounds.dat54.rel',
}
 
data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'
data_file 'DLC_TEXT_FILE' 'data/dlctext.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts.meta'
data_file 'AUDIO_GAMEDATA' 'data/jmfibpolice_game.dat'
data_file 'AUDIO_SOUNDDATA' 'data/buffaloac_sounds.dat'
client_script 'vehicle_names.lua'