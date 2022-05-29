extends Popup

# Video Settings
onready var display_options = $Settings_Tab/Video/MarginContainer/Video_Settings/Display_Option
onready var vsync_btn = $Settings_Tab/Video/MarginContainer/Video_Settings/Vsync_Button
onready var display_fps_btn = $Settings_Tab/Video/MarginContainer/Video_Settings/FPS_Button
onready var max_fps_val = $Settings_Tab/Video/MarginContainer/Video_Settings/FPSLimit_Option
onready var bloom_btn = $Settings_Tab/Video/MarginContainer/Video_Settings/Bloom_Button
onready var brigthness_slider = $Settings_Tab/Video/MarginContainer/Video_Settings/Brightness_Slider

# Audio Settings
onready var master_vol_slider = $Settings_Tab/Audio/Audio_Settings/MasterVol_Slider
onready var music_vol_slider = $Settings_Tab/Audio/Audio_Settings/MusicVol_Slider
onready var sfx_vol_slider = $Settings_Tab/Audio/Audio_Settings/SfxVol_Slider

# Gameplay Settings
onready var fov_val = $Settings_Tab/Gameplay/Gameplay_Settings/HBoxContainer/FOV_Value
onready var fov_slider = $Settings_Tab/Gameplay/Gameplay_Settings/HBoxContainer/FOV_Slider
onready var mouse_sense_val = $Settings_Tab/Gameplay/Gameplay_Settings/HBoxContainer2/MouseSense_Value
onready var mouse_sense_slider = $Settings_Tab/Gameplay/Gameplay_Settings/HBoxContainer2/MouseSense_Slider


func _ready():
	popup_centered()


func _on_Display_Option_item_selected(index):
	pass # Replace with function body.


func _on_Vsync_Button_toggled(button_pressed):
	pass # Replace with function body.


func _on_FPS_Button_toggled(button_pressed):
	pass # Replace with function body.


func _on_FPSLimit_Option_item_selected(index):
	pass # Replace with function body.


func _on_Bloom_Button_toggled(button_pressed):
	pass # Replace with function body.


func _on_Brightness_Slider_value_changed(value):
	pass # Replace with function body.


func _on_MasterVol_Slider_value_changed(value):
	pass # Replace with function body.


func _on_MusicVol_Slider_value_changed(value):
	pass # Replace with function body.


func _on_SfxVol_Slider_value_changed(value):
	pass # Replace with function body.


func _on_FOV_Slider_value_changed(value):
	pass # Replace with function body.


func _on_MouseSense_Slider_value_changed(value):
	pass # Replace with function body.
