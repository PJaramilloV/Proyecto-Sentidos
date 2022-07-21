extends Node2D

const main_menu = preload("res://scenes/main_menu.tscn")
const demo = preload("res://demo/DemoHero.tscn")
const game_over = preload("res://scenes/game_over.tscn")
const credits = preload("res://godot-credits-master/GodotCredits.tscn")
const level0 = preload("res://scenes/levels/LVL_0.tscn")
const level1 = preload("res://scenes/levels/LVL_1.tscn")
const level2 = preload("res://scenes/levels/LVL_2.tscn")
const level3 = preload("res://scenes/levels/LVL_3.tscn")
const level4 = preload("res://scenes/levels/LVL_4.tscn")
const level5 = preload("res://scenes/levels/LVL_5.tscn")
var levels = [level0, level1, level2, level3, level4, level5]
var temp_level
#onready var pointer = $CurrentScene/Control.level
var pointer
var macro

func _ready():
	$CurrentScene.add_child(main_menu.instance())
	pointer = $CurrentScene/Control.level
	reconnect_menu()
	GlobalSettings.connect("brightness_updated", self, "_update_brightness")
	_update_brightness(SaveSettings.game_data.brightness)

func _process(delta):
	if Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_L):
		if Input.is_key_pressed(KEY_0):
			macro = 0
			$TransitionScreen.transition_macro()
		if Input.is_key_pressed(KEY_1):
			macro = 1
			$TransitionScreen.transition_macro()
		if Input.is_key_pressed(KEY_2):
			macro = 2
			$TransitionScreen.transition_macro()
		if Input.is_key_pressed(KEY_3):
			macro = 3
			$TransitionScreen.transition_macro()
		if Input.is_key_pressed(KEY_4):
			macro = 4
			$TransitionScreen.transition_macro()
		if Input.is_key_pressed(KEY_5):
			macro = 5
			$TransitionScreen.transition_macro()

func _start_game():
	pointer = 0
	$TransitionScreen.transition_to_level_0()

func _to_menu():
	$TransitionScreen.transition_to_menu()

func _to_next_level():
	$TransitionScreen.transition_next_level()

func reconnect():
	$CurrentScene.get_child(0).get_node("PauseMenu").connect("to_menu", self, "_to_menu")
	$CurrentScene.get_child(0).get_node("Player").connect("death", self, "_death")
	if $CurrentScene.get_child(0).get_node("NextLevelArea"):
		$CurrentScene.get_child(0).get_node("NextLevelArea").connect("to_next_level", self, "_to_next_level")
#	for _i in $CurrentScene.get_child(0).get_children():
#		print(_i)
	if $CurrentScene.get_child(0).get_node("CutsceneActivatorEnd"):
		$CurrentScene.get_child(0).get_node("CutsceneActivatorEnd").connect("finish", self, "_to_end")
	$CurrentScene/Spatial/WorldEnvironment.environment.adjustment_enabled = true
	$CurrentScene/Spatial/WorldEnvironment.environment.adjustment_brightness = SaveSettings.game_data.brightness

func reconnect_menu():
	$CurrentScene/Control.connect("startgame", self, "_start_game")
	$CurrentScene/Control.connect("continuegame", self, "_continuegame")
	$CurrentScene/Control.connect("extra", self, "_extra")
	$CurrentScene/Control.connect("close", self, "_close")
	$CurrentScene/Control.connect("credits", self, "_credits")

func _extra():
	$TransitionScreen.transition_extra()

func _close():
	$TransitionScreen.transition_close()

func _death():
	$TransitionScreen.transition_lose()

func _credits():
	$TransitionScreen.transition_credits()

func _to_end():
	$TransitionScreen.transition_end()

func _continuegame(level):
	temp_level = level
	$TransitionScreen.transition_continue()

func _update_brightness(value):
	if ($CurrentScene.get_child(0).name == "Control"):
		# Parche brightness mainmenu
		$CurrentScene/Control/Background/WorldEnvironment.environment.adjustment_enabled = true
		$CurrentScene/Control/Background/WorldEnvironment.environment.adjustment_brightness = value
	else:
		$CurrentScene/Spatial/WorldEnvironment.environment.adjustment_enabled = true
		$CurrentScene/Spatial/WorldEnvironment.environment.adjustment_brightness = value

func _on_TransitionScreen_transitioned():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(level2.instance())

func _on_TransitionScreen_main_menu():
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(main_menu.instance())
	pointer = $CurrentScene/Control.level
	reconnect_menu()

func _on_TransitionScreen_next_level():
	pointer += 1
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(levels[pointer].instance())
	save_level(pointer)
	reconnect()

func _on_TransitionScreen_game_over():
	pass # Replace with function body.

func _on_TransitionScreen_level_0():
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(level0.instance())
	reconnect()

func _on_TransitionScreen_continuen():
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(levels[temp_level].instance())
	reconnect()

func _on_TransitionScreen_extra():
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(demo.instance())
	reconnect()

func _on_TransitionScreen_close():
	get_tree().quit()

func _on_TransitionScreen_lose():
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(game_over.instance())
	$CurrentScene/Control.connect("restart", self, "_to_menu")
	$CurrentScene/Control.connect("close", self, "_close")

func save_level(level):
	var save_file = File.new()
	save_file.open("user://savefile.save", File.WRITE)
	save_file.store_line(String(level))
	save_file.close()

func _on_TransitionScreen_credits():
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(credits.instance())
	$CurrentScene/GodotCredits.connect("restart", self, "_to_menu")
	$CurrentScene/GodotCredits.connect("close", self, "_close")

func _on_TransitionScreen_end():
	save_level(0)
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(credits.instance())
	$CurrentScene/GodotCredits.connect("restart", self, "_to_menu")
	$CurrentScene/GodotCredits.connect("close", self, "_close")

func _on_TransitionScreen_macro():
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(levels[macro].instance())
	reconnect()
