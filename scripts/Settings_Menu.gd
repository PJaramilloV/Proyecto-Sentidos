extends Popup

# Video Settings
onready var display_options = $Settings_Tab/Video/MarginContainer/Video_Settings/Display_Option
onready var vsync_btn = $Settings_Tab/Video/MarginContainer/Video_Settings/Vsync_Button
onready var display_fps_btn = $Settings_Tab/Video/MarginContainer/Video_Settings/FPS_Button
onready var max_fps_val = $Settings_Tab/Video/MarginContainer/Video_Settings/FPSLimit_Option
onready var bloom_btn = $Settings_Tab/Video/MarginContainer/Video_Settings/Bloom_Button
onready var brightness_slider = $Settings_Tab/Video/MarginContainer/Video_Settings/Brightness_Slider

# Audio Settings
onready var master_vol_slider = $Settings_Tab/Audio/Audio_Settings/MasterVol_Slider
onready var music_vol_slider = $Settings_Tab/Audio/Audio_Settings/MusicVol_Slider
onready var sfx_vol_slider = $Settings_Tab/Audio/Audio_Settings/SfxVol_Slider
onready var ui_vol_slider = $Settings_Tab/Audio/Audio_Settings/UIVol_Slider

# Gameplay Settings
onready var fov_val = $Settings_Tab/Gameplay/Gameplay_Settings/HBoxContainer/FOV_Value
onready var fov_slider = $Settings_Tab/Gameplay/Gameplay_Settings/HBoxContainer/FOV_Slider
onready var mouse_sense_val = $Settings_Tab/Gameplay/Gameplay_Settings/HBoxContainer2/MouseSense_Value
onready var mouse_sense_slider = $Settings_Tab/Gameplay/Gameplay_Settings/HBoxContainer2/MouseSense_Slider


func _ready():
	display_options.select(1 if SaveSettings.game_data.fullscreen_on else 0)
	GlobalSettings.toggle_fullscreen(SaveSettings.game_data.fullscreen_on)
	brightness_slider.value = SaveSettings.game_data.brightness
	vsync_btn.pressed = SaveSettings.game_data.vsync_on
	
	
	#display_fps_btn.pressed = SaveSettings.game_data.display_fps
	#GlobalSettings.toggle_fps_display(SaveSettings.game_data.display_fps)
	
	max_fps_val.select(1 if SaveSettings.game_data.max_fps == 60 else 0)
	GlobalSettings.set_max_fps(SaveSettings.game_data.max_fps)
	
	master_vol_slider.value = SaveSettings.game_data.master_volume
	music_vol_slider.value = SaveSettings.game_data.music_volume
	sfx_vol_slider.value = SaveSettings.game_data.sfx_volume
	ui_vol_slider.value = SaveSettings.game_data.ui_volume

func _on_Display_Option_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)


func _on_Vsync_Button_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)


func _on_FPS_Button_toggled(button_pressed):
	GlobalSettings.toggle_fps_display(button_pressed)


func _on_FPSLimit_Option_item_selected(index):
	GlobalSettings.set_max_fps(30 if index == 0 else 60)


func _on_Bloom_Button_toggled(button_pressed):
	pass # Replace with function body.


func _on_Brightness_Slider_value_changed(value):
	GlobalSettings.update_brightness(value)


func _on_MasterVol_Slider_value_changed(value):
	GlobalSettings.update_master_vol(value)

func _on_MusicVol_Slider_value_changed(value):
	GlobalSettings.update_music_vol(value)

func _on_SfxVol_Slider_value_changed(value):
	GlobalSettings.update_sfx_vol(value)

func _on_UIVol_Slider_value_changed(value):
	GlobalSettings.update_ui_vol(value)

func _on_FOV_Slider_value_changed(value):
	pass # Replace with function body.

func _on_MouseSense_Slider_value_changed(value):
	pass # Replace with function body.
