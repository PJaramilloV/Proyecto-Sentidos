extends Node

signal fps_displayed(value)
signal bloom_toggled()
signal brightness_updated(value)
signal fov_updated(value)
signal mouse_sens_updated(value)

func toggle_fullscreen(value):
	OS.window_fullscreen = value
	SaveSettings.game_data.fullscreen_on = value
	SaveSettings.save_data()
	#OS.window_size
	
func toggle_vsync(value):
	OS.vsync_enabled = value
	SaveSettings.game_data.vsync_on = value
	SaveSettings.save_data()
	
	
func toggle_fps_display(value):
	emit_signal("fps_displayed", value)
	SaveSettings.game_data.display_fps = value
	SaveSettings.save_data()
	
func set_max_fps(value):
	Engine.target_fps = value 
	SaveSettings.game_data.max_fps = Engine.target_fps
	SaveSettings.save_data()

func toggle_bloom(value):
	emit_signal("bloom_toggled", value)
	
func update_brightness(value):
	emit_signal("brightness_updated",value)
	SaveSettings.game_data.brightness = value
	SaveSettings.save_data()

func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0,vol)

#Necesita manipular la cámara y meterme al script del personaje
func update_fov(value):
	emit_signal("fov_updated", value)

#Hay que meterse al script del personaje
func update_mouse_sens(value):
	emit_signal("mouse_sens_updated", value)

