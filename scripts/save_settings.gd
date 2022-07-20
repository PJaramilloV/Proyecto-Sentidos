extends Node

const SAVEFILE_SETTINGS = "user://SAVEFILE_SETTINGS.save"

var game_data = {}

func _ready():
	load_data()
	#print(game_data)

func load_data():
	var file = File.new()
	if not file.file_exists(SAVEFILE_SETTINGS):
		#el display_fps no funciona
		game_data = {
			"fullscreen_on": false,
			"vsync_on": false,
			"max_fps": 60,
			"brightness": 1,
			"master_volume": -10,
			"sfx_volume": -10,
			"ui_volume": -10,
			"music_volume": -10,
		}
		save_data()
	file.open(SAVEFILE_SETTINGS, File.READ)
	game_data = file.get_var()
	file.close()
	
func save_data():
	var file = File.new()
	file.open(SAVEFILE_SETTINGS, File.WRITE)
	file.store_var(game_data)
	file.close()
